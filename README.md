# CN Private Network Service Platform

A four-Mac Computer Networks project covering private DNS, TCP, TLS 1.3, HTTP/2,
Nginx reverse proxying, Python backends, round-robin load balancing, HTTP caching,
failure recovery, network isolation, and layered diagnostics.

Phase 1 builds and observes the complete request path. Phase 2 adds Extensions A-F:
backup DNS, TTL and cache demonstrations, backend isolation, backend failover,
standby-edge cutover, and fault diagnosis.

## Verified four-Mac topology

The following addresses were verified on 24 November 2026. They are DHCP addresses,
not permanent assignments.

| Mac | Team member | Verified LAN IP | Responsibility | Ports |
|---|---|---:|---|---|
| 1 | Saksham Miglani | `10.3.3.146` | Primary DNS, controller, client | DNS 53 |
| 2 | Kavya Mukhija | `10.3.3.139` | Primary Nginx TLS edge, backup DNS | HTTPS 8443, DNS 53 |
| 3 | Shubham Jain | `10.3.3.170` | Python Backend A | HTTP 3001 |
| 4 | Divyanshi Khanka | `10.3.3.134` | Python Backend B, standby Nginx edge | HTTP 3002, HTTPS 8443 |

- Interface: `en0`
- Subnet: `10.3.0.0/22` (`255.255.252.0`)
- Gateway: `10.3.0.1`
- Hostnames: `app.teamX.test`, `api.teamX.test`
- Public entry point: `https://app.teamX.test:8443`

The setup scripts save deployment-specific values in
`~/.config/cn-phase1/project.env` with mode 600. Never commit that file. If Wi-Fi or
DHCP changes an address, update the file on all four Macs or rerun each setup script,
then restart the services.

## Requirements

- Four Macs on the same non-isolated Wi-Fi/LAN for the submitted LAN topology
- macOS, Homebrew, Git, Python 3, OpenSSL, `curl`, `dig`, and `nc`
- `dnsmasq` on the DNS Macs and Nginx on the edge Macs
- Administrator access for DNS port 53, Keychain trust, packet capture, and Phase 2
  `pf` rules
- Optional: Wireshark for packet inspection and Cloudflare Zero Trust for tunnel mode

The scripts install missing Homebrew packages during setup. Review setup scripts before
running them because they can request administrator access.

## Installation and setup

Clone the repository on every Mac. Run setup in this order:

| Order | Operator | Command |
|---|---|---|
| 1 | Shubham | `./macs/mac3-shubham/setup.sh` |
| 1 | Divyanshi | `./macs/mac4-divyanshi/setup.sh` |
| 2 | Kavya | `./macs/mac2-kavya/setup.sh` |
| 3 | Saksham | `./macs/mac1-saksham/setup.sh` |

Kavya's setup creates the team CA and server certificate. Only the public
`pki/ca.crt` belongs in Git. Private keys remain under
`~/.config/cn-phase1/tls/`. Each additional client installs the public CA and runs
`scripts/configure-client-dns.sh`.

Start, inspect, and stop the role assigned to the current Mac:

```bash
./bin/start
./bin/status
./bin/stop
```

## Request path

1. The macOS scoped resolver sends `app.teamX.test` to primary DNS
   `10.3.3.146:53`, with `10.3.3.139:53` available as backup.
2. DNS returns the active edge address with a 300-second TTL.
3. The client opens TCP port 8443 on the selected edge.
4. Nginx presents a certificate for `app.teamX.test` and negotiates TLS 1.3 and
   HTTP/2.
5. Nginx terminates TLS and proxies plain HTTP to Backend A or Backend B.
6. Round robin alternates requests; `X-Backend: A|B` makes the selected backend
   visible. Passive health checks retry a surviving backend after a failure.

See [request flow](docs/REQUEST_FLOW.md) and [architecture](docs/ARCHITECTURE.md).

## Caching

`/api/cacheable` returns `Cache-Control: max-age=60` and an ETag. A matching
`If-None-Match` request returns `304 Not Modified` without a response body.

```bash
curl -i https://app.teamX.test:8443/api/cacheable
etag=$(curl -sSI https://app.teamX.test:8443/api/cacheable | awk -F': ' 'tolower($1)=="etag" {gsub("\r", "", $2); print $2}')
curl -i -H "If-None-Match: $etag" https://app.teamX.test:8443/api/cacheable
```

## Phase 2 Extensions A-F

Run `./bin/phase2 setup` on each Mac, then use:

| Extension | Demonstration | Command |
|---|---|---|
| A | Primary and backup DNS failover | `./bin/phase2 dns-failover` |
| B | Short TTL, cached address, expiry, and flush | `./bin/phase2 ttl` |
| C | Only primary/standby edges reach backend ports | `./bin/phase2 isolate on\|test\|off` |
| D | Backend outage and automatic recovery | `./bin/phase2 failover` |
| E | DNS-based cutover to standby Nginx | `./bin/phase2 cutover` |
| F | Layered diagnosis and reversible fault drill | `./bin/doctor`, `./bin/phase2 drill` |

Full procedures and limitations are in [Phase 2](docs/PHASE2.md).

## Verification

```bash
./bin/test-all
PHASE2=1 ./bin/phase2 test
./bin/doctor
./bin/collect-evidence
```

Useful manual checks:

```bash
dig @10.3.3.146 app.teamX.test
nc -vz 10.3.3.139 8443
openssl s_client -connect 10.3.3.139:8443 -servername app.teamX.test -CAfile pki/ca.crt
curl -v https://app.teamX.test:8443/api/status
```

The verified 24 November results and the distinction between recorded evidence and
cleanup-time checks are documented in [validation](docs/VALIDATION.md).

## Evidence

- `evidence/phase1-original/`: preserved Phase 1 screenshots, packet captures, and notes
- `evidence/phase2/`: Phase 2 failover, isolation, and cutover transcripts
- `evidence/<timestamp>/`: output produced by `./bin/collect-evidence` and ignored by
  default until deliberately selected

See the [evidence index](evidence/README.md). Never store keys, tokens, passphrases,
credentials, or private environment files in evidence.

## Troubleshooting and rollback

Run `./bin/doctor` first. It checks local network, DNS, TCP, TLS, Nginx, backends,
backup DNS, standby edge, and the application in request order. See
[troubleshooting](docs/TROUBLESHOOTING.md) for common failures.

```bash
./bin/phase2 rollback   # restore Phase 2 DNS/firewall state
./bin/teardown          # stop project services and restore scoped resolver state
```

Rollback scripts operate only on project-managed state and saved backups. Inspect the
commands before running them on a demonstration Mac.

## Optional tunnel mode

`NETWORK_MODE=tunnel` uses Cloudflare Zero Trust only for the edge-to-backend hop when
the backend Macs are remote. It does not replace the submitted four-Mac LAN topology.
Credentials stay under `~/.config/cn-phase1/secrets/` and must never enter Git. See
[Cloudflare mode](docs/CLOUDFLARE_MODE.md).

## Documentation

[Architecture](docs/ARCHITECTURE.md) · [Phase 1](docs/PHASE1.md) ·
[Phase 2](docs/PHASE2.md) · [LAN mode](docs/LAN_MODE.md) ·
[Failure demonstrations](docs/FAILURE_DEMOS.md) · [Troubleshooting](docs/TROUBLESHOOTING.md) ·
[Viva guide](docs/VIVA.md) · [Validation](docs/VALIDATION.md)
