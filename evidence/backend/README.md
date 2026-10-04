# Backend evidence

```bash
curl -sS -D - http://10.3.3.71:3001/api/status
curl -sS -D - http://10.3.3.104:3002/api/status
```

Each screenshot must show JSON fields `backend`, `status`, `ip`, `port` and headers `X-Backend`, `Cache-Control`.
