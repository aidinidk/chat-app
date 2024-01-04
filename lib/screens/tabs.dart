import 'dart:convert';

import 'package:chat/data/contacts.dart';
import 'package:chat/data/user.dart';
import 'package:chat/models/contanct.dart';
import 'package:chat/models/message.dart';
import 'package:chat/screens/chat.dart';
import 'package:chat/screens/homepage.dart';
import 'package:chat/screens/contacts.dart';
import 'package:chat/screens/more.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:async';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 1;
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameControlelr = TextEditingController();

  String hintPhone = 'ex (+989388104024)';
  String hintName = 'Enter name';

  Color phoneHintColor = const Color.fromRGBO(173, 181, 189, 1);
  Color nameHintColor = const Color.fromRGBO(173, 181, 189, 1);

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void addNewContact() async {
    const baseUrl = '10.0.2.2:8000';

    var url = Uri.http(baseUrl, 'api/contact');

    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user['token']}',
    };

    var response = await http.post(url, headers: header, body: {
      'phone': phoneController.text,
      'contact_name': nameControlelr.text,
    });

    var parsed = jsonDecode(response.body);
    if (response.statusCode == 200) {
      DateTime now = DateTime.now();
      DateTime lastSeen = DateTime.parse(parsed['lastseen']);
      Duration difference = now.difference(lastSeen);
      String getTime() {
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
          return DateFormat('hh:mm a').format(lastSeen);
        }
      }

      setState(() {
        allContacts.add(Contact(
          lastMessage: null,
          id: parsed['id'],
          photo: parsed['photo'],
          isOnline: parsed['status'] == '1' ? true : false,
          phone: parsed['phone'],
          name: parsed['contact_name'],
          lastSeen: getTime(),
        ));
      });

      // ignore: use_build_context_synchronously
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatScreen(contact: allContacts.last)));
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    PreferredSizeWidget appBar = AppBar();

    PreferredSizeWidget appBarFunction(title) => AppBar(
          toolbarHeight: 112,
          flexibleSpace: Padding(
            padding: const EdgeInsets.only(left: 24, right: 24),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 20),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                useSafeArea: true,
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        controller: nameControlelr,
                                        cursorColor: Colors.black,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color.fromRGBO(
                                                247, 247, 252, 1),
                                            hintStyle:
                                                TextStyle(color: nameHintColor),
                                            hintText: hintName,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none)),
                                      ),
                                      TextField(
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        controller: phoneController,
                                        cursorColor: Colors.black,
                                        autofocus: true,
                                        decoration: InputDecoration(
                                            filled: true,
                                            fillColor: const Color.fromRGBO(
                                                247, 247, 252, 1),
                                            hintStyle: TextStyle(
                                                color: phoneHintColor),
                                            hintText: hintPhone,
                                            border: const OutlineInputBorder(
                                                borderSide: BorderSide.none)),
                                      ),
                                      const SizedBox(height: 16.0),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the bottom sheet on Cancel
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.pop(
                                                  context); // Close the bottom sheet on save
                                              addNewContact();
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.add_comment_rounded)),
                        IconButton(
                            onPressed: () {}, icon: const Icon(Icons.menu)),
                      ],
                    ),
                  ],
                ),
                Container(
                  width: 327,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color.fromRGBO(247, 247, 252, 1),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: TextField(
                          controller: controller,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                  color: Color.fromRGBO(173, 181, 189, 1)),
                              hintText: 'Place Holder',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                      ),
                      Positioned(
                        left: 5,
                        top: 0,
                        bottom: 0,
                        child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.search,
                              color: Color.fromRGBO(173, 181, 189, 1),
                              size: 24,
                            )),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

    appBar = appBarFunction('Chats');
    Widget activePage = const HomePageScreen();

    if (_selectedPageIndex == 0) {
      appBar = appBarFunction('Contacts');
      activePage = const ContanctsScreen();
    }
    if (_selectedPageIndex == 2) {
      appBar = AppBar(
        title: const Text('More'),
      );
      activePage = const MoreScreen();
    }

    return SafeArea(
      child: Scaffold(
        appBar: appBar,
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.perm_contact_calendar_outlined),
              label: 'Contancts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: 'Chats'),
          BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_rounded), label: 'More'),
        ], currentIndex: _selectedPageIndex, onTap: _selectPage),
      ),
    );
  }
}
