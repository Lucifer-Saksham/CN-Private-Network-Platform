const http = require("http");

const HOST = "0.0.0.0";
const PORT = 3002;

const server = http.createServer((req, res) => {
  res.setHeader("Content-Type", "application/json");

  if (req.url === "/") {
    res.writeHead(200);
    res.end(JSON.stringify({
      message: "Private Network Service Platform",
      backend: "B",
      status: "running"
    }));
  }

  else if (req.url === "/api/status") {
    res.setHeader("X-Backend", "B");
    res.setHeader("Cache-Control", "public, max-age=30");

    res.writeHead(200);
    res.end(JSON.stringify({
      backend: "B",
      status: "healthy",
      ip: "10.3.3.104",
      port: PORT
    }));
  }

  else {
    res.writeHead(404);
    res.end(JSON.stringify({
      error: "Route not found"
    }));
  }
});

server.listen(PORT, HOST, () => {
  console.log(`Backend B running at http://${HOST}:${PORT}`);
});