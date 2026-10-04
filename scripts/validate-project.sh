#!/usr/bin/env bash
# Local checks that do not require the four-Mac LAN, then optional live tests.

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=common.sh
source "$ROOT/scripts/common.sh"

echo "=== Local repository checks ==="
rc=0

command -v node >/dev/null || { fail "node is not installed"; rc=1; }
command -v openssl >/dev/null || { fail "openssl is not installed"; rc=1; }

if command -v nginx >/dev/null; then
  if nginx -t -c "$ROOT/nginx/nginx.conf" 2>/tmp/cn-nginx-t.txt; then
    pass "nginx -t accepted nginx/nginx.conf"
  else
    echo "NOTE  nginx -t did not succeed on this machine (typical when Mac 2 certificate paths are absent):"
    cat /tmp/cn-nginx-t.txt || true
  fi
else
  echo "NOTE  nginx is not installed on this machine; skipped nginx -t"
fi

if [[ -f "$ROOT/tls/certs/server.crt" ]]; then
  openssl x509 -in "$ROOT/tls/certs/server.crt" -noout -text >/tmp/cn-cert.txt
  grep -q "app.teamX.test" /tmp/cn-cert.txt && pass "server.crt contains app.teamX.test" || { fail "server.crt missing app.teamX.test SAN"; rc=1; }
  grep -q "api.teamX.test" /tmp/cn-cert.txt && pass "server.crt contains api.teamX.test" || { fail "server.crt missing api.teamX.test SAN"; rc=1; }
else
  echo "NOTE  tls/certs/server.crt is not in the repo yet (copy the public certificate only)"
fi

if [[ -f "$ROOT/tls/certs/server.key" ]]; then
  fail "private key tls/certs/server.key is present in the working tree — do not commit it"
  rc=1
else
  pass "no private key file tracked in tls/certs/"
fi

echo
echo "=== Local backend process checks ==="
if "$ROOT/scripts/test-local-backends.sh"; then
  :
else
  fail "local backend checks"
  rc=1
fi

echo
echo "=== Optional live network checks ==="
echo "These report BLOCKED if a Mac is asleep or off the LAN."
"$ROOT/scripts/check-lan.sh" || true
"$ROOT/scripts/test-dns.sh" || true
"$ROOT/scripts/test-backends.sh" || true
"$ROOT/scripts/test-http.sh" || true
"$ROOT/scripts/test-https.sh" || true
"$ROOT/scripts/test-load-balancing.sh" || true

exit "$rc"
