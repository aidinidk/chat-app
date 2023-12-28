import 'package:chat/screens/tabs.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Image.asset('assets/images/profile-create.png')),
                const SizedBox(height: 31),
                TextField(
                  controller: controller,
                  cursorColor: Colors.black,
                  autofocus: true,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Color.fromRGBO(247, 247, 252, 1),
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(173, 181, 189, 1)),
                      hintText: 'First Name (Required)',
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 68,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(327, 64),
                backgroundColor: const Color.fromRGBO(0, 45, 227, 1),
              ),
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TabsScreen(user: {'name': controller.text})),
                    (route) => false);
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
    );
  }
}
