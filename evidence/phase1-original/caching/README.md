# Caching evidence

Screenshot `Cache-Control: public, max-age=30` from a proxy or backend response.

Optional 304:

```bash
etag=$(curl -sS -D - -o /dev/null http://10.3.3.71:3001/api/status \
  | awk 'BEGIN{IGNORECASE=1} /^ETag:/ {print $2}' | tr -d '\r')
curl -sS -D - -H "If-None-Match: $etag" -o /dev/null http://10.3.3.71:3001/api/status
```

Do not label a file as cache HIT unless the tool actually printed HIT.
