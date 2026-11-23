# Validation report

Date: 23 November 2026. Branch: `migration/full-reference-parity`.

## Passing safe local checks

- all Bash scripts parse with the macOS Bash 3.2 interpreter
- `backends/server.py` compiles with Python 3
- Backend A and Backend B run simultaneously on loopback test ports
- both backends pass `/api/status`, `/health`, `X-Backend`, `Cache-Control`, ETag,
  and matching `If-None-Match -> 304` checks
- team defaults load as DNS `10.3.3.96`, edge `10.3.3.178`, Backend A
  `10.3.3.71:3001`, Backend B `10.3.3.104:3002`, and port 8443
- dnsmasq and Nginx templates render without unresolved placeholders
- installed dnsmasq accepts the rendered configuration with `--test`
- `pfctl` accepts the generated Backend A and Backend B isolation rules in parse-only
  mode; no rules were loaded
- `phase2 help` and `failure-demo wrong-port explain` complete successfully
- source-parity audit passes: required paths exist, reference-team identifiers are
  absent outside attribution/history, and no imported CA/credential/private-key file
  is present
- the adapted nine-slide Phase 2 deck passes ZIP validation and renders all slides;
  the stricter Office-package checker reports eight unused slide-master content-type
  entries that are also present in the unmodified reference deck
- `git diff --check` passes

## Read-only integration results on this Mac

`./bin/test-all` ran without changing system settings. Prerequisites passed, but DNS,
TCP, TLS, backends, HTTP, load balancing, and cache integration failed because the
four LAN services and the newly generated team certificate are not deployed here.

`PHASE2=1 ./bin/phase2 test` likewise confirmed that primary/backup DNS, primary and
standby edges, both remote backends, and the full-path doctor are not live. These are
deployment failures, not passing local tests. The isolation check now also fails when
the intended edge path is unavailable, avoiding a false positive inherited from the
reference implementation.

Nginx is not installed on this Mac, so `nginx -t` could not run. The rendered file was
checked for expected listeners/upstreams and unresolved template variables; Kavya must
run the real syntax check after Nginx and the new certificate exist.

## Outstanding four-Mac deployment checks

1. Confirm all four current `en0` addresses, `/22` mask, and gateway. If DHCP changed
   any address, reconfigure all four Macs together.
2. Start Shubham's and Divyanshi's Python backends and prove direct edge reachability.
3. Run Kavya's setup, generate this team's CA/server certificate, validate Nginx, and
   commit only the public `pki/ca.crt` after fingerprint review.
4. Run Saksham's DNS setup and configure at least two clients. Verify app and API
   records on primary and backup DNS.
5. Run verified HTTPS, round-robin, ETag/304, packet capture, evidence collection,
   `test-all`, and `doctor` on the LAN.
6. Phase 2 A: stop primary DNS and prove cached and uncached clients continue through
   the backup; restore primary DNS.
7. Phase 2 B: record direct DNS and macOS cached answers across the controlled TTL
   change and restoration.
8. Phase 2 C: after explicit approval, load the named `pf` anchor on both backends,
   prove edge access and client blocking, then roll back and verify prior pf state.
9. Phase 2 D: stop each backend in turn, prove uninterrupted service through the
   survivor, restart it, and prove load balancing resumes.
10. Phase 2 E: securely transfer the encrypted edge bundle, start Divyanshi's standby
    Nginx, verify `X-Edge`, update both DNS copies, observe TTL cutover, and restore.
11. Phase 2 F: inject one reversible unknown fault, diagnose DNS to application order,
    repair it, and save the transcript.
12. Optional tunnel mode: create fresh Cloudflare resources and credentials, verify
    WARP split-tunnel policy and both private routes, and never commit credentials.
