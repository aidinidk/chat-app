import 'dart:convert';

import 'package:chat/data/user.dart';
import 'package:chat/models/contanct.dart';
import 'package:chat/models/message.dart';
import 'package:chat/widgets/messages.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.contact});
  final Contact contact;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  bool sendingMessage = false;

  void updateIsRead() async {
    const baseUrl = '10.0.2.2:8000';
    var url = Uri.http(baseUrl, 'api/message/update/read/own');

    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user['token']}',
      'Content-Type': 'application/json',
    };
    List<int> ids = [];
    List<int> indexes = [];
    for (var i = allMessages.length - 1; i >= 0; i--) {
      if (allMessages[i].isOwn && !allMessages[i].isRead) {
        ids.add(allMessages[i].id);
        print(allMessages[i].text);
        indexes.add(i);
      }
    }

    if (ids.isNotEmpty) {
      var requestBody = jsonEncode({
        'messages_id': ids,
      });

      var response = await http.post(url, headers: header, body: requestBody);
      if (response.statusCode == 200) {
        var parsed = jsonDecode(response.body);
        for (var i = 0; i < parsed.length; i++) {
          setState(() {
            allMessages[indexes[i]].isRead = parsed[i] == 1 ? true : false;
          });
        }
      }
    }
  }

  Future<void> getNewMessage() async {
    if (sendingMessage) {
      return;
    }
    const baseUrl = '10.0.2.2:8000';
    var url = Uri.http(baseUrl, 'api/message/update');

    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user['token']}',
    };

    var response = await http.post(url, headers: header, body: {
      'last_message_id': allMessages.first.id.toString(),
      'destination_id': widget.contact.id.toString(),
    });

    var parsed = jsonDecode(response.body);
    for (var i = 0; i < parsed.length; i++) {
      setState(() {
        allMessages.insert(
            0,
            Message(
                id: parsed[i]['id'],
                isRead: parsed[i]['isRead'] == 1 ? true : false,
                time: parsed[i]['created_at'],
                text: parsed[i]['text'],
                isOwn: parsed[i]['user_id'] == user['id'] ? true : false));
      });
    }
    return;
  }

  List<Message> allMessages = [];

  Future<void> getMessages() async {
    const baseUrl = '10.0.2.2:8000';

    var url = Uri.http(
        baseUrl, 'api/message/${widget.contact.id}/${allMessages.length}');

    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user['token']}',
    };

    var response = await http.get(url, headers: header);

    var parsed = jsonDecode(response.body);
    for (var i = 0; i < parsed.length; i++) {
      setState(() {
        allMessages.add(Message(
            id: parsed[i]['id'],
            isRead: parsed[i]['isRead'] == 1 ? true : false,
            time: parsed[i]['created_at'],
            text: parsed[i]['text'],
            isOwn: parsed[i]['user_id'] == user['id'] ? true : false));
      });
    }
    return;
  }

  void sendMessage(Contact contact) async {
    sendingMessage = true;
    const baseUrl = '10.0.2.2:8000';

    var url = Uri.http(baseUrl, 'api/message');

    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user['token']}',
    };

    // ignore: unused_local_variable
    var response = await http.post(url, headers: header, body: {
      'text': controller.text,
      'destination_id': contact.id.toString()
    });
    var parsed = jsonDecode(response.body);
    setState(() {
      allMessages.insert(
          0,
          Message(
              id: parsed['id'],
              isRead: parsed['isRead'],
              time: parsed['created_at'],
              text: parsed['text'],
              isOwn: parsed['user_id'] == user['id'] ? true : false));
    });
    sendingMessage = false;
  }

  final ScrollController _scrollController = ScrollController();
  Timer? _timer;
  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    getMessages();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getNewMessage();
      updateIsRead();
    });
    super.initState();
  }

  void _scrollListener() {
    // Check if the user has reached the top of the reversed list view
    if (_scrollController.offset ==
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      // Call your future function here
      getMessages();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(173, 181, 189, 1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
        title: Text(widget.contact.name),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: allMessages.isNotEmpty
                ? NotificationListener(
                    onNotification: (ScrollNotification scrollInfo) {
                      return true;
                    },
                    child: Messages(
                      scrollController: _scrollController,
                      messages: allMessages,
                    ),
                  )
                : const Center(
                    child: Text('No Messages'),
                  ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: () {},
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.add,
                          color: Color.fromRGBO(173, 181, 189, 1),
                        ))),
                Expanded(
                  child: SizedBox(
                    height: 36,
                    child: TextField(
                      controller: controller,
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(0),
                          filled: true,
                          fillColor: Color.fromRGBO(247, 247, 252, 1),
                          hintStyle: TextStyle(
                              color: Color.fromRGBO(173, 181, 189, 1)),
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none)),
                    ),
                  ),
                ),
                TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: () {},
                    child: IconButton(
                        onPressed: () {
                          sendMessage(widget.contact);
                          setState(() {
                            controller.clear();
                          });
                        },
                        icon: const Icon(
                          Icons.send,
                          color: Color.fromRGBO(0, 45, 227, 1),
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
