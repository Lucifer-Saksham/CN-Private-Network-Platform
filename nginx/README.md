# Nginx — Mac 2

Kavya Mukhija, `10.3.3.178`.

- HTTP `8080`
- HTTPS `443`
- Upstream `10.3.3.71:3001` and `10.3.3.104:3002`
- Load balancing: default round-robin (no `ip_hash`)
- TLS 1.2 and TLS 1.3

## Working config vs template

`nginx.conf` is the Mac 2 working copy. Certificate paths are:

```
/Users/kavyamukhija/Desktop/CN-Private-Network-Platform/tls/certs/server.crt
/Users/kavyamukhija/Desktop/CN-Private-Network-Platform/tls/certs/server.key
```

If the live clone is not on Kavya’s Desktop, **do not guess**. Copy `nginx.conf.template`, replace `REPO_ROOT` with the real absolute path, run `nginx -t`, then reload. Changing the Git copy of `nginx.conf` on a different laptop will not update the process already running on Mac 2.

Logs in this sample file go to `/tmp/cn-nginx-access.log` and `/tmp/cn-nginx-error.log`.

## Validate and run

```bash
nginx -t -c /Users/kavyamukhija/Desktop/CN-Private-Network-Platform/nginx/nginx.conf
sudo nginx -c /Users/kavyamukhija/Desktop/CN-Private-Network-Platform/nginx/nginx.conf
```

Reload after edits: `sudo nginx -s reload` (only if this is the running config).

Port 443 usually needs root. Confirm nothing else owns 443: `lsof -nP -iTCP:443 -sTCP:LISTEN`.

## Tests

```bash
curl -sS -D - http://10.3.3.178:8080/api/status
bash ../scripts/test-https.sh
bash ../scripts/test-load-balancing.sh
```
