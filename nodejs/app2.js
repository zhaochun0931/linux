const express = require('express');
const bodyParser = require('body-parser');

const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(bodyParser.json());

// Example data (in-memory storage)
let users = [
  { id: 1, name: 'John Doe' },
  { id: 2, name: 'Jane Smith' }
];

// GET /users - Get all users
app.get('/users', (req, res) => {
  res.json(users);
});

// POST /users - Create a new user
app.post('/users', (req, res) => {
  const newUser = req.body;
  users.push(newUser);
  res.status(201).json(newUser);
});

// PUT /users/:id - Update user by ID
app.put('/users/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  const updatedUser = req.body;
  
  users = users.map(user => {
    if (user.id === userId) {
      return { ...user, ...updatedUser };
    }
    return user;
  });

  res.json(updatedUser);
});

// DELETE /users/:id - Delete user by ID
app.delete('/users/:id', (req, res) => {
  const userId = parseInt(req.params.id);
  
  users = users.filter(user => user.id !== userId);

  res.status(204).send();
});

// Start the server
app.listen(port, () => {
  console.log(`REST API server listening at http://localhost:${port}`);
});
