'use strict';

const tls = require('node:tls');
const fs = require('node:fs');

const PORT = 8443;
const HOST = '127.0.0.1';

// Grouping options for better readability
const options = {
  key: fs.readFileSync('/tmp/server.key'),
  cert: fs.readFileSync('/tmp/server.crt'),
  // Consider adding rejectUnauthorized: true if using client certs
};

const server = tls.createServer(options, (socket) => {
  console.log('Client connected:', socket.remoteAddress);

  socket.setEncoding('utf8');
  socket.write("I am the server sending you a message.\n");

  // Handle incoming data
  socket.on('data', (data) => {
    const cleanData = data.toString().replace(/(\n|\r)/gm, "");
    console.log(`Received: ${cleanData} [${data.length} bytes]`);
  });

  // Handle socket-specific errors (prevents server crash on client disconnect)
  socket.on('error', (err) => {
    console.error(`Socket error: ${err.message}`);
  });

  socket.on('end', () => {
    console.log('EOT (End Of Transmission)');
  });
});

// Server Lifecycle Events
server.on('error', (err) => {
  console.error('Server error:', err);
  server.close(); // Graceful shutdown is better than destroy() in many cases
});

server.listen(PORT, HOST, () => {
  console.log(`Server listening at ${HOST}:${PORT}`);
});
