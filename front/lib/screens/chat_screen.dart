import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/widgets.dart';

class Message {
  final String sender;
  final String content;
  final bool isSender;

  Message({
    required this.sender,
    required this.content,
    this.isSender = false,
  });
}

List<Message> messages = [];

class ChatScreen extends StatefulWidget {
  final user;
  final String chatID;

  ChatScreen({Key? key, required this.user, required this.chatID})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  IO.Socket socket = IO.io('$server');

  void connectToServer() {
    socket.connect();
  }

  void disconnectFromServer() {
    if (socket != null) {
      socket.disconnect();
    }
  }

  void leaveChatRoom(String chatID) {
    socket.emit('leave_chat', chatID);
  }

  void sendMessage(String chatID, String sender, String content) {
    Message message = Message(
      sender: sender,
      content: content,
      isSender: true,
    );
    setState(() {
      messages.add(message);
    });
    Map<String, dynamic> messageData = {
      'chatID': chatID,
      'sender': sender,
      'content': content,
    };
    socket.emit('send_message', messageData);
  }

  void receiveMessage(Function(dynamic) callback) {
    socket.on('receive_message', (data) {
      setState(() {
        Message message = Message(
          sender: data['sender'],
          content: data['content'],
          isSender: false,
        );
        messages.add(message);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    connectToServer();
    receiveMessage((data) {
      setState(() {
        messages.add(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      leaveChatRoom(widget.chatID);
                      Navigator.pop(context);
                    },
                    child: Container(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppStyles.primaryColor,
                        size: 30,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('images/user.png'),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      '${widget.user}',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18.0,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return Container(
                    alignment: message.isSender
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: message.isSender
                            ? Color(0xffD0ECE8)
                            : Color(0xffE4E4E4),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: message.isSender
                              ? Color(0xff007665)
                              : Color(0xff383737),
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Envoyer un message',
                        hintStyle: TextStyle(color: Color(0xffE4E4E4)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  FloatingActionButton(
                    backgroundColor: AppStyles.primaryColor,
                    onPressed: () {
                      String message = _textController.text;
                      _textController.clear();
                      sendMessage(
                          widget.chatID, widget.user['fullname'], message);
                    },
                    child: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    disconnectFromServer();
    super.dispose();
  }
}
