// use the openssl to generate the private key and the public cert
const https = require('https');
const fs = require('fs');

const options = {
  key: fs.readFileSync('/tmp/server.key'),
  cert: fs.readFileSync('/tmp/server.crt')
};

https.createServer(options, (req, res) => {
  res.writeHead(200);
  res.end('Hello, world! TLS');
}).listen(443);

console.log("Server started at port 443");
