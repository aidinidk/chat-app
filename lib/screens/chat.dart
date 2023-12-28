import 'package:chat/models/contanct.dart';
import 'package:chat/models/message.dart';
import 'package:chat/widgets/messages.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.contact});
  final Contact contact;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
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
            child: Messages(
              contact: widget.contact,
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
                          setState(() {
                            widget.contact.messages.insert(
                                0, Message(text: controller.text, isOwn: true));
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
