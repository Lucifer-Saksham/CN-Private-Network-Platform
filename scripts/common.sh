#!/usr/bin/env bash
# Shared inventory for helper scripts. Source this file; do not execute it.

DNS_IP="10.3.3.96"
NGINX_IP="10.3.3.178"
BACKEND_A_IP="10.3.3.71"
BACKEND_B_IP="10.3.3.104"
BACKEND_A_PORT="3001"
BACKEND_B_PORT="3002"
HTTP_PORT="8080"
HTTPS_PORT="443"
APP_NAME="app.teamX.test"
API_NAME="api.teamX.test"

CONNECT_TIMEOUT="3"
MAX_TIME="8"
PING_COUNT="2"

pass() { printf 'PASS  %s\n' "$1"; }
fail() { printf 'FAIL  %s\n' "$1"; }
blocked() { printf 'BLOCKED / MACHINE UNAVAILABLE  %s\n' "$1"; }

host_up() {
  local ip="$1"
  ping -c "$PING_COUNT" -W 2000 "$ip" >/dev/null 2>&1
}

repo_root() {
  cd "$(dirname "$0")/.." && pwd
}
