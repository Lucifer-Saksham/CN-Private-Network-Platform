# Validation record

This document separates historical deployment results from checks performed during
repository cleanup. It does not claim that the four-Mac LAN was rerun during cleanup.

## 23 November 2026: pre-deployment validation

Before the physical deployment, safe local checks confirmed:

- macOS Bash 3.2 syntax across the shell command surface
- Python 3 compilation and simultaneous loopback execution of Backend A and B
- `/api/status`, `/health`, `X-Backend`, `Cache-Control`, ETag, and conditional 304
- template rendering without unresolved variables
- dnsmasq configuration validation
- generated `pf` rules accepted in parse-only mode without loading the firewall
- Phase 2 help and failure-explanation commands
- slide-package rendering and Git whitespace checks

Read-only integration tests failed at that time because the four remote services and
team certificate had not yet been deployed. Those failures are historical
pre-deployment results, not the final system status.

## 24 November 2026: successful four-Mac LAN integration

The team reported the following results from the physical four-Mac deployment using
the verified addresses documented in the README:

### Phase 1

- Prerequisites: PASS
- LAN information: PASS
- Primary DNS: PASS
- Client resolver: PASS
- TCP connectivity: PASS
- TLS certificate verification: PASS
- TLS 1.3: PASS
- Backend A: PASS
- Backend B: PASS
- HTTP/2: PASS
- HTTP status endpoint: PASS
- Load balancing: PASS, alternating A/B with four responses from each backend
- Cache-Control: PASS
- ETag: PASS
- Conditional HTTP 304: PASS

Final reported output:

```text
ALL TESTS PASS - PHASE 1 SYSTEM HEALTHY
```

### Phase 2

- Extension A: primary and backup DNS responding
- Extension B: DNS TTL configured at 300 seconds
- Extension C: direct backend access blocked while Nginx proxy access remained working
- Extension D: both backends healthy and load balancing
- Extension E: primary and standby Nginx edges healthy
- Extension F: the layer-by-layer network doctor passed

Final doctor output:

```text
All layers healthy.
```

The Phase 2 transcript index is in `evidence/README.md`. A 300-second TTL check confirms
configuration but does not by itself prove the standalone Extension B controlled-TTL
demonstration. A healthy doctor run confirms the current path but does not prove that
an Extension F hidden fault was injected, diagnosed, and repaired.

## 24 November 2026: repository-cleanup checks

The cleanup audit performed static and local checks only:

- repository structure, verified topology, team identity, and secret-exclusion audit: PASS
- macOS Bash 3.2 syntax for operational and test scripts: PASS
- Python 3 compilation: PASS
- loopback Backend A/B identity, Cache-Control, shared ETag, and conditional 304: PASS
- dnsmasq template rendering and `dnsmasq --test`: PASS
- Nginx template rendering, current upstreams, listener, and placeholder checks: PASS
- current `pf` allow-list generation and parse-only validation for ports 3001/3002: PASS
- Phase 2 help and failure explanation commands: PASS
- internal Markdown and HTML file-link check: PASS
- slide ZIP validation, all-slide rendering, and visual review: PASS
- Git whitespace check and repository-wide legacy-reference search: PASS

Nginx is not installed on the cleanup Mac, so a new local `nginx -t` was not run.
The successful physical deployment remains the relevant Nginx integration result.
ShellCheck is not installed, so the audit used Bash 3.2 parser checks rather than
ShellCheck diagnostics.

These cleanup checks did not modify DNS, Keychain trust, the firewall, or running
services, and they do not constitute a new four-Mac test.

## Remaining evidence gaps

- No standalone Extension B TTL demonstration transcript is committed.
- No Extension F fault-injection, diagnosis, and repair transcript is committed.
- Optional Cloudflare tunnel mode was not revalidated during repository cleanup.
