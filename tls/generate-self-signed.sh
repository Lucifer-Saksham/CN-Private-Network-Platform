#!/usr/bin/env bash
# Generate a self-signed RSA 2048 certificate for app.teamX.test / api.teamX.test.
# Run on Mac 2. Does not install the certificate into the system trust store.
# Never commit tls/certs/server.key.

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CERT_DIR="$ROOT/tls/certs"
CONF="$ROOT/tls/openssl.cnf"

mkdir -p "$CERT_DIR"

if [[ -f "$CERT_DIR/server.key" || -f "$CERT_DIR/server.crt" ]]; then
  echo "A certificate or key already exists in $CERT_DIR"
  echo "Refusing to overwrite. Move the existing files aside first."
  exit 1
fi

openssl req -x509 -newkey rsa:2048 -sha256 -days 365 -nodes \
  -keyout "$CERT_DIR/server.key" \
  -out "$CERT_DIR/server.crt" \
  -config "$CONF"

chmod 600 "$CERT_DIR/server.key"
chmod 644 "$CERT_DIR/server.crt"

echo "Wrote $CERT_DIR/server.crt (public; may be committed)"
echo "Wrote $CERT_DIR/server.key (private; gitignored — do not upload)"
echo
echo "Inspect SANs:"
echo "  openssl x509 -in $CERT_DIR/server.crt -noout -text | grep -A3 'Subject Alternative Name'"
echo
echo "This script does not add the certificate to Keychain. Clients should use:"
echo "  curl --cacert $CERT_DIR/server.crt --resolve app.teamX.test:443:10.3.3.178 https://app.teamX.test/api/status"
