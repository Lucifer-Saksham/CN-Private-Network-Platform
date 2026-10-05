# Evidence Manifest

This manifest reflects the final evidence currently present in the repository. The implementation and project evidence are complete; the only remaining submission item is the final demonstration video.

| ID | Evidence requirement | Status | File |
|---|---|---|---|
| 1 | Four Mac IP configurations | Complete | `evidence/lan/WhatsApp Image 2026-10-04 at 21.29.52.jpeg`; `evidence/lan/WhatsApp Image 2026-10-04 at 21.29.54.jpeg` |
| 2 | Peer ping / LAN reachability | Complete | `evidence/lan/WhatsApp Image 2026-10-04 at 21.29.52.jpeg`; `evidence/lan/WhatsApp Image 2026-10-04 at 21.29.54.jpeg` |
| 3 | DNS query for `app.teamX.test` | Complete | `evidence/dns/dns.packets.jpeg`; `evidence/network/dns.packets.jpeg` |
| 4 | Backend A response | Complete | `evidence/backend/backend a.jpeg` |
| 5 | Backend B response | Complete | `evidence/backend/backend b.jpeg` |
| 6 | Nginx HTTP response | Complete | `evidence/nginx/WhatsApp Image 2026-10-04 at 21.30.09.jpeg` |
| 7 | A/B load balancing | Complete | `evidence/load-balancing/Screenshot 2026-10-04 at 8.18.35 PM.png`; `evidence/load-balancing/Screenshot 2026-10-04 at 8.56.40 PM.png` |
| 8 | HTTPS certificate verification | Complete | `evidence/load-balancing/Screenshot 2026-10-04 at 8.18.35 PM.png` |
| 9 | TCP three-way handshake | Complete | `evidence/tcp/tcp handshake.png`; `evidence/wireshark/tls-handshake.pcapng` |
| 10 | TLS handshake records | Complete | `evidence/tls/tls handshake.png`; `evidence/wireshark/tls-handshake.pcapng` |
| 11 | Cache-Control header | Complete | `evidence/caching/Screenshot 2026-10-04 at 9.30.17 PM.png` |
| 12 | Conditional ETag / 304 | Complete | `evidence/caching/Screenshot 2026-10-04 at 9.30.17 PM.png` |
| 13 | Private-name DNS packet analysis | Complete | `evidence/dns/dns.packets.jpeg`; `evidence/network/dns.packets.jpeg` |
| 14 | Demo video and verified link | Pending | Final demonstration video |

## Packet Capture Note

The repository contains Wireshark evidence covering DNS, TCP and TLS traffic. The DNS evidence includes the private `app.teamX.test` resolution and the corresponding Nginx address.

The TCP/TLS packet capture is stored at:

`evidence/wireshark/tls-handshake.pcapng`

## Security

- Do not commit private keys.
- Do not include `.env` files or credentials.
- Do not use `curl -k` as certificate-verification evidence.
- Keep the evidence manifest synchronized with the actual repository files.
