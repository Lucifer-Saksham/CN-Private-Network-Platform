#!/usr/bin/env bash
# Ping the four recorded LAN addresses. Does not change network settings.

set -euo pipefail
# shellcheck source=common.sh
source "$(cd "$(dirname "$0")" && pwd)/common.sh"

rc=0
declare -a hosts=(
  "Mac 1 DNS|$DNS_IP"
  "Mac 2 Nginx|$NGINX_IP"
  "Mac 3 Backend A|$BACKEND_A_IP"
  "Mac 4 Backend B|$BACKEND_B_IP"
)

for entry in "${hosts[@]}"; do
  name="${entry%%|*}"
  ip="${entry##*|}"
  if host_up "$ip"; then
    pass "$name ($ip) responds to ping"
  else
    blocked "$name ($ip) did not answer ICMP"
    rc=1
  fi
done

exit "$rc"
