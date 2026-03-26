const http = require('http');
const os = require('os');

const port = 8080;

const handler = (req, res) => {
  // Create a high-precision timestamp
  const timestamp = new Date().toISOString();
  
  // Log to the Docker console (Terminator will see this)
  console.log(`[${timestamp}] Request from ${req.socket.remoteAddress} via ${req.headers['x-forwarded-proto'] || 'http'}`);

  res.writeHead(200, { 'Content-Type': 'text/plain' });
  
  // Send the response back through the TLS Terminator
  res.end(
    `Timestamp: ${timestamp}\n` +
    `Host: ${os.hostname()}\n` +
    `Protocol: ${req.headers['x-forwarded-proto'] || 'http'}\n`
  );
};

const server = http.createServer(handler);

server.listen(port, () => {
  console.log(`[${new Date().toISOString()}] Backend running on port ${port}`);
});
