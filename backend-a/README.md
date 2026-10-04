# Backend A

Mac 3 (Shubham) — `10.3.3.71:3001`

```bash
node server.js
```

Binds `0.0.0.0` so other LAN hosts can connect. JSON fields: `backend`, `status`, `ip`, `port`. Headers: `X-Backend: A`, `Cache-Control: public, max-age=30`, `ETag`. Conditional GET with matching `If-None-Match` returns 304.

Override bind or reported IP if needed:

```bash
BIND_HOST=0.0.0.0 BACKEND_IP=10.3.3.71 PORT=3001 node server.js
```
