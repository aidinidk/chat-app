import 'package:chat/widgets/contact_builder.dart';
import 'package:flutter/material.dart';

class ContanctsScreen extends StatelessWidget {
  const ContanctsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112,
        flexibleSpace: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chats',
                    style: TextStyle(fontSize: 20),
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {},
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
      ),
      body: const ContactBuilder(),
    );
  }
}
