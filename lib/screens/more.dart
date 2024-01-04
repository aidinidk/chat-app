import 'dart:convert';

import 'package:chat/data/user.dart';
import 'package:chat/screens/signup.dart';
import 'package:chat/widgets/image_input.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'dart:io';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  TextEditingController nameController = TextEditingController();

  String hintName = 'Enter name';
  Color nameHintColor = const Color.fromRGBO(173, 181, 189, 1);

  void changeName() async {
    var url = Uri.http(baseUrl, 'api/users/name');
    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user['token']}',
    };

    var response = await http.post(url, headers: header, body: {
      'name': nameController.text,
    });
    if (response.statusCode == 200) {
      Map parsed = jsonDecode(response.body);
      setState(() {
        user.update('name', (value) => parsed['name']);
      });
    }
  }

  // ignore: unused_field
  File? _selectedImage;

  final baseUrl = '10.0.2.2:8000';
  void logout() async {
    var url = Uri.http(baseUrl, 'api/auth/logout');
    final header = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${user['token']}',
    };

    var response = await http.post(url,
        body: {
          'email': user['email'],
        },
        headers: header);

    if (response.statusCode == 204) {
      user = {};
      final box = GetStorage();
      box.write('token', null);

      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const SignUpScreen()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    nameController.text = user['name']!;
    return Scaffold(
      body: Column(
        children: [
          ImageInput(
            onPickImage: (image) {
              _selectedImage = image;
            },
          ),
          InkWell(
            onTap: () {
              showModalBottomSheet(
                useSafeArea: true,
                context: context,
                builder: (context) => SingleChildScrollView(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        controller: nameController,
                        cursorColor: Colors.black,
                        autofocus: true,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(247, 247, 252, 1),
                            hintStyle: TextStyle(color: nameHintColor),
                            hintText: hintName,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              changeName();
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user['email']!),
                          Text(user['name']!),
                        ],
                      ),
                    ],
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextButton.icon(
                        onPressed: logout,
                        label: const Text('Logout'),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 15,
                        )),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
