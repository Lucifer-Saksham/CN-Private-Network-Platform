# Troubleshooting

| Error | Machine / component | Cause | Solution |
| --- | --- | --- | --- |
| `dig app.teamX.test` fails but `dig @10.3.3.96` works | Client | macOS is not using Mac 1 as a resolver | Use `dig @10.3.3.96` for the demo. Changing Wi-Fi DNS can break other name lookups if dnsmasq stops. |
| `dig @10.3.3.96` times out | Mac 1 | dnsmasq not listening on 10.3.3.96:53, or sleep/firewall | `dnsmasq --test`, start the service, `lsof -nP -iUDP:53`, keep Mac 1 awake |
| Ping fails to one Mac | LAN | Asleep, wrong Wi-Fi, DHCP changed IP | Wake the laptop, confirm `ifconfig en0`, update inventory only after verification |
| curl to :3001 or :3002 hangs | Mac 3 / Mac 4 | Process not started, bound only to localhost, or firewall | Start `node server.js`; servers bind `0.0.0.0`. Use `scripts/test-backends.sh` (BLOCKED vs FAIL) |
| Nginx 502 | Mac 2 | Upstream A/B down | Start both Node processes before Nginx tests |
| `nginx -t` cannot open certificate | Mac 2 | Path is still Kavya’s Desktop path, or files missing | Put `server.crt` / `server.key` in `tls/certs/` on that Mac, or load `nginx.conf.template` with a real `REPO_ROOT` |
| Browser NET::ERR_CERT_AUTHORITY_INVALID | Client | Self-signed cert | Expected. Use `curl --cacert tls/certs/server.crt --resolve ...`. Do not use `curl -k` for the graded proof |
| HTTPS works with `-k` only | TLS | Client does not trust the cert | Copy the **public** crt; pass `--cacert`. Never screenshot the private key |
| Load-balancing always one backend | Nginx | Other upstream down or only one Node running | Check both `/api/status` URLs directly |
| Wireshark shows no certificate | Capture | TLS 1.3 encrypts the Certificate message | Say that in the demo. Proof of the cert is `openssl x509` / curl `--cacert`, not a TLS 1.3 pcap |
| Existing pcap has Google/WhatsApp DNS | Mac 1 / Mac 2 | dnsmasq forwarding public queries | Capture a dedicated `dig @10.3.3.96 app.teamX.test` session into `evidence/dns/` |
| 304 not seen in browser | Caching | Browser may reuse memory cache without showing 304 | Use curl `If-None-Match` as in `docs/CACHING.md` |
| Port 443 bind error | Mac 2 | Permission or another process | `sudo` for Nginx, or `lsof -nP -iTCP:443 -sTCP:LISTEN` |
