import { WebSocketServer } from 'ws';

const wss = new WebSocketServer({ port: 8080 });

wss.on('connection', (ws) => {
  console.log('New client connected!');

  // Send a message to the client immediately
  ws.send('Welcome to the WebSocket server!');

  // Listen for messages from the client
  ws.on('message', (data) => {
    console.log(`Received: ${data}`);
    // Echo the message back to the client
    ws.send(`Server received: ${data}`);
  });

  ws.on('close', () => console.log('Client disconnected'));
});

console.log('Server is running on ws://localhost:8080');
