const tls = require('tls');
const fs = require('fs');
const options = {
  key: fs.readFileSync('./server.key'),
  cert: fs.readFileSync('./server.crt'),
  rejectUnauthorized: false,
  requestCert: true
};
const server = tls.createServer(options, (socket) => {
  console.log('server connected',
              socket.authorized ? 'authorized' : 'unauthorized');
  console.log(socket.getPeerCertificate(true).raw);
  socket.write('welcome!\n');
  socket.setEncoding('utf8');
  socket.pipe(socket);
});
server.listen(443, () => {
  console.log('server bound');
});
