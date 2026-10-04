# Project audit — CN Private Network Platform

Audit date: 4 October 2026
Repository inspected: local clone of https://github.com/Lucifer-Saksham/CN-Private-Network-Platform
Method: full tree listing, file reads, `tcpdump` on the only packet capture, local Node backend tests. Live four-Mac services were **not** assumed to be up.

## Baseline before this completion pass

The GitHub tree contained folder placeholders (`README.md` only), a project README with `[Member 2]` / “to be added” text, `.gitignore`, and one untracked capture `evidence/wireshark/tls-handshake.pcapng`. There was **no** backend source, **no** dnsmasq file, **no** Nginx file, **no** certificate, and **no** scripts.

## Live checks during this documentation pass (4 October 2026)

From Mac 1’s network (this clone):

- ICMP: Mac 1 `10.3.3.96` **PASS**; Mac 2, Mac 3, Mac 4 **BLOCKED**
- `dig @10.3.3.96 app.teamX.test +short` → `10.3.3.178` **PASS**
- `dig @10.3.3.96 api.teamX.test +short` → `10.3.3.178` **PASS**
- HTTPS script **FAIL** because `tls/certs/server.crt` is not in the clone
- Local Node backends (loopback) **PASS** including 304

These dig results re-confirm the historical DNS mapping. They are still not a screenshot in `evidence/dns/`.

- `dig @10.3.3.96 app.teamX.test +short` → `10.3.3.178`
- Backend A `10.3.3.71:3001` healthy JSON, `X-Backend: A`, `Cache-Control: public, max-age=30`
- Backend B `10.3.3.104:3002` healthy JSON, `X-Backend: B`, same Cache-Control
- Nginx HTTP 8080 / HTTPS 443, upstreams A:3001 and B:3002
- Six HTTPS requests: B, A, B, A, B, A
- `curl --cacert … --resolve app.teamX.test:443:10.3.3.178` succeeded without `-k`
- System DNS after restoring Wi-Fi settings was inconsistent

## Requirements matrix

