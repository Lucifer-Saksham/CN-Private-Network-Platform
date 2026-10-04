# Caching test plan

## What is implemented

Backend A and Backend B send:

```
Cache-Control: public, max-age=30
ETag: "<sha1 of json body>"
```

on HTTP 200 JSON responses.

They send **304 Not Modified** (no body) when `If-None-Match` equals that ETag.

Nginx does **not** enable `proxy_cache`. It only forwards headers.

## Tests

### 1. Inspect headers

```bash
curl -sS -D - -o /dev/null http://10.3.3.71:3001/api/status
curl -sS -D - -o /dev/null http://10.3.3.178:8080/api/status
```

Record `Cache-Control` and `ETag`. Save under `evidence/caching/`.

### 2. Freshness (explanation, not a HIT)

`max-age=30` allows a cache to reuse the response for 30 seconds. Showing the header proves the response is **cacheable**. It does not prove a cache HIT.

### 3. Conditional request (304)

```bash
etag=$(curl -sS -D - -o /tmp/cn-body.json http://10.3.3.71:3001/api/status \
  | awk 'BEGIN{IGNORECASE=1} /^ETag:/ {print $2}' | tr -d '\r')
curl -sS -D - -H "If-None-Match: $etag" -o /dev/null http://10.3.3.71:3001/api/status
```

Local automation: `scripts/test-local-backends.sh`.

### 4. Do not fake results

Do not add a synthetic `X-Cache: HIT` header. Do not mark LAN 304 complete until a real screenshot exists.

A shared reverse-proxy cache HIT is **not demonstrated**.
