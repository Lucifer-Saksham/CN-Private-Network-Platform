# Evidence Manifest

This manifest reflects the files currently present in the repository. A file being present does not automatically prove that its contents satisfy the complete grading requirement.

| ID | Evidence requirement | Current status | File / next action |
|---|---|---|---|
| 1 | Four Mac IP configurations | Partial | `evidence/network/Screenshot 2026-10-04 at 6.31.16 PM.png`; capture individual `ifconfig en0` screenshots if required |
| 2 | Peer ping / LAN reachability | Screenshot present; verify visible peer results | `evidence/network/Screenshot 2026-10-04 at 6.31.16 PM.png` |
| 3 | DNS query for `app.teamX.test` | DNS-related screenshot present; dedicated pcap pending | `evidence/network/dns.packets.jpeg`; capture a new pcap under `evidence/dns/` |
| 4 | Backend A response | File present | `evidence/backend/backend a.jpeg` |
| 5 | Backend B response | File present | `evidence/backend/backend b.jpeg` |
| 6 | Nginx HTTP response | File present; verify HTTP 200 and healthy JSON are visible | `evidence/nginx/WhatsApp Image 2026-10-04 at 21.30.09.jpeg` |
| 7 | A/B load balancing | Two screenshots present | `evidence/load-balancing/` |
| 8 | HTTPS certificate verification | Screenshot present; confirm `--cacert` was used and `-k` was not | `evidence/load-balancing/Screenshot 2026-10-04 at 8.18.35 PM.png` |
| 9 | TCP three-way handshake | Screenshot and pcap present | `evidence/tcp/tcp handshake.png`; `evidence/wireshark/tls-handshake.pcapng` |
| 10 | TLS handshake records | Screenshot and pcap present | `evidence/tls/tls handshake.png`; `evidence/wireshark/tls-handshake.pcapng` |
| 11 | Cache-Control header | Response evidence exists; verify header visibility | `evidence/load-balancing/` |
| 12 | Conditional ETag / 304 | Implemented and locally tested; LAN screenshot pending | `scripts/test-local-backends.sh`; `evidence/caching/` |
| 13 | Private-name DNS pcap | Pending | Capture `app.teamX.test` question and `10.3.3.178` answer under `evidence/dns/` |
| 14 | Demo video and verified link | Pending | Record, upload, test link, then add `evidence/demo/drive-link.txt` |

## Packet Capture Note

The existing `evidence/wireshark/tls-handshake.pcapng` contains ARP for the Nginx host, a TCP handshake to port 443, subsequent TLS/TCP payload, and later public-name DNS queries.

It is not a dedicated capture of the `app.teamX.test` DNS question and answer.

## Security

- Do not commit private keys.
- Do not include `.env` files or credentials.
- Do not use `curl -k` as certificate-verification evidence.
- Update evidence status only after checking the actual screenshot or capture.