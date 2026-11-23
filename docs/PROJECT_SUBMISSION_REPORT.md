# CN Private Network Service Platform

## Team and deployment

| Mac | Team member | Role | Recorded LAN address | Service |
|---|---|---|---|---|
| 1 | Saksham Miglani | DNS, controller, client | `10.3.3.146` | dnsmasq `53/udp+tcp` |
| 2 | Kavya Mukhija | primary edge, backup DNS | `10.3.3.139` | nginx `8443/tcp`, dnsmasq `53/udp+tcp` |
| 3 | Shubham Jain | Backend A | `10.3.3.170` | Python HTTP `3001/tcp` |
| 4 | Divyanshi Khanka | Backend B, standby edge | `10.3.3.134` | Python HTTP `3002/tcp`, nginx `8443/tcp` |

LAN: `10.3.0.0/22`, mask `255.255.252.0`, gateway `10.3.0.1`.
Application names: `app.teamX.test` and `api.teamX.test`.

## Request path

1. A client asks the primary or backup dnsmasq server for `app.teamX.test`.
2. DNS returns the active edge address.
3. The client opens TCP port 8443 and validates the edge certificate.
4. Nginx terminates TLS and proxies plain HTTP to Backend A or Backend B.
5. The Python backend returns JSON, cache headers, an ETag, and `X-Backend`.

```text
client -> DNS 10.3.3.146/10.3.3.139 -> nginx 10.3.3.139:8443
       -> Backend A 10.3.3.170:3001 or Backend B 10.3.3.134:3002
```

The optional tunnel mode changes only the edge-to-backend hop. It uses Cloudflare
Zero Trust private routes and does not replace the required four-Mac LAN demo.

## Phase 1 coverage

- LAN inventory and connectivity checks
- private authoritative DNS for the `.teamX.test` zone
- locally generated CA and hostname-valid TLS certificate
- Nginx TLS termination and round-robin proxying
- two Python standard-library REST backends
- `Cache-Control`, ETag, and conditional `304 Not Modified`
- layered tests, evidence collection, bounded packet capture, and failure demos

Run `./bin/test-all` for layered checks and `./bin/doctor` for first-failure
diagnosis. Run `./bin/collect-evidence` only during the real four-Mac deployment.

## Phase 2 coverage

| Extension | Implementation |
|---|---|
| A | backup DNS on Mac 2 and a dual-nameserver scoped resolver |
| B | controlled short-TTL record-change and cache-expiry demonstration |
| C | reversible macOS `pf` anchor allowing only the two edge addresses to backend ports |
| D | Nginx passive failover and backend recovery demonstration |
| E | encrypted certificate bundle, standby nginx, and DNS cutover with TTL observation |
| F | ordered DNS, TCP, TLS, and application diagnosis plus reversible hidden-fault drills |

The operational guide is in `docs/PHASE2.md`. Phase 2 firewall, resolver, certificate
trust, and service changes require operator approval on the relevant Mac.

## Evidence policy

Authentic Phase 1 evidence from this team is archived under
`evidence/phase1-original/`. New Phase 2 evidence belongs under timestamped evidence
folders created by `./bin/collect-evidence` or Phase 2 demo commands. Do not use the
screenshots, transcripts, certificates, or claims of another team as this team's
evidence.

## Validation status

The four-Mac LAN passed Phase 1 health checks on 24 November 2026. Recorded Phase 2
evidence covers DNS failover, backend isolation, backend failover, and standby-edge
cutover. A standalone TTL demonstration and a fault-injection drill still need their
own transcripts; see `docs/VALIDATION.md` and `evidence/README.md`.
