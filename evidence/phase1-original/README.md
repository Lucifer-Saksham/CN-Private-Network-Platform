# Project Evidence

This directory contains screenshots, packet captures, and final demonstration materials for the CN Private Network Platform.

## Evidence locations

| Folder | Purpose |
|---|---|
| `lan/` | Four Mac IP configurations and peer ping |
| `dns/` | Private DNS question/answer and DNS packet capture |
| `backend/` | Backend A and Backend B responses |
| `nginx/` | HTTP response and Nginx validation |
| `load-balancing/` | Repeated requests showing backend selection |
| `tls/` | HTTPS certificate verification and TLS evidence |
| `tcp/` | TCP three-way handshake |
| `caching/` | Cache-Control, ETag, and 304 evidence |
| `wireshark/` | Packet captures and Wireshark analysis |


## Existing evidence

The repository currently contains:

- Network/connectivity screenshot
- DNS-related screenshot
- Backend A and Backend B screenshots
- Nginx-related screenshot
- Two load-balancing screenshots
- TCP handshake screenshot
- TLS handshake screenshot
- TCP/TLS packet capture
- Caching and ETag / 304 screenshot
- DNS packet evidence

See `MANIFEST.md` for file-level status and pending requirements.

## Capture rules

- Use real screenshots and packet captures.
- Prefer descriptive filenames such as `backend-a-response.png`.
- Do not invent results or create fake evidence.
- Do not commit private keys, passwords, tokens, or `.env` files.
- Do not use `curl -k` for certificate-verification proof.
- Keep the evidence manifest synchronized with actual files.
