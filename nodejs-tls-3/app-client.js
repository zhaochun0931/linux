'use strict';

const tls = require('node:tls');
const fs = require('node:fs');

const PORT = 8443;
const HOST = '127.0.0.1';

const options = {
  // If using self-signed certs, provide the CA or the cert itself here
  // rather than just disabling security entirely.
  ca: [ fs.readFileSync('/tmp/server.crt') ], 
  checkServerIdentity: () => undefined, // Skip hostname verification for local testing
  rejectUnauthorized: false // Keep false ONLY if you don't have a valid CA chain
};

const client = tls.connect(PORT, HOST, options, () => {
  console.log('Connected to server');

  if (client.authorized) {
    console.log("Status: Connection authorized by a Certificate Authority.");
  } else {
    // In many corporate environments, this is common for internal tools
    console.warn("Status: Connection not authorized:", client.authorizationError);
  }

  client.write("I am the client sending you a message.\n");
});



// Handle incoming data
client.on("data", (data) => {
  const message = data.toString().replace(/(\n|\r)/gm, "");
  console.log(`Received: ${message} [${data.length} bytes long]`);
  
  // Cleanly close the connection
  client.end();
});

// Resource management
client.on('close', () => {
  console.log("Connection closed");
});

client.on('error', (error) => {
  console.error("Client Error:", error.message);
  client.destroy(); 
});
