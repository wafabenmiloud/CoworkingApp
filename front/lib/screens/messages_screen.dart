import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front/constants.dart';
import 'package:front/screens/chat_screen.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/widgets.dart';
import 'package:random_string/random_string.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  IO.Socket socket = IO.io('$server');
  List users = [];
  List filteredUsers = [];

  String chatID = "";
  String user = "";

  _fetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      Dio dio = new Dio();
      dio.options.headers['Authorization'] = 'Bearer $token';

      final res = await dio.get('$server/users');
      return res.data;
    } catch (error) {
      print('Error fetching data: $error');
      return null;
    }
  }

  void connectToServer() {
    socket.connect();
  }

  void disconnectFromServer() {
    if (socket != null) {
      socket.disconnect();
    }
  }

  void joinChatRoom(String chatID) {
    if (chatID == "") {
      chatID = randomAlphaNumeric(10);
    }

    socket.emit('join_chat', {'chatID': chatID, 'name': user});
    this.chatID = chatID;
  }

  @override
  void initState() {
    super.initState();
    connectToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          children: [
            Container(
                padding: EdgeInsets.only(top: 60),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      filteredUsers = users
                          .where((user) => user['fullname']
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search here ...',
                    prefixIcon: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.search,
                          size: 35,
                          color: AppStyles.primaryColor,
                        )),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            users.isNotEmpty
                ? Container(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              user = filteredUsers[index]['fullname'];
                            });
                            joinChatRoom(chatID);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ChatScreen(user: user, chatID: chatID),
                              ),
                            );
                          },
                          child: Container(
                            width: 100,
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      AssetImage('images/user.png'),
                                ),
                                SizedBox(height: 8.0),
                                Expanded(
                                  child: Text(
                                    " ${users[index]['fullname']}",
                                    style: TextStyle(
                                      fontSize: 10.0,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(),
            // InkWell(
            //   onTap: () {
            //       joinChatRoom("chatID");
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => ChatScreen(),
            //         ),
            //       );
            //   },
            //   child: Container(
            //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            //     child: Row(
            //       children: [
            //         CircleAvatar(
            //           radius: 30,
            //           backgroundImage: AssetImage('images/user.png'),
            //         ),
            //         SizedBox(width: 16.0),
            //         Expanded(
            //           child: Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(
            //                     'Smith Mathew',
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.w500,
            //                         fontSize: 18.0,
            //                         fontFamily: 'Poppins'),
            //                   ),
            //                   Text(
            //                     '29 mars',
            //                     style: TextStyle(
            //                         fontWeight: FontWeight.w400,
            //                         fontSize: 14.0,
            //                         fontFamily: 'Poppins',
            //                         color: Color(0xffC5BDBD)),
            //                   ),
            //                 ],
            //               ),
            //               SizedBox(height: 8.0),
            //               Text(
            //                 'Hi ...',
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.w500,
            //                     fontSize: 16.0,
            //                     fontFamily: 'Poppins',
            //                     color: Color(0xff9C9797)),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _fetchData().then((data) {
            setState(() {
              users = filteredUsers = data;
            });
          });
        },
        child: Icon(Icons.add),
        backgroundColor: AppStyles.primaryColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  @override
  void dispose() {
    disconnectFromServer();
    super.dispose();
  }
}
