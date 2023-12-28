import 'package:chat/data/contacts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ContactBuilder extends StatelessWidget {
  const ContactBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('hh:mm:ss');
    return ListView.builder(
      itemCount: allContacts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {},
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
                                'assets/images/${allContacts[index].image}'),
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
                        Text(allContacts[index].name),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          allContacts[index].isOnline!
                              ? 'Online'
                              : 'Last seen at ${formatter.format(allContacts[index].lastOnline!)}',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
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
}
