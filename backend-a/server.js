'use strict';

/**
 * Backend A — Mac 3
 * Listens on 0.0.0.0:3001 so other LAN hosts can reach this process.
 *
 * Endpoints:
 *   GET /            — identification JSON
 *   GET /api/status  — health JSON used by Nginx and the demo
 *
 * Headers:
 *   Content-Type: application/json
 *   X-Backend: A
 *   Cache-Control: public, max-age=30
 *   ETag: SHA-1 of the JSON body (quoted)
 *
 * Conditional GET: if If-None-Match matches the ETag, respond 304 with no body.
 */

const http = require('http');
const crypto = require('crypto');

const BACKEND_ID = 'A';
const PORT = Number(process.env.PORT || 3001);
const HOST = process.env.BIND_HOST || '0.0.0.0';
const REPORTED_IP = process.env.BACKEND_IP || '10.3.3.71';

function payload() {
  return {
    backend: BACKEND_ID,
    status: 'healthy',
    ip: REPORTED_IP,
    port: PORT,
    message: 'Backend A',
  };
}

function sendJson(req, res, object) {
  const body = JSON.stringify(object, null, 2) + '\n';
  const etag = '"' + crypto.createHash('sha1').update(body).digest('hex') + '"';
  const headers = {
    'Content-Type': 'application/json; charset=utf-8',
    'X-Backend': BACKEND_ID,
    'Cache-Control': 'public, max-age=30',
    ETag: etag,
  };

  if (req.headers['if-none-match'] === etag) {
    res.writeHead(304, {
      'X-Backend': BACKEND_ID,
      'Cache-Control': 'public, max-age=30',
      ETag: etag,
    });
    res.end();
    return;
  }

  res.writeHead(200, headers);
  res.end(body);
}

function sendError(res, statusCode, message) {
  const body = JSON.stringify({
    backend: BACKEND_ID,
    status: 'error',
    ip: REPORTED_IP,
    port: PORT,
    error: message,
  }, null, 2) + '\n';
  res.writeHead(statusCode, {
    'Content-Type': 'application/json; charset=utf-8',
    'X-Backend': BACKEND_ID,
    'Cache-Control': 'no-store',
  });
  res.end(body);
}

const server = http.createServer((req, res) => {
  const path = (req.url || '/').split('?')[0];

  if (req.method !== 'GET') {
    sendError(res, 405, 'Method not allowed');
    return;
  }

  if (path === '/' || path === '/api/status') {
    sendJson(req, res, payload());
    return;
  }

  sendError(res, 404, 'Not found');
});

server.listen(PORT, HOST, () => {
  console.log('Backend A listening on http://' + HOST + ':' + PORT);
  console.log('Reported LAN IP: ' + REPORTED_IP);
});
