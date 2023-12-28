import 'package:chat/models/contanct.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Messages extends StatelessWidget {
  const Messages({super.key, required this.contact});
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('hh:mm');
    final messages = contact.messages;
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
      reverse: true,
      itemCount: contact.messages.length,
      itemBuilder: (context, index) {
        return Stack(
          children: [
            Row(
              mainAxisAlignment: messages[index].isOwn
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: messages[index].isOwn
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: messages[index].isOwn
                              ? const Color.fromRGBO(55, 95, 255, 1)
                              : Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(16),
                            topRight: const Radius.circular(16),
                            bottomLeft: messages[index].isOwn
                                ? const Radius.circular(16)
                                : Radius.zero,
                            bottomRight: messages[index].isOwn
                                ? Radius.zero
                                : const Radius.circular(16),
                          )),
                      constraints: const BoxConstraints(maxWidth: 250),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 14,
                      ),
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            messages[index].text,
                            style: TextStyle(
                              // Add a little line spacing to make the text look nicer
                              // when multilined.
                              height: 1.3,
                              color: messages[index].isOwn
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            softWrap: true,
                          ),
                          Text(
                            formatter.format(messages[index].time),
                            style: TextStyle(
                              color: messages[index].isOwn
                                  ? Colors.white
                                  : const Color.fromRGBO(173, 181, 189, 1),
                              fontSize: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
