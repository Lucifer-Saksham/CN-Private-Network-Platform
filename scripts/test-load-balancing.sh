#!/usr/bin/env bash
# Six sequential HTTPS (or HTTP fallback) requests to observe round-robin.
# Uses verified TLS when tls/certs/server.crt exists; otherwise HTTP 8080.
# Never uses curl -k.

set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "$0")" && pwd)/common.sh"

ROOT="$(repo_root)"
CACERT="$ROOT/tls/certs/server.crt"

if ! host_up "$NGINX_IP"; then
  blocked "Nginx host $NGINX_IP is not reachable"
  exit 1
fi

fetch() {
  if [[ -f "$CACERT" ]]; then
    curl -sS --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" \
      --cacert "$CACERT" \
      --resolve "${APP_NAME}:${HTTPS_PORT}:${NGINX_IP}" \
      "https://${APP_NAME}/api/status"
  else
    curl -sS --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" \
      "http://${NGINX_IP}:${HTTP_PORT}/api/status"
  fi
}

seq=""
for i in 1 2 3 4 5 6; do
  body="$(fetch || true)"
  id="$(printf '%s' "$body" | sed -n 's/.*"backend": "\([AB]\)".*/\1/p' | head -n 1)"
  if [[ -z "$id" ]]; then
    fail "request $i did not return backend A or B"
    exit 1
  fi
  seq="${seq}${id}"
  echo "request $i -> Backend $id"
done

echo "sequence: $seq"
if [[ "$seq" == "BABABA" || "$seq" == "ABABAB" ]]; then
  pass "round-robin pattern $seq"
  exit 0
fi

fail "sequence $seq is not strict ABABAB or BABABA (still record it as evidence if both backends appeared)"
exit 1
