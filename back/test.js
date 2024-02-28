const io = require('socket.io-client');
const socket = io('http://192.168.137.61:3000');

const chatID = 'chat2';
socket.emit('join_chat', chatID);

const message = {
    chatID: 'chat2',
    sender: 'John',
    content: 'Hello, everyone!',
  };
  socket.emit('send_message', message);

  socket.on('receive_message', message => {
    console.log('Received message:', message);
  });

  
  