| Requirement | Current state | Existing evidence | Missing work | Priority | Completion status |
| --- | --- | --- | --- | --- | --- |
| Public GitHub repo with this name | Remote exists and is in use | Git remotes | Confirm visibility/settings in the GitHub UI | Medium | PARTIALLY COMPLETE |
| README with real team, IPs, architecture | Rewritten in this pass | `README.md` | Demo URL after upload | High | IMPLEMENTED, EVIDENCE NEEDED |
| Four-Mac IP inventory | Documented; MACs labelled as recorded en0 values | `docs/ip-table.md`; ARP in pcap matches Mac 2 | Screenshots of `ifconfig en0` on all four | High | IMPLEMENTED, EVIDENCE NEEDED |
| LAN ping | Scripts ready; not executed as a verified lab this pass | None in `evidence/lan/` | Four pings + screenshot | High | BLOCKED BY LIVE NETWORK |
| dnsmasq A records | Template `dns/dnsmasq.conf` in repo; live `dig @10.3.3.96` succeeded this pass | Historical dig; this pass also PASS; pcap still lacks `app.teamX.test` | Capture of `app.teamX.test` Q/A; screenshot | High | IMPLEMENTED, EVIDENCE NEEDED |
| Client system DNS | Intentionally not automated | Historical inconsistency | Manual Wi-Fi DNS only if required | Medium | NOT APPLICABLE |
| Backend A source | `backend-a/server.js` on 0.0.0.0:3001 | Local script PASS; no LAN screenshot | Screenshot of LAN curl | High | IMPLEMENTED, EVIDENCE NEEDED |
| Backend B source | `backend-b/server.js` on 0.0.0.0:3002 | Local script PASS; no LAN screenshot | Screenshot of LAN curl | High | IMPLEMENTED, EVIDENCE NEEDED |
| JSON fields backend/status/ip/port | Implemented | Local test | LAN evidence | High | IMPLEMENTED, EVIDENCE NEEDED |
| Headers X-Backend + Cache-Control | Implemented | Local test; historical LAN | LAN header screenshot | High | IMPLEMENTED, EVIDENCE NEEDED |
| Nginx HTTP 8080 | `nginx/nginx.conf` | Historical; no screenshot | `nginx -t` on Mac 2 + curl 8080 | High | IMPLEMENTED, EVIDENCE NEEDED |
| Nginx HTTPS 443 TLS 1.2/1.3 | Configured; cert paths are Mac 2 Desktop path | TCP/TLS pcap to :443 | Public `server.crt` in repo; `--cacert` screenshot | High | PARTIALLY COMPLETE |
| Round-robin | Default upstream; no ip_hash | Historical BABABA | Six-request terminal screenshot | High | IMPLEMENTED, EVIDENCE NEEDED |
| Portable Nginx path | Template with `REPO_ROOT`; working file keeps Kavya path | Files in `nginx/` | Mac 2 must confirm path still matches the live service | High | IMPLEMENTED, EVIDENCE NEEDED |
| Self-signed SAN cert | Generator + openssl.cnf | Historical success | Commit **public** crt only; never the key | High | PARTIALLY COMPLETE |
| No private key in Git | `.gitignore` has `*.key`; validator fails if key present | Working tree should not contain `server.key` | Keep key only on Mac 2 disk | High | COMPLETE AND VERIFIED |
| curl -k forbidden in final proof | Scripts never pass `-k` | Code inspection | Operator must not use `-k` in demo | High | COMPLETE AND VERIFIED |
| Cache-Control max-age=30 | Sent by backends | Local headers; historical LAN | Header screenshot through Nginx | High | IMPLEMENTED, EVIDENCE NEEDED |
| Cache HIT / 304 on LAN | 304 implemented locally | `scripts/test-local-backends.sh` | LAN `If-None-Match` screenshot | Medium | PARTIALLY COMPLETE |
| Wireshark TCP handshake | Present in pcap | `evidence/wireshark/tls-handshake.pcapng` | Screenshot of Wireshark TCP pane | High | IMPLEMENTED, EVIDENCE NEEDED |
| Wireshark TLS handshake | Payload after handshake to :443 | Same pcap | Screenshot; do not claim visible cert for TLS 1.3 | High | IMPLEMENTED, EVIDENCE NEEDED |
| Wireshark DNS for app.teamX.test | Not in current pcap | Only public-name DNS in that file | New capture | High | NOT IMPLEMENTED |
| Demo video | Not in repo | None | Record, upload, incognito-test link | High | NOT IMPLEMENTED |
| Evidence folder taxonomy | lan/dns/backend/nginx/tls/tcp/caching/load-balancing/wireshark/demo | README + manifest | Actual screenshots | High | PARTIALLY COMPLETE |
| Helper scripts | Added under `scripts/` | Local backend test | Live script run on LAN | Medium | IMPLEMENTED, EVIDENCE NEEDED |
| frostyfri.day as production name | Early placeholder only | None | Do not use; names are `*.teamX.test` | High | NOT APPLICABLE |

## Status meanings used above

- **COMPLETE AND VERIFIED** — confirmed in this clone (files/commands), not a guessed LAN result.
- **IMPLEMENTED, EVIDENCE NEEDED** — code or docs exist; screenshot/pcap/video still missing.
- **PARTIALLY COMPLETE** — some of the requirement is real, some is not.
- **NOT IMPLEMENTED** — not present.
- **BLOCKED BY LIVE NETWORK** — needs the four Macs reachable.
- **NOT APPLICABLE** — out of scope or deliberately not automated.

## Security notes

- `.gitignore` ignores `*.key`, `*.pem`, `.env`, `node_modules`.
- Public certificates should use `tls/certs/server.crt` (`.crt` is not ignored).
- Nginx error/access logs go to `/tmp` in the sample config so they are not committed.
- Do not paste `server.key` into issues, README, or screenshots.
