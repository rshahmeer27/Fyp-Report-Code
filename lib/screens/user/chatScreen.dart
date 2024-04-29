// ignore_for_file: non_constant_identifier_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../constant.dart';

class ChatScreen extends StatefulWidget {
  var conversationId;
  var otherUserid;
  var myId;
  ChatScreen(this.conversationId, this.otherUserid, this.myId, {super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();
  late IO.Socket socket;
  var username, image;
  getCustomerById(String userId) async {
    final url = Uri.parse('$port/getcustomer/$userId');

    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> customerData = json.decode(response.body);
      // username = customerData['full_name'];
      // image = customerData['image'];
      // image = stringToUint8List(customerData['image']);
      print('customerData on stream');
      print(customerData);
      return customerData;
    } else {
      throw Exception('Failed to load customer data');
    }
  }

  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  @override
  void initState() {
    super.initState();
    print('widget.otherUserid');
    print(widget.otherUserid);
    print('widget.conversationId');
    print(widget.conversationId);
    socket = IO.io(
      apiCall,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('socket.id on connect');
      print(socket.id);
      socket.emit('addUser', widget.otherUserid);
      print('Socket connected');
    });

    socket.on('getMessage', (data) {
      print('Received message: $data');
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
    });
  }

  List<Message> messages = [];
  void sendMessage(String message) {
    var socketId = socket.id;
    print('socketId');
    print(socketId);
    socket.emit('sendMessage', {
      'senderId': socketId,
      'receiverId': widget.otherUserid,
      'text': message,
    });

    // Create a new Message instance for the sent message
    var sentMessage = Message(
      id: DateTime.now().toString(),
      conversationId: widget.conversationId,
      sender: widget.myId,
      text: message,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Add the sent message to the list
    setState(() {
      messages.add(sentMessage);
    });
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: kBG,
          ),
          child: Column(
            children: [
              Container(
                height: 137.h,
                width: 390.w,
                decoration: BoxDecoration(
                  color: !isDark ? kWhite : kcardColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(35.r),
                    bottomLeft: Radius.circular(35.r),
                  ),
                  boxShadow: [
                    BoxShadow(blurRadius: 1.0, color: Colors.grey.shade400),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 40.h,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 32.w, right: 30.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/icons/back_icon.png',
                              width: 10.w,
                              height: 20.h,
                            ),
                          ),
                          SizedBox(
                            width: 27.w,
                          ),
                          FutureBuilder<dynamic>(
                            future: getCustomerById(widget.otherUserid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator(); // You can show a loading indicator
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else {
                                final user =
                                    snapshot.data as Map<String, dynamic>;
                                image = stringToUint8List(user['picture']);
                                return Row(
                                  children: [
                                    user['picture'] == ''
                                        ? Image.asset(
                                            'assets/images/alex_icon.png',
                                            width: 52.w,
                                            height: 52.h,
                                          )
                                        : Image.memory(
                                            image,
                                            width: 52.w,
                                            height: 52.h,
                                          ),
                                    SizedBox(
                                      width: 12.w,
                                    ),
                                    Text(
                                      user['full_name'],
                                      style: GoogleFonts.manrope(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.w700,
                                        color:
                                            !isDark ? kSecondaryColor : kWhite,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              FutureBuilder<List<Message>>(
                future: fetchMessages(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    messages = snapshot.data ?? [];
                    return Expanded(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          return MessageTile(
                              isMe:
                                  message.sender == widget.myId ? true : false,
                              message: message.text,
                              time: message.createdAt
                                  .toString()
                                  .substring(11, 16));
                        },
                      ),
                    );
                  }
                },
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
        bottomSheet: Container(
          height: 75.h,
          color: !isDark ? kWhite : kcardColor,
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 32.w),
                    width: 281.w,
                    height: 44.h,
                    decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(25.r),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 1.0, color: Colors.grey.shade300),
                        ]),
                    child: TextField(
                      controller: messageController,
                      textInputAction: TextInputAction.send,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 5),
                        hintStyle: GoogleFonts.manrope(
                          fontWeight: FontWeight.w400,
                          fontSize: 12.sp,
                        ),
                        enabledBorder: InputBorder.none,
                        // suffixIcon: const Icon(
                        //   Icons.camera_alt_outlined,
                        //   color: kSupportiveGrey,
                        // ),
                        hintText: '      Type your message here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 13.w,
                  ),
                  GestureDetector(
                    onTap: () async {
                      print('sadvjkb');
                      sendMessage(messageController.text);
                      saveMessage(
                          widget.conversationId, messageController.text);
                      // messageController.clear();
                    },
                    child: Container(
                      height: 39.h,
                      width: 39.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.r),
                        color: kPrimaryGreen,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.send_outlined,
                            color: kWhite,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget MessageTile({required bool isMe, required String message, var time}) {
    return Column(
      children: [
        SizedBox(
          height: 5.h,
        ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: isMe
                  ? EdgeInsets.only(right: 35.w)
                  : EdgeInsets.only(left: 35.w),
              height: 45.h,
              width: 202.w,
              decoration: BoxDecoration(
                color: isMe ? kPrimaryGreen : kInbox,
                borderRadius: BorderRadius.circular(25.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    message,
                    style: GoogleFonts.manrope(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: isMe
                          ? const Color(0xffffffff)
                          : const Color(0xff000000),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 8.h,
        ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: isMe
                  ? EdgeInsets.only(right: 25.w)
                  : EdgeInsets.only(left: 25.w),
              height: 10.h,
              width: 10.w,
              decoration: BoxDecoration(
                  color: isMe ? kPrimaryGreen : kInbox,
                  borderRadius: BorderRadius.circular(10.r)),
            ),
          ],
        ),
        SizedBox(
          height: 5.h,
        ),
        Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              margin: isMe
                  ? EdgeInsets.only(right: 43.w)
                  : EdgeInsets.only(left: 43.w),
              child: Text(
                time,
                style: GoogleFonts.manrope(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: kSecondaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Future<void> saveMessage(String conversationId, String text) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$portChat/savemessage'); // Replace with your API URL

    // Replace with the appropriate headers if needed
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    // Replace with the data you want to send in the request body
    final data = {
      'conversationId': conversationId,
      'sender': widget.myId,
      'text': text,
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        // Handle the response data as needed
        print('Message saved: $responseBody');
        messageController.clear();
      } else {
        // Handle the error if the request was not successful
        print('Failed to save message. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle any network or other errors that may occur
      print('Error: $error');
    }
  }

  Future<List<Message>> fetchMessages() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final response = await http.get(
        Uri.parse('$portChat/getmessages/${widget.conversationId}'),
        headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      print('jsonData');
      print(jsonData);
      return jsonData
          .map((messageJson) => Message.fromJson(messageJson))
          .toList();
    } else {
      print('response.body');
      print(response.body);
      throw Exception('Failed to load messages');
    }
  }
}

class Message {
  final String id;
  final String conversationId;
  final String sender;
  final String text;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'],
      conversationId: json['conversationId'],
      sender: json['sender'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
