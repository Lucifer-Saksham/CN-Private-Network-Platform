#!/usr/bin/env bash
# Start both backends on 127.0.0.1 and check JSON, headers, and 304.
# Does not require the four-Mac LAN.

set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck source=common.sh
source "$ROOT/scripts/common.sh"

A_PORT=3001
B_PORT=3002

cleanup() {
  if [[ -n "${A_PID:-}" ]]; then kill "$A_PID" 2>/dev/null || true; fi
  if [[ -n "${B_PID:-}" ]]; then kill "$B_PID" 2>/dev/null || true; fi
}
trap cleanup EXIT

BIND_HOST=127.0.0.1 BACKEND_IP=10.3.3.71 PORT="$A_PORT" node "$ROOT/backend-a/server.js" >/tmp/cn-a.log 2>&1 &
A_PID=$!
BIND_HOST=127.0.0.1 BACKEND_IP=10.3.3.104 PORT="$B_PORT" node "$ROOT/backend-b/server.js" >/tmp/cn-b.log 2>&1 &
B_PID=$!

sleep 0.4

check() {
  local name="$1" url="$2" expected="$3" port="$4"
  curl -sS -D /tmp/cn-loc-h.txt -o /tmp/cn-loc-b.json \
    --connect-timeout 2 --max-time 5 "$url"
  grep -qi "^HTTP/.* 200" /tmp/cn-loc-h.txt
  grep -qi "^X-Backend: ${expected}" /tmp/cn-loc-h.txt
  grep -qi "^Cache-Control: public, max-age=30" /tmp/cn-loc-h.txt
  grep -qi "^ETag:" /tmp/cn-loc-h.txt
  grep -q "\"backend\": \"${expected}\"" /tmp/cn-loc-b.json
  grep -q '"status": "healthy"' /tmp/cn-loc-b.json
  grep -q "\"port\": ${port}" /tmp/cn-loc-b.json
  etag="$(awk 'BEGIN{IGNORECASE=1} /^ETag:/ {print $2}' /tmp/cn-loc-h.txt | tr -d '\r')"
  code="$(curl -sS -o /dev/null -w '%{http_code}' --connect-timeout 2 --max-time 5 \
    -H "If-None-Match: ${etag}" "$url")"
  [[ "$code" == "304" ]]
  pass "$name JSON, headers, and 304"
}

rc=0
check "Backend A" "http://127.0.0.1:${A_PORT}/api/status" A "$A_PORT" || { fail "local Backend A"; rc=1; }
check "Backend B" "http://127.0.0.1:${B_PORT}/api/status" B "$B_PORT" || { fail "local Backend B"; rc=1; }
exit "$rc"
