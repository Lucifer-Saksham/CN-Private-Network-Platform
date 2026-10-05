# CN Private Network Platform

**Computer Networks Project — Phase 1**
**Infrastructure type:** Type 1 — 4 physical macOS laptops on the same LAN

A private LAN-based network platform demonstrating **local DNS, Nginx reverse proxying, load balancing, HTTPS/TLS, backend services, HTTP caching, conditional requests, and packet-level analysis** across four macOS systems.

Repository: <https://github.com/Lucifer-Saksham/CN-Private-Network-Platform>

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Objectives](#2-objectives)
3. [Team Members](#3-team-members)
4. [Network Configuration](#4-network-configuration)
5. [Architecture](#5-architecture)
6. [Private DNS](#6-private-dns)
7. [Backend Servers](#7-backend-servers)
8. [Nginx Reverse Proxy and Load Balancing](#8-nginx-reverse-proxy-and-load-balancing)
9. [HTTPS / TLS](#9-https--tls)
10. [HTTP Caching and Conditional Requests](#10-http-caching-and-conditional-requests)
11. [How to Run (Setup per Mac)](#11-how-to-run-setup-per-mac)
12. [Client Setup (DNS and Certificate Trust)](#12-client-setup-dns-and-certificate-trust)
13. [Testing Commands](#13-testing-commands)
14. [Wireshark and Packet Analysis](#14-wireshark-and-packet-analysis)
15. [Failure Demonstration](#15-failure-demonstration)
16. [Project Structure](#16-project-structure)
17. [Evidence](#17-evidence)
18. [Demo Video](#18-demo-video)
19. [Security Considerations](#19-security-considerations)
20. [Limitations](#20-limitations)
21. [Conclusion](#21-conclusion)

---

## 1. Project Overview

Four Macs work together as a small distributed system. A client types a private domain name, the name is resolved by our own DNS server, an HTTPS connection is made to our Nginx edge, and the request is forwarded to one of two backend servers.

The platform provides:

- Private LAN connectivity
- Local DNS using `dnsmasq`
- Two independent Node.js backend servers
- Nginx reverse proxy with round-robin load balancing
- HTTP and HTTPS access
- Self-signed TLS certificate with Subject Alternative Names
- HTTP caching using `Cache-Control`
- Conditional requests using `ETag` / `If-None-Match` (`304 Not Modified`)
- TCP, TLS and DNS packet analysis using Wireshark

Application URLs (both names resolve to the Nginx server):

```text
https://app.teamX.test
https://api.teamX.test
http://app.teamX.test:8080
```

Request flow:

```text
Client -> DNS query (Mac 1) -> HTTPS request (Mac 2 / Nginx) -> Backend A (Mac 3) or Backend B (Mac 4)
```

---

## 2. Objectives

1. Configure a private LAN between four Macs.
2. Configure a local DNS resolver using dnsmasq.
3. Resolve private domain names to the Nginx server.
4. Deploy two independent Node.js backend servers.
5. Configure Nginx as a reverse proxy.
6. Implement round-robin load balancing.
7. Configure HTTPS using a self-signed TLS certificate.
8. Demonstrate DNS, TCP and TLS handshakes using Wireshark.
9. Implement HTTP caching using `Cache-Control`.
10. Implement conditional requests using `ETag` and `304 Not Modified`.
11. Demonstrate a controlled failure and recovery.

---

## 3. Team Members

| Enrollment No. | Name | Machine | Role |
| -------------- | ---- | ------- | ---- |
| 2401010401 | Saksham Miglani | Mac 1 | Private DNS (dnsmasq) and test client |
| 2401010452 | Kavya Mukhija | Mac 2 | Nginx reverse proxy, load balancer, HTTPS |
| 2401010452 | Shubham Jain | Mac 3 | Backend A (Node.js, port 3001) |
| 2401010159 | Divyanshi Khanka | Mac 4 | Backend B (Node.js, port 3002) and test client |

---

## 4. Network Configuration

```text
Network:      10.3.0.0/22
Subnet mask:  255.255.252.0
Gateway:      10.3.0.1
Interface:    en0 (Wi-Fi) on all machines
```

| Machine | Role | IPv4 | Subnet | Gateway | Interface | Service / Port |
| ------- | ---- | ---- | ------ | ------- | --------- | -------------- |
| Mac 1 | DNS / client | 10.3.3.96 | /22 | 10.3.0.1 | en0 | dnsmasq, UDP/TCP 53 |
| Mac 2 | Nginx edge | 10.3.3.178 | /22 | 10.3.0.1 | en0 | HTTP 8080, HTTPS 443 |
| Mac 3 | Backend A | 10.3.3.71 | /22 | 10.3.0.1 | en0 | Node.js 3001 |
| Mac 4 | Backend B | 10.3.3.104 | /22 | 10.3.0.1 | en0 | Node.js 3002 |

MAC addresses and the full inventory are in [`docs/ip-table.md`](docs/ip-table.md). They are the `en0` addresses recorded at inventory time; macOS may use randomized private Wi-Fi addresses.

> If DHCP changes an address, verify with `ifconfig en0` and update this table, `dns/dnsmasq.conf`, and `nginx/nginx.conf`.

---

## 5. Architecture

```text
                         PRIVATE LAN 10.3.0.0/22
                                  |
                          +---------------+
                          |    Mac 1      |
                          |  DNS/Client   |
                          |  10.3.3.96    |
                          |  dnsmasq :53  |
                          +-------+-------+
                                  |
                    app.teamX.test / api.teamX.test
                          resolve to 10.3.3.178
                                  |
                                  v
                          +---------------+
                          |    Mac 2      |
                          |    Nginx      |
                          |  10.3.3.178   |
                          | HTTP  :8080   |
                          | HTTPS :443    |
                          +-------+-------+
                                  |
                          Round-robin proxy
                           /              \
                          v                v
                  +--------------+  +--------------+
                  |    Mac 3     |  |    Mac 4     |
                  |  Backend A   |  |  Backend B   |
                  |  10.3.3.71   |  |  10.3.3.104  |
                  |    :3001     |  |    :3002     |
                  +--------------+  +--------------+
```

Cloud equivalents: dnsmasq is like a managed DNS service (Route 53); Nginx is like a cloud load balancer / CDN edge (AWS ALB); the backends are like application server instances.

Protocol layers involved in one request:

| Layer | Protocol |
| ----- | -------- |
| Application | DNS, HTTP |
| Session / Security | TLS |
| Transport | UDP (DNS, port 53), TCP (HTTPS, port 443) |
| Network | IPv4 |
| Link | Ethernet / Wi-Fi |

---

## 6. Private DNS

`dnsmasq` runs on Mac 1 (`10.3.3.96`) and answers for the private `.test` namespace (not `.local`, which conflicts with macOS mDNS).

Records:

```text
app.teamX.test  ->  10.3.3.178
api.teamX.test  ->  10.3.3.178
```

Relevant lines from `dns/dnsmasq.conf`:

```text
interface=en0
listen-address=127.0.0.1
listen-address=10.3.3.96
address=/app.teamX.test/10.3.3.178
address=/api.teamX.test/10.3.3.178
local-ttl=30
server=8.8.8.8
```

- `listen-address` includes the LAN IP so other Macs can use this DNS server.
- `server=` forwards all other names, so clients keep internet access.
- Because `.test` is not a real public TLD, `dig @8.8.8.8 app.teamX.test` returns `NXDOMAIN` (or times out), proving the name is private.

DNS resolution only finds the IP address. The TCP/TLS connection to that address is a separate step.

---

## 7. Backend Servers

Two independent Node.js services using only the standard library.

| Backend | Machine | IP | Port |
| ------- | ------- | -- | ---- |
| A | Mac 3 | 10.3.3.71 | 3001 |
| B | Mac 4 | 10.3.3.104 | 3002 |

Both bind to `0.0.0.0` so other LAN machines can reach them.

Endpoints:

| Endpoint | Response |
| -------- | -------- |
| `GET /` | Basic JSON confirming the service is running |
| `GET /api/status` | JSON with `backend`, `status`, `ip`, `port` |

Response headers include:

```text
X-Backend: A        (or B on Backend B)
Cache-Control: public, max-age=30
ETag: "..."
```

---

## 8. Nginx Reverse Proxy and Load Balancing

Nginx on Mac 2 (`10.3.3.178`) is the single entry point. Clients never connect to backends directly and never need to know their IPs.

- HTTP listener: `8080`
- HTTPS listener: `443` (TLS 1.2 and TLS 1.3)
- Upstream group with Backend A and Backend B
- Default **round-robin** strategy

```nginx
upstream backend {
    server 10.3.3.71:3001;
    server 10.3.3.104:3002;
}

server {
    listen 443 ssl;
    server_name app.teamX.test api.teamX.test;

    ssl_certificate     /path/to/tls/certs/server.crt;
    ssl_certificate_key /path/to/tls/certs/server.key;
    ssl_protocols       TLSv1.2 TLSv1.3;

    location / {
        proxy_pass http://backend;
        proxy_set_header Host $host;
    }
}
```

The actual file is [`nginx/nginx.conf`](nginx/nginx.conf). A portable version with a `REPO_ROOT` placeholder is [`nginx/nginx.conf.template`](nginx/nginx.conf.template).

Repeated requests alternate:

```text
Request 1 -> Backend A
Request 2 -> Backend B
Request 3 -> Backend A
Request 4 -> Backend B
```

Verify with the `X-Backend` header.

---

## 9. HTTPS / TLS

- Nginx terminates TLS on port 443.
- The certificate is self-signed (RSA 2048) with SANs for `app.teamX.test` and `api.teamX.test`.
- Generate with `tls/generate-self-signed.sh` using `tls/openssl.cnf`.
- The **public** certificate is committed; the **private key is never committed** (`*.key` is in `.gitignore`).
- Every client Mac must trust the certificate so `curl` and browsers do not warn. The demo never uses `curl -k`.

Handshake summary:

1. **TCP handshake** — SYN, SYN-ACK, ACK.
2. **ClientHello** — TLS versions, cipher suites, SNI.
3. **ServerHello** — chosen version and cipher.
4. **Certificate** — server identity (visible in TLS 1.2 captures; encrypted in TLS 1.3).
5. **Key exchange / Finished** — session keys established.
6. **Application Data** — HTTP is encrypted from here on.

---

## 10. HTTP Caching and Conditional Requests

Backend responses send:

```text
Cache-Control: public, max-age=30
```

This means the response is fresh for 30 seconds and may be reused without contacting the server. After that it is stale and must be refetched or revalidated.

Backends also send an `ETag`. A client can revalidate with `If-None-Match`:

```text
Client -> GET /api/status
Server -> 200 OK, ETag: "abc"

Client -> GET /api/status, If-None-Match: "abc"
Server -> 304 Not Modified (no body)
```

Because round-robin may send the revalidation to the other backend, demonstrate `304` against one backend directly:

```bash
curl -i http://10.3.3.71:3001/api/status
curl -i -H 'If-None-Match: "<etag-from-above>"' http://10.3.3.71:3001/api/status
```

Nginx here is a proxy only; it is not configured as a content cache.

---

## 11. How to Run (Setup per Mac)

Clone the repo on every Mac:

```bash
git clone https://github.com/Lucifer-Saksham/CN-Private-Network-Platform.git
cd CN-Private-Network-Platform
```

### Startup order

1. Confirm all four Macs can ping each other (`scripts/check-lan.sh`).
2. Start dnsmasq on Mac 1.
3. Start Backend A on Mac 3.
4. Start Backend B on Mac 4.
5. Start Nginx on Mac 2.
6. Validate from a client (`scripts/validate-project.sh`).

### Mac 1 — DNS (Saksham)

```bash
brew install dnsmasq
# copy dns/dnsmasq.conf to the path Homebrew prints, e.g. /opt/homebrew/etc/dnsmasq.conf
dnsmasq --test
sudo brew services start dnsmasq
dig @10.3.3.96 app.teamX.test +short      # expect 10.3.3.178
```

Allow dnsmasq through the macOS firewall so other Macs can query it.

### Mac 2 — Nginx (Kavya)

```bash
brew install nginx openssl
bash tls/generate-self-signed.sh          # if certs do not exist yet
nginx -t -c /absolute/path/to/nginx/nginx.conf
sudo nginx -c /absolute/path/to/nginx/nginx.conf
```

`nginx.conf` contains an absolute certificate path. If the clone is elsewhere, copy `nginx.conf.template` and replace `REPO_ROOT`. Binding to port 443 requires `sudo`.

### Mac 3 — Backend A (Shubham)

```bash
cd backend-a
node server.js        # listens on 0.0.0.0:3001
```

### Mac 4 — Backend B (Divyanshi)

```bash
cd backend-b
node server.js        # listens on 0.0.0.0:3002
```

Keep all laptops awake and on the same Wi-Fi/LAN during the demo. Turn off macOS firewall stealth mode (or allow ICMP) so ping works between all Macs.

---

## 12. Client Setup (DNS and Certificate Trust)

Run on every client Mac (at least two besides Mac 1):

```bash
# 1. Use Mac 1 as DNS resolver (check service name with: networksetup -listallnetworkservices)
sudo networksetup -setdnsservers Wi-Fi 10.3.3.96
sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder

# 2. Trust the project certificate
sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain tls/certs/server.crt

# 3. Verify
dig app.teamX.test                 # SERVER line must show 10.3.3.96
curl -v https://app.teamX.test     # no -k, no IP address
```

Use macOS's built-in `/usr/bin/curl`; Homebrew curl does not read the system keychain.

To restore the original DNS afterwards:

```bash
sudo networksetup -setdnsservers Wi-Fi empty
```

---

## 13. Testing Commands

### LAN

```bash
ping -c 4 10.3.3.96
ping -c 4 10.3.3.178
ping -c 4 10.3.3.71
ping -c 4 10.3.3.104
```

### DNS

```bash
dig app.teamX.test               # from a client Mac using Mac 1 as DNS
dig @10.3.3.96 api.teamX.test
dig @8.8.8.8 app.teamX.test      # expect NXDOMAIN or timeout
```

### Backends directly

```bash
curl -i http://10.3.3.71:3001/api/status
curl -i http://10.3.3.104:3002/api/status
```

### Nginx HTTP and HTTPS

```bash
curl -i http://app.teamX.test:8080/api/status
curl -v https://app.teamX.test
```

### Load balancing

```bash
for i in {1..6}; do curl -si https://app.teamX.test/api/status | grep -i x-backend; done
```

Expected: `X-Backend` alternates between `A` and `B`.

### Caching headers

```bash
curl -sI https://app.teamX.test/api/status
```

### Helper scripts

```bash
bash scripts/check-lan.sh
bash scripts/test-dns.sh
bash scripts/test-https.sh
bash scripts/test-load-balancing.sh
bash scripts/validate-project.sh
```

Scripts report `PASS`, `FAIL`, or `BLOCKED` when a machine is unavailable.

---

## 14. Wireshark and Packet Analysis

Capture on a client or on Mac 1/Mac 2 `en0`. Useful filters:

| Evidence | Filter | What to point out |
| -------- | ------ | ----------------- |
| DNS | `dns` | Query `A app.teamX.test` from a client to `10.3.3.96:53` (UDP); response `10.3.3.178` with TTL |
| TCP handshake | `tcp.flags.syn==1` | SYN, SYN-ACK, ACK to `10.3.3.178:443`; ephemeral source port |
| TLS handshake | `tls` | ClientHello, ServerHello, Certificate (TLS 1.2), then Application Data |

To make the server certificate visible in Wireshark, force TLS 1.2:

```bash
curl --tlsv1.2 --tls-max 1.2 https://app.teamX.test/
```

In TLS 1.3 the certificate and HTTP data are encrypted, so only Application Data records are visible. HTTP headers cannot be read in the capture because they are inside encrypted TLS records.

Captures are stored in `evidence/wireshark/`. The existing `tls-handshake.pcapng` contains the TCP handshake to `10.3.3.178:443` and the following TLS records.

---

## 15. Failure Demonstration

**Scenario: Option A — stop one backend.**

| Step | Action | Expected result |
| ---- | ------ | --------------- |
| Before | Run the 6-request loop | `X-Backend` alternates A and B |
| Break | On Mac 3, press `Ctrl+C` on `node server.js` | Backend A stops |
| After | Run the loop again | Only `X-Backend: B`, still HTTP 200 |
| Restore | On Mac 3 run `node server.js` | A and B alternate again |

Layer affected: application/transport at the backend. DNS and TLS still work, Nginx accepts the client connection, but TCP to `10.3.3.71:3001` is refused and Nginx retries on Backend B.

---

## 16. Project Structure

```text
CN-Private-Network-Platform/
├── README.md
├── .gitignore
├── backend-a/            server.js, package.json        (Mac 3, :3001)
├── backend-b/            server.js, package.json        (Mac 4, :3002)
├── dns/                  dnsmasq.conf
├── nginx/                nginx.conf, nginx.conf.template
├── tls/                  openssl.cnf, generate-self-signed.sh, certs/server.crt
├── scripts/              check-lan, test-*, validate-project
├── docs/                 architecture, CACHING, ip-table, PROJECT_AUDIT,
│                         troubleshooting
└── evidence/             backend, caching, dns, lan, load-balancing, network,
                          nginx, tcp, tls, wireshark
```

---

## 17. Evidence

The project evidence is organised under `evidence/` and matches the final implementation.

| Evidence | Location |
|---|---|
| LAN configuration and peer connectivity | `evidence/lan/` and `evidence/network/` |
| DNS resolution and DNS packet analysis | `evidence/dns/` and `evidence/network/dns.packets.jpeg` |
| Backend A and Backend B | `evidence/backend/` |
| Nginx HTTP response | `evidence/nginx/` |
| Load balancing | `evidence/load-balancing/` |
| Cache-Control and ETag / 304 | `evidence/caching/` |
| TCP three-way handshake | `evidence/tcp/` |
| TLS / HTTPS evidence | `evidence/tls/` |
| Wireshark packet analysis | `evidence/wireshark/` |

See [`evidence/MANIFEST.md`](evidence/MANIFEST.md) for the complete evidence inventory.

---

## 18. Demo Video

Link: `<paste Google Drive link here after testing it in an incognito window>`

File name: `CN_Phase1_Section-D_[TeamName]_Type1.mp4`

Requirements: MP4, 1080p recommended, maximum 5 minutes, maximum 500 MB, shared as "Anyone with the link can view".

Contents: team intro and setup flow (2 min), how the configuration works (2 min), failure demonstration (1 min). Script: [`docs/DEMO_SCRIPT.md`](docs/DEMO_SCRIPT.md).

---

## 19. Security Considerations

- Intended for a controlled private LAN.
- The TLS certificate is self-signed; clients must explicitly trust it.
- The private key (`server.key`) is never committed.
- No passwords, API keys, or secrets are stored in the repository.
- Backends bind to LAN interfaces as the architecture requires; restricting them to the edge only is a Phase 2 task.

---

## 20. Limitations

- Self-signed certificate; browsers warn unless it is trusted manually.
- DNS names exist only on the project LAN.
- Single DNS server and single Nginx edge are single points of failure (addressed in Phase 2).
- Basic round-robin with simple failure handling.
- All four Macs must stay awake on the same LAN; DHCP changes require updating IPs.

---

## 21. Conclusion

The project demonstrates a complete private-network application stack:

```text
Private LAN -> Local DNS -> Nginx Reverse Proxy (HTTPS) -> Round-Robin -> Backend A + Backend B
```

together with HTTP caching, conditional requests, and packet-level analysis of DNS, TCP and TLS using Wireshark.
