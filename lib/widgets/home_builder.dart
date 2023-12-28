import 'package:chat/data/contacts.dart';
import 'package:chat/screens/chat.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeBuilder extends StatelessWidget {
  const HomeBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('hh-mm-ss');
    final activeContacts =
        allContacts.where((element) => element.messages.isNotEmpty).toList();

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
                            child: Image.asset(
                                'assets/images/${activeContacts[index].image}'),
                          ),
                          if (allContacts[index].isOnline!)
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
                        Text(
                          activeContacts[index].messages.first.text.length > 35
                              ? '${activeContacts[index].messages.last.text.substring(0, 35)}...'
                              : activeContacts[index].messages.first.text,
                          overflow: TextOverflow.ellipsis,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                    formatter.format(activeContacts[index].messages.last.time)),
              ],
            ),
          ),
        );
      },
    );
  }
}
