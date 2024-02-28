const express = require('express');
const bodyParser = require('body-parser');
const dotenv = require('dotenv');
const router = require('./routes');
const db = require('./db/db');
const app = express();
dotenv.config();
app.use(express.json());

// client-side origin
app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});
app.set("trust proxy", 1);

// ROUTER
app.use('/', router);

// Connect to MySQL
db.connect((err) => {
  if (err) throw err;
  console.log('Connected to MySQL database');
});

// Middleware for handling POST requests
app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

//sockets
const http = require('http').createServer(app);
const io = require('socket.io')(http);
const { addConversation,
  addMessage,
   } = require("./controllers/chat_controller");

  io.on('connection', socket => {
    console.log('A client connected');
    socket.on('join_chat', async ({ chatID, userID, name }) => {  
      console.log(`User ${userID} joined chat ${chatID}`);
      await addConversation(chatID, userID, name);
    });

  socket.on('leave_chat', chatID => {
    socket.leave(chatID);
  });

  socket.on('send_message', async ({ chatID, sender, content }) => {
    await addMessage(chatID, sender, content);
    io.to(chatID).emit('receive_message', { sender, content });
  });
});

// Start server
const PORT = process.env.PORT || 3000;
http.listen(PORT, () => console.log(`Server started on port ${PORT}`));
