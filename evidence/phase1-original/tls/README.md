# TLS / HTTPS evidence

```bash
curl -v --cacert ../../tls/certs/server.crt \
  --resolve app.teamX.test:443:10.3.3.178 \
  https://app.teamX.test/api/status
```

The verbose output must include certificate verification success. **Do not** use `curl -k`.

Also save Wireshark screenshots of the TLS records if they are not already under `../wireshark/`.

Do not photograph `server.key`.
