# Evidence manifest

| ID | Required item | Status | File |
| --- | --- | --- | --- |
| 1 | Four Mac IP config | PENDING | — |
| 2 | Peer ping | PENDING | — |
| 3 | DNS app.teamX.test | PENDING | — |
| 4 | Backend A | PENDING | — |
| 5 | Backend B | PENDING | — |
| 6 | Nginx HTTP | PENDING | — |
| 7 | Load balancing sequence | PENDING | — |
| 8 | HTTPS --cacert | PENDING | — |
| 9 | TCP handshake | PRESENT (pcap; Wireshark screenshot still pending) | `evidence/wireshark/tls-handshake.pcapng` |
| 10 | TLS handshake records | PRESENT (pcap; screenshot pending; certificate bytes not claimed) | `evidence/wireshark/tls-handshake.pcapng` |
| 11 | Cache-Control header | PENDING | — |
| 12 | Cache 304 / HIT | PENDING (304 implemented in code; LAN proof absent) | — |
| 13 | Demo video | PENDING | — |

Historical lab notes exist in `docs/PROJECT_AUDIT.md`. They are not files in this folder.
