#!/usr/bin/env bash
# HTTPS with certificate verification. Never uses curl -k.

set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "$0")" && pwd)/common.sh"

ROOT="$(repo_root)"
CACERT="$ROOT/tls/certs/server.crt"
url="https://${APP_NAME}/api/status"

if [[ ! -f "$CACERT" ]]; then
  fail "public certificate missing at $CACERT — copy server.crt from Mac 2 (never the private key)"
  exit 1
fi

if ! host_up "$NGINX_IP"; then
  blocked "Nginx host $NGINX_IP is not reachable"
  exit 1
fi

if ! curl -sS -D /tmp/cn-https-headers.txt -o /tmp/cn-https-body.json \
  --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" \
  --cacert "$CACERT" \
  --resolve "${APP_NAME}:${HTTPS_PORT}:${NGINX_IP}" \
  "$url"; then
  fail "verified HTTPS request failed (curl did not use -k)"
  exit 1
fi

rc=0
grep -qi "^HTTP/.* 200" /tmp/cn-https-headers.txt || { fail "HTTPS status is not 200"; rc=1; }
grep -qi "^Cache-Control: public, max-age=30" /tmp/cn-https-headers.txt || { fail "HTTPS missing Cache-Control"; rc=1; }
grep -qi "^X-Backend:" /tmp/cn-https-headers.txt || { fail "HTTPS missing X-Backend"; rc=1; }
grep -q '"status": "healthy"' /tmp/cn-https-body.json || { fail "HTTPS body is not healthy JSON"; rc=1; }

if [[ "$rc" -eq 0 ]]; then
  pass "verified HTTPS $url via --cacert and --resolve"
fi
exit "$rc"
