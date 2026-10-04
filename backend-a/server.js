const http = require("http");

const HOST = "0.0.0.0";
const PORT = 3001;

const server = http.createServer((req, res) => {
  res.setHeader("Content-Type", "application/json");

  if (req.url === "/") {
    res.writeHead(200);
    res.end(JSON.stringify({
      message: "Private Network Service Platform",
      backend: "A",
      status: "running"
    }));
  }

  else if (req.url === "/api/status") {
    res.setHeader("X-Backend", "A");
    res.setHeader("Cache-Control", "public, max-age=30");

    res.writeHead(200);
    res.end(JSON.stringify({
      backend: "A",
      status: "healthy",
      ip: "10.3.3.71",
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
  console.log(`Backend A running at http://${HOST}:${PORT}`);
});