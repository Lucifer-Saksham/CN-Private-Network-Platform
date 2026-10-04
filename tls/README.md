# TLS

HTTPS terminates on Mac 2. The **public** certificate may be committed as `tls/certs/server.crt`. The **private key** `tls/certs/server.key` must never be committed, logged, or screenshotted.

`.gitignore` already ignores `*.key` and `*.pem`.

## Names

- `app.teamX.test`
- `api.teamX.test`
- optional IP SAN `10.3.3.178` (in `openssl.cnf`)

RSA 2048, SHA-256, TLS 1.2 and TLS 1.3 at Nginx.

## Generate on Mac 2 (does not trust the cert system-wide)

```bash
bash tls/generate-self-signed.sh
```

If files already exist, the script refuses to overwrite them.

Inspect:

```bash
openssl x509 -in tls/certs/server.crt -noout -text | grep -A4 'Subject Alternative Name'
```

## Trust

This project does **not** claim a Keychain install. Graded verification:

```bash
curl --cacert tls/certs/server.crt \
  --resolve app.teamX.test:443:10.3.3.178 \
  https://app.teamX.test/api/status
```

`curl -k` is not acceptable as final proof.

If you later add the cert to System keychain, re-test without `--cacert` and only then claim system trust.

## Copy to Git

After generation, `git add tls/certs/server.crt` only. Run `git status` and confirm `server.key` is ignored.
