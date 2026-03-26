const http = require('http');
const os = require('os');
const port = 8080;

// Helper to get a readable timestamp
const getTimestamp = () => new Date().toISOString();

const handler = (req, res) => {
  const timestamp = getTimestamp();
  
  console.log(`[${timestamp}] Received request from ${req.connection.remoteAddress}`);
  
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end(
    `Timestamp: ${timestamp}\n` +
    `Response from host: ${os.hostname()}\n`
  );
};

const server = http.createServer(handler);

server.listen(port, () => {
  console.log(`[${getTimestamp()}] Server running at http://localhost:${port}/`);
});
