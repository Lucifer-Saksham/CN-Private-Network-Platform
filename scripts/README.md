# Helper scripts

All scripts print `PASS`, `FAIL`, or `BLOCKED / MACHINE UNAVAILABLE`. They do not change Wi-Fi DNS, do not use `sudo`, and never pass `curl -k`.

| Script | Purpose |
| --- | --- |
| `check-lan.sh` | ICMP to the four inventory IPs |
| `test-dns.sh` | `dig @10.3.3.96` for both names |
| `test-backends.sh` | Direct A/B HTTP |
| `test-http.sh` | Nginx :8080 |
| `test-https.sh` | HTTPS with `--cacert` |
| `test-load-balancing.sh` | Six requests |
| `test-local-backends.sh` | Start A/B on 127.0.0.1 and check 200 + 304 |
| `validate-project.sh` | Local checks, then optional live checks |

If a laptop is asleep, treat BLOCKED as the correct outcome, not PASS.
