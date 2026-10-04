# Submission checklist

Legend:

- **Completed and verified** — true in this repository or proven by a file you can open.
- **Completed but evidence pending** — implemented; still needs a screenshot, pcap, or video.
- **Remaining manual task** — a person must do this on a Mac, GitHub, or Drive.

## A. Code

- [x] Backend A `GET /` and `GET /api/status` JSON *(completed and verified locally)*
- [x] Backend B `GET /` and `GET /api/status` JSON *(completed and verified locally)*
- [x] Fields `backend`, `status`, `ip`, `port`
- [x] Headers `X-Backend`, `Cache-Control`
- [x] Listen `0.0.0.0`; A=3001; B=3002
- [x] ETag / 304 *(completed and verified locally)*
- [ ] LAN curl screenshots for A and B *(completed but evidence pending)*

## B. Configuration

- [x] `dns/dnsmasq.conf` template for `app.teamX.test` and `api.teamX.test`
- [x] `nginx/nginx.conf` HTTP 8080 + HTTPS 443 + round-robin upstream
- [x] Mac 2 absolute certificate path preserved and documented
- [x] `nginx/nginx.conf.template` with `REPO_ROOT`
- [x] TLS 1.2 and TLS 1.3 in Nginx
- [x] OpenSSL SAN config and generator script
- [ ] Public `tls/certs/server.crt` committed *(remaining manual task on Mac 2)*
- [x] Private key not committed (`.gitignore` `*.key`)
- [ ] `nginx -t` on Mac 2 *(remaining manual task)*
- [ ] `dnsmasq --test` on Mac 1 *(remaining manual task)*

## C. Documentation

- [x] Professional README (no member placeholders)
- [x] Architecture diagram
- [x] IP / MAC table with recorded-address caveat
- [x] Per-Mac setup and startup order
- [x] TLS, caching, Wireshark limitations written honestly
- [x] `docs/PROJECT_AUDIT.md`
- [x] `docs/DEMO_SCRIPT.md`
- [x] `docs/troubleshooting.md`

## D. Evidence

- [x] Folder layout and capture instructions
- [x] `evidence/wireshark/tls-handshake.pcapng` (TCP to :443 + TLS records)
- [ ] IP config screenshots × 4 *(remaining manual task)*
- [ ] Peer ping screenshots *(remaining manual task)*
- [ ] DNS `app.teamX.test` query/answer screenshot **and** pcap *(remaining manual task)*
- [ ] Backend A/B screenshots *(remaining manual task)*
- [ ] Nginx HTTP screenshot *(remaining manual task)*
- [ ] Load-balancing six-request screenshot *(remaining manual task)*
- [ ] HTTPS `--cacert` screenshot *(remaining manual task)*
- [ ] Wireshark TCP/TLS screenshots *(remaining manual task)*
- [ ] Cache-Control screenshot *(remaining manual task)*
- [ ] Optional 304 screenshot *(completed but evidence pending)*

## E. Live demonstration

- [ ] All four Macs awake on the `/22` *(remaining manual task)*
- [ ] Services started in documented order *(remaining manual task)*
- [ ] `scripts/validate-project.sh` run on the LAN *(remaining manual task)*

## F. GitHub

- [ ] Confirm repository is **public** *(remaining manual task)*
- [ ] Teammates invited and accepted *(remaining manual task)*
- [x] `.gitignore` present
- [ ] Push this completion pass *(remaining manual task unless you authorize a push)*
- [ ] No `.key` / `.env` in the pushed tree *(verify with `git ls-files`)*

## G. Video

- [ ] Record ~5 minute MP4 *(remaining manual task)*
- [ ] Name `CN_Phase1_CN-Private-Network-Platform_TeamSaksham_Type1.mp4`
- [ ] Drive link viewer-anyone; incognito test *(remaining manual task)*
- [ ] URL added to README *(remaining manual task)*

## H. Final submission

- [ ] Evidence manifest updated after screenshots
- [ ] README final status updated only after evidence exists
- [ ] Submission notes include https://github.com/Lucifer-Saksham/CN-Private-Network-Platform
