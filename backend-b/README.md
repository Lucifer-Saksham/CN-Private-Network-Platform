# Backend B

Mac 4 (Divyanshi) — `10.3.3.104:3002`

Port **3002**, not 3001.

```bash
node server.js
```

Binds `0.0.0.0`. JSON fields: `backend`, `status`, `ip`, `port`. Headers: `X-Backend: B`, `Cache-Control: public, max-age=30`, `ETag`. Matching `If-None-Match` returns 304.

```bash
BIND_HOST=0.0.0.0 BACKEND_IP=10.3.3.104 PORT=3002 node server.js
```
