# Evidence

Put real screenshots and captures in the folders below. Do not add fake “screenshot.txt” stand-ins.

## Checklist

1. [ ] IP configuration for four Macs → `lan/`
2. [ ] Successful peer ping → `lan/`
3. [ ] DNS query and answer for `app.teamX.test` → `dns/`
4. [ ] Backend A response → `backend/`
5. [ ] Backend B response → `backend/`
6. [ ] Nginx HTTP 8080 response → `nginx/`
7. [ ] Repeated A/B load balancing → `load-balancing/`
8. [ ] HTTPS certificate verification (`curl --cacert`, no `-k`) → `tls/`
9. [ ] TCP three-way handshake → `tcp/` and/or `wireshark/`
10. [ ] TLS handshake → `tls/` and/or `wireshark/`
11. [ ] HTTP headers including Cache-Control → `caching/`
12. [ ] Cache 304 or documented skip → `caching/`
13. [ ] Final end-to-end demo video → `demo/` (or Drive link in README)

## Already in Git

- `wireshark/tls-handshake.pcapng` — TCP handshake to `10.3.3.178:443` plus TLS records. See `MANIFEST.md`.

## Capture rules

- PNG or JPEG for terminals/Wireshark windows.
- pcapng for packets.
- No private keys, no `.env`, no passwords.
- File names: `YYYYMMDD_short-description.png` (use the real date).
