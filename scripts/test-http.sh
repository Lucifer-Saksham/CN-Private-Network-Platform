#!/usr/bin/env bash
# HTTP (port 8080) through Nginx. Does not use HTTPS and does not skip TLS.

set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "$0")" && pwd)/common.sh"

url="http://${NGINX_IP}:${HTTP_PORT}/api/status"

if ! host_up "$NGINX_IP"; then
  blocked "Nginx host $NGINX_IP is not reachable"
  exit 1
fi

if ! curl -sS -D /tmp/cn-http-headers.txt -o /tmp/cn-http-body.json \
  --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" \
  "$url"; then
  fail "HTTP request to $url failed"
  exit 1
fi

if grep -qi "^HTTP/.* 200" /tmp/cn-http-headers.txt \
  && grep -q '"status": "healthy"' /tmp/cn-http-body.json; then
  pass "Nginx HTTP 8080 returned healthy JSON"
  exit 0
fi

fail "Nginx HTTP 8080 response was not a healthy 200 JSON body"
exit 1
