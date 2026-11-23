#!/usr/bin/env bash
# stop for role: divyanshi  (implementation: scripts/role.sh)
set -euo pipefail
exec "$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/scripts/role.sh" divyanshi stop "$@"
