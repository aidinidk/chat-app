import 'dart:async';
import 'dart:convert';

import 'package:chat/data/contacts.dart';
import 'package:chat/data/user.dart';
import 'package:chat/models/contanct.dart';
import 'package:chat/models/message.dart';
import 'package:chat/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HomeBuilder extends StatefulWidget {
  const HomeBuilder({super.key});

  @override
  State<HomeBuilder> createState() => _HomeBuilderState();
}

class _HomeBuilderState extends State<HomeBuilder> {
  final baseUrl = '10.0.2.2:8000';
  void profileGetter() async {
    final box = GetStorage();

    final token = box.read('token');
    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    var url = Uri.http(baseUrl, 'api/users');

    var response = await http.get(url, headers: header);
    if (response.statusCode == 200) {
      var parsed = jsonDecode(response.body);

      setState(() {
        user = {
          'id': parsed['id'],
          'name': parsed['name'],
          'token': token,
          'email': parsed['email'],
          'photo': parsed['photo'],
          'phone': parsed['phone'],
        };
      });
    }
    if (response.statusCode == 401) {
      setState(() {
        box.remove('token');
      });
    }
  }

  String getTime(String last) {
    DateTime result = DateTime.parse(last);
    DateTime now = DateTime.now();
    Duration difference = now.difference(result);
    if (difference.inDays > 365) {
      // More than 1 year
      int years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      // More than 1 month
      int months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 7) {
      // More than 1 week
      int weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays > 1) {
      // More than 1 day
      return '${difference.inDays} days ago';
    } else {
      // Less than a day
      return DateFormat('hh:mm a').format(result);
    }
  }

  bool inProcces = false;
  void getContacts(header) async {
    if (inProcces == true) {
      return;
    }

    inProcces = true;
    var url = Uri.http(baseUrl, 'api/contact');
    var response = await http.get(url, headers: header);
    var parsedContact = jsonDecode(response.body);
    allContacts.clear();
    if (response.statusCode == 200 && parsedContact.length > 0) {
      for (var i = 0; i < parsedContact.length; i++) {
        //parsed contact is the contact information
        //parsedMessage here is the last message
        addContact(header, parsedContact[i]);
      }
    }
  }

  void addContact(header, Map contact) async {
    var url = Uri.http(baseUrl, 'api/message/${contact['id']}');
    var response = await http.get(url, headers: header);
    var parsedMessage = jsonDecode(response.body);
    if (response.statusCode == 200) {
      late Message? message;
      if (parsedMessage['no_message'] != null) {
        message = null;
      } else {
        message = Message(
            id: parsedMessage['id'],
            time: getTime(parsedMessage['created_at']),
            isRead: parsedMessage['isRead'] == 1 ? true : false,
            text: parsedMessage['text'],
            isOwn: parsedMessage['user_id'] == user['id'] ? true : false);
      }
      setState(() {
        allContacts.add(Contact(
            lastMessage: message,
            id: contact['id'],
            photo: contact['photo'],
            isOnline: contact['status'],
            phone: contact['phone'],
            name: contact['contact_name'],
            lastSeen: getTime(contact['lastseen'])));
      });
    }

    inProcces = false;
  }

  @override
  void initState() {
    profileGetter();
    getContacts({
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user['token']}',
    });
    Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      getContacts({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user['token']}',
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final DateFormat formatter = DateFormat('hh-mm-ss');
    final activeContacts =
        allContacts.where((element) => element.lastMessage != null).toList();
    return ListView.builder(
      itemCount: activeContacts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: ((context) =>
                    ChatScreen(contact: activeContacts[index]))));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 58,
                      height: 58,
                      child: Stack(
                        children: [
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            top: 0,
                            child: activeContacts[index].photo != null
                                ? Image.network(
                                    'http://10.0.2.2:8000/storage/${allContacts[index].photo}')
                                : Image.asset(
                                    'assets/images/profile-create.png'),
                          ),
                          if (activeContacts[index].isOnline)
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                width: 15,
                                height: 15,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                  color: const Color.fromRGBO(44, 192, 105, 1),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activeContacts[index].name),
                        const SizedBox(
                          height: 2,
                        ),
                        Row(
                          children: [
                            Text(
                              activeContacts[index].lastMessage.text.length > 35
                                  ? '${activeContacts[index].lastMessage.text.substring(0, 35)}...'
                                  : activeContacts[index].lastMessage.text,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                            const SizedBox(width: 5),
                            if (activeContacts[index].lastMessage.isOwn)
                              Icon(
                                activeContacts[index].lastMessage.isRead
                                    ? Icons.checklist_rounded
                                    : Icons.check,
                                color: Colors.blue,
                              )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(activeContacts[index].lastMessage.time),
                    const SizedBox(height: 5),
                    if (!activeContacts[index].lastMessage.isOwn &&
                        !activeContacts[index].lastMessage.isRead)
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
