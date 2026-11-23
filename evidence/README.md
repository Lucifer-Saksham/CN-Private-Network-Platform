# Evidence index

Evidence is preserved as captured. Historical transcripts and screenshots must not be
edited to make them match later configuration.

## Phase 1

`phase1-original/` contains the original team screenshots, packet captures, notes, and
manifest for LAN addressing, DNS, TCP, TLS, Nginx, both backends, load balancing,
caching, and Wireshark observations. Its recorded IP addresses describe that earlier
run and are intentionally unchanged.

The local `evidence/2026-11-24-015401/` collection contains the successful deployed
status, DNS, TLS, HTTP/2, load-balancing, cache/304, service, and doctor outputs. These
timestamped collection directories are ignored by default and should be selected for
Git only after a final privacy review.

## Phase 2 transcripts

| Extension | Transcript | Observed result | Status |
|---|---|---|---|
| A | `20261124-014851-dns-failover.txt` | Primary DNS stopped; backup DNS resolved the name and HTTPS returned 200; primary restored | PASS |
| C | `20261124-014903-isolation-test.txt` | Both backend ports were directly reachable because isolation rules were not active | Historical failed attempt |
| D | `20261124-014941-failover.txt` | Backend A stopped; Backend B served all requests; A restarted and A/B balancing resumed | PASS |
| E | `20261124-015023-cutover.txt` | DNS changed to the standby; cached clients moved after TTL expiry; primary restored | PASS |
| E | `20261124-015113-cutover.txt` | Repeated successful primary-to-standby cutover and restoration | PASS |
| C | `20261124-015913-isolation-test.txt` | Direct access to both backends blocked; Nginx path worked with A B A B responses | PASS |

An additional local, untracked intermediate capture,
`20261124-015816-isolation-test.txt`, blocked direct backend access but recorded an
incomplete proxy sequence (`? A B A`). It is preserved unchanged and is not the final
successful Extension C proof.

## Evidence not yet recorded

- Extension B: no standalone transcript of the controlled short-TTL, stale-cache,
  expiry, and cache-flush demonstration. The health check only confirms TTL 300.
- Extension F: the healthy `bin/doctor` output is recorded, but there is no transcript
  of a hidden fault being injected, diagnosed, repaired, and retested.

## Collection commands

```bash
./bin/collect-evidence
scripts/capture-packets.sh 60
```

Timestamped evidence bundles and packet captures are ignored by default. Add only
reviewed files deliberately. Never store private keys, Cloudflare credentials, tokens,
passphrases, or `~/.config/cn-phase1/project.env` here.
