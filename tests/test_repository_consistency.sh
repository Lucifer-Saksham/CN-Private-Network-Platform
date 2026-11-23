#!/usr/bin/env bash
# Safe repository audit. Does not start services or change macOS settings.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

required=(
  admin/bootstrap-cloudflare.sh backends/server.py
  bin/start bin/stop bin/status bin/teardown bin/test-all bin/doctor
  bin/collect-evidence bin/failure-demo bin/phase2
  config/project.example.env config/dns/dnsmasq.conf.template
  config/nginx/nginx.conf.template
  scripts/common.sh scripts/checks.sh scripts/roles.sh scripts/role.sh scripts/phase2.sh
  tests/test_dns.sh tests/test_tcp.sh tests/test_tls.sh tests/test_backends.sh
  tests/test_http.sh tests/test_load_balancing.sh tests/test_cache.sh tests/test_phase2.sh
  macs/mac1-saksham/setup.sh macs/mac2-kavya/setup.sh
  macs/mac3-shubham/setup.sh macs/mac4-divyanshi/setup.sh
  pki/ca.crt
)

for path in "${required[@]}"; do
  [[ -f "$path" ]] || { echo "FAIL missing $path" >&2; exit 1; }
done

if rg -n --hidden -g '!.git/**' -g '!evidence/phase1-original/**' -g '!*.pdf' -g '!*.pptx' \
  -g '!tests/test_repository_consistency.sh' \
  '10\.3\.3\.(96|178|71|104)' .; then
  echo "FAIL stale current-topology or team identifier" >&2
  exit 1
fi

! find . -type f \( -name '*.key' -o -name 'credentials*.json' -o -name '*.token' \) \
  -not -path './.git/*' -not -path './work/*' -print -quit | grep -q . || {
  echo "FAIL secret-like file present" >&2
  exit 1
}

grep -q '^DNS_IP=10.3.3.146' config/project.example.env
grep -q '^EDGE_IP=10.3.3.139' config/project.example.env
grep -q '^SHUBHAM_LAN_IP=10.3.3.170' config/project.example.env
grep -q '^DIVYANSHI_LAN_IP=10.3.3.134' config/project.example.env
grep -q '^BACKEND_B_OWNER=Divyanshi' config/project.example.env
grep -q '^EDGE_PORT=8443' config/project.example.env
grep -q '^BACKEND_A_PORT=3001' config/project.example.env
grep -q '^BACKEND_B_PORT=3002' config/project.example.env

echo "PASS repository structure, team topology, and secret exclusions"
