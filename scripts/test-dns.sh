#!/usr/bin/env bash
# Query Mac 1 dnsmasq directly. Does not change Wi-Fi DNS settings.

set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "$0")" && pwd)/common.sh"

if ! host_up "$DNS_IP"; then
  blocked "DNS host $DNS_IP is not reachable"
  exit 1
fi

if ! command -v dig >/dev/null 2>&1; then
  fail "dig is not installed (bind or bind-utils)"
  exit 1
fi

rc=0
for name in "$APP_NAME" "$API_NAME"; do
  answer="$(dig @"$DNS_IP" "$name" +short +time=3 +tries=1 2>/dev/null | head -n 1 || true)"
  if [[ "$answer" == "$NGINX_IP" ]]; then
    pass "$name -> $answer via $DNS_IP"
  elif [[ -z "$answer" ]]; then
    fail "no A record for $name from $DNS_IP"
    rc=1
  else
    fail "$name resolved to '$answer' (expected $NGINX_IP)"
    rc=1
  fi
done

exit "$rc"
