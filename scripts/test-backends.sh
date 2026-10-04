#!/usr/bin/env bash
# Direct HTTP checks against Backend A and Backend B. No TLS, no sudo.

set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "$0")" && pwd)/common.sh"

check_backend() {
  local label="$1" ip="$2" port="$3" expected="$4"
  local url="http://${ip}:${port}/api/status"

  if ! host_up "$ip"; then
    blocked "$label host $ip is not reachable"
    return 1
  fi

  local headers body
  headers="$(curl -sS -D - -o /tmp/cn-backend-body.json \
    --connect-timeout "$CONNECT_TIMEOUT" --max-time "$MAX_TIME" \
    "$url" 2>/tmp/cn-backend-err || true)"

  if [[ ! -s /tmp/cn-backend-body.json ]]; then
    fail "$label did not return a body ($url)"
    return 1
  fi

  local rc=0
  echo "$headers" | grep -qi "^HTTP/.* 200" || { fail "$label HTTP status is not 200"; rc=1; }
  echo "$headers" | grep -qi "^X-Backend: ${expected}" || { fail "$label missing X-Backend: $expected"; rc=1; }
  echo "$headers" | grep -qi "^Cache-Control: public, max-age=30" || { fail "$label missing Cache-Control"; rc=1; }
  grep -q "\"backend\": \"${expected}\"" /tmp/cn-backend-body.json || { fail "$label JSON backend field mismatch"; rc=1; }
  grep -q '"status": "healthy"' /tmp/cn-backend-body.json || { fail "$label JSON status is not healthy"; rc=1; }
  grep -q "\"port\": ${port}" /tmp/cn-backend-body.json || { fail "$label JSON port mismatch"; rc=1; }

  if [[ "$rc" -eq 0 ]]; then
    pass "$label $url"
  fi
  return "$rc"
}

overall=0
check_backend "Backend A" "$BACKEND_A_IP" "$BACKEND_A_PORT" "A" || overall=1
check_backend "Backend B" "$BACKEND_B_IP" "$BACKEND_B_PORT" "B" || overall=1
exit "$overall"
