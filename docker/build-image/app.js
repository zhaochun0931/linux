const http = require('http');
const os = require('os');
const port = 8080;

const handler = (req, res) => {
  console.log("Received request from " + req.connection.remoteAddress);
  res.writeHead(200);
  res.end("Hello222, this response is from host: " + os.hostname() + "\n");
};

const server = http.createServer(handler);
server.listen(port, () => {
  console.log(`Server running at http://:${port}/`);
});

