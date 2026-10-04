# Five-minute demonstration script

Video file (when recorded): `CN_Phase1_CN-Private-Network-Platform_TeamSaksham_Type1.mp4`
Format: MP4, 1080p recommended, ~5 minutes, ≤ 500 MB.
Upload: Google Drive, “anyone with the link” as viewer. Test in an incognito window before submission.

Do not narrate a result you did not just produce on camera. If a Mac is asleep, say so and mark the step blocked.

Startup before recording (off camera is acceptable if you show a quick ping): DNS → Backend A → Backend B → Nginx.

## 0:00–0:30 — Introduction and architecture

Show `README.md` architecture (or `docs/architecture.md`) and say:

Four Macs on one `/22`. Mac 1 is DNS. Mac 2 is Nginx on 8080 and 443. Mac 3 is Backend A on 3001. Mac 4 is Backend B on 3002. Names `app.teamX.test` and `api.teamX.test` both point at Nginx.

## 0:30–1:00 — LAN and IP table

On Mac 1:

```bash
ifconfig en0 | sed -n '1,8p'
ping -c 2 10.3.3.178
ping -c 2 10.3.3.71
ping -c 2 10.3.3.104
```

Expected when the LAN is up: echo replies from the three peers. Save a screenshot to `evidence/lan/`.

## 1:00–1:30 — DNS

```bash
dig @10.3.3.96 app.teamX.test +short
dig @10.3.3.96 api.teamX.test +short
```

Expected when dnsmasq is serving the project zone:

```
10.3.3.178
10.3.3.178
```

Do not claim macOS “just resolves” those names unless you also show `scutil --dns` or a successful lookup **without** `@10.3.3.96`. Prefer the `@` form.

## 1:30–2:00 — Direct backends

```bash
curl -sS -D - http://10.3.3.71:3001/api/status
curl -sS -D - http://10.3.3.104:3002/api/status
```

Expected:

- HTTP 200
- `Content-Type: application/json`
- `X-Backend: A` then `X-Backend: B`
- `Cache-Control: public, max-age=30`
- JSON with `"backend"`, `"status": "healthy"`, `"ip"`, `"port"` matching 3001 / 3002

## 2:00–2:45 — Nginx load balancing

```bash
for i in 1 2 3 4 5 6; do
  curl -sS http://10.3.3.178:8080/api/status | grep backend
done
```

Historical sequence when both upstreams were healthy: B, A, B, A, B, A (starting backend depends on Nginx’s current peer). Any strict alternation of A and B is a valid round-robin demo. If one backend is down, say so; Nginx will keep using the live peer.

## 2:45–3:30 — HTTPS and certificate verification

On a client that has the **public** certificate file (not the key):

```bash
curl -sS -D - --cacert tls/certs/server.crt \
  --resolve app.teamX.test:443:10.3.3.178 \
  https://app.teamX.test/api/status
```

Expected: certificate verification successful, HTTP 200, `X-Backend`, `Cache-Control`, healthy JSON.

Do not use `curl -k`. If `server.crt` is missing, stop and copy it from Mac 2.

Optional inspect:

```bash
openssl s_client -connect 10.3.3.178:443 -servername app.teamX.test </dev/null 2>/dev/null | openssl x509 -noout -subject -ext subjectAltName
```

## 3:30–4:15 — Wireshark TCP and TLS

Open `evidence/wireshark/tls-handshake.pcapng` (or a fresh capture).

Display filter examples:

```
tcp.flags.syn == 1
tcp.port == 443
tls || ssl
dns
```

Point to SYN, SYN-ACK, ACK between `10.3.3.96` and `10.3.3.178:443`. Then point to TLS records. Say clearly: if the session is TLS 1.3, the Certificate handshake message may be encrypted and **not** readable in this capture.

If you need DNS packets for `app.teamX.test`, capture while running the `dig` command; the existing file mainly shows a 443 handshake plus later public-name DNS.

## 4:15–4:40 — Headers and caching

From any successful API response, highlight `Cache-Control: public, max-age=30`.

Explain: this marks the response cacheable for 30 seconds; it is not a cache HIT.

Optional 304 (only if you run it live):

```bash
etag=$(curl -sS -D - -o /dev/null http://10.3.3.71:3001/api/status | awk 'BEGIN{IGNORECASE=1} /^ETag:/ {print $2}' | tr -d '\r')
curl -sS -D - -H "If-None-Match: $etag" -o /dev/null http://10.3.3.71:3001/api/status
```

Expected if the server in this repository is running: `304`. If you skip this, say 304 was verified locally with `scripts/test-local-backends.sh` and not shown on the LAN.

## 4:40–5:00 — Summary and limitations

- Private LAN only, self-signed cert, four machines must stay awake.
- Prefer `dig @10.3.3.96` over changing system DNS.
- No public hosting, no private key on GitHub.

## After recording

1. Name the file as specified.
2. Upload to Drive.
3. Set link sharing to viewer for anyone with the link.
4. Open the link in incognito.
5. Paste the working URL into `README.md` section 18.
