import 'dart:async';
import 'dart:convert';

import 'package:chat/data/contacts.dart';
import 'package:chat/data/user.dart';
import 'package:chat/models/contanct.dart';
import 'package:chat/models/message.dart';
import 'package:chat/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ContactBuilder extends StatefulWidget {
  const ContactBuilder({super.key});

  @override
  State<ContactBuilder> createState() => _ContactBuilderState();
}

class _ContactBuilderState extends State<ContactBuilder> {
  final baseUrl = '10.0.2.2:8000';
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
  Widget build(BuildContext context) {
    Widget content = const Center(
      child: Text('No contacts'),
    );

    if (allContacts.isNotEmpty) {
      content = ListView.builder(
        itemCount: allContacts.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ChatScreen(contact: allContacts[index])));
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
                              child: allContacts[index].photo != null
                                  ? Image.network(
                                      'http://10.0.2.2:8000/storage/${allContacts[index].photo}')
                                  : Image.asset(
                                      'assets/images/profile-create.png'),
                            ),
                            if (allContacts[index].isOnline)
                              Positioned(
                                right: 2,
                                top: 2,
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    color:
                                        const Color.fromRGBO(44, 192, 105, 1),
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
                          Text(allContacts[index].name),
                          const SizedBox(
                            height: 2,
                          ),
                          !allContacts[index].isOnline
                              ? Text(
                                  'last seen at ${allContacts[index].lastSeen}')
                              : const Text('Online'),
                        ],
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

    return content;
  }
}
