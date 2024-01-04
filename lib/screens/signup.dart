import 'dart:convert';
import 'package:chat/main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String emailHint = 'Enter your Email';
  String passwordHint = 'Enter your Password';
  String nameHint = 'Enter your Name';
  String phoneHint = 'Enter your Phone ex(+989388104024)';

  Color emailHintColor = const Color.fromRGBO(173, 181, 189, 1);
  Color passwordHintColor = const Color.fromRGBO(173, 181, 189, 1);
  Color nameHintColor = const Color.fromRGBO(173, 181, 189, 1);
  Color phoneHintColor = const Color.fromRGBO(173, 181, 189, 1);

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  bool isRegister = true;

  @override
  Widget build(BuildContext context) {
    void register() async {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var url = Uri.http('10.0.2.2:8000', 'api/auth/register');

      var response = await http.post(url, body: {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'device_name': androidInfo.model,
        'phone': phoneController.text,
      }, headers: {
        'Accept': 'application/json'
      });

      if (response.statusCode == 200) {
        final tokenCuttingPoint = response.body.toString().length - 48;
        final box = GetStorage();
        box.write(
            'token', response.body.toString().substring(tokenCuttingPoint));

        // ignore: use_build_context_synchronously
        setState(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
              (route) => false);
        });
      }

      if (response.statusCode == 422) {
        final Map parsed = jsonDecode(response.body);
        Map<String, String> json = {};
        parsed['errors'].forEach((key, value) {
          json[key] = value.toString();
        });

        setState(() {
          if (json['name'] != null) {
            nameHintColor = Colors.red;
            nameHint = json['name']!.substring(1, json['name']!.length - 1);
            nameController.clear();
          }
          if (json['phone'] != null) {
            phoneHintColor = Colors.red;
            phoneHint = json['phone']!.substring(1, json['phone']!.length - 1);
            phoneController.clear();
          }
          if (json['email'] != null) {
            emailHintColor = Colors.red;
            emailHint = json['email']!.substring(1, json['email']!.length - 1);
            emailController.clear();
          }
          if (json['password'] != null) {
            passwordHint =
                json['password']!.substring(1, json['password']!.length - 1);
            passwordHintColor = Colors.red;
            passwordController.clear();
          }
        });
      }
    }

    void login() async {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      var url = Uri.http('10.0.2.2:8000', 'api/auth/login');

      var response = await http.post(url, body: {
        'email': emailController.text,
        'password': passwordController.text,
        'device_name': androidInfo.model,
      }, headers: {
        'Accept': 'application/json'
      });

      if (response.statusCode == 200) {
        final tokenCuttingPoint = response.body.toString().length - 48;
        final box = GetStorage();
        box.write(
            'token', response.body.toString().substring(tokenCuttingPoint));

        // ignore: use_build_context_synchronously
        setState(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyApp()),
              (route) => false);
        });
      }
      if (response.statusCode == 422) {
        final Map parsed = jsonDecode(response.body);
        Map<String, String> json = {};
        parsed['errors'].forEach((key, value) {
          json[key] = value.toString();
        });

        setState(() {
          if (json['email'] != null) {
            emailHintColor = Colors.red;
            emailHint = json['email']!.substring(1, json['email']!.length - 1);
            emailController.clear();
          }
          if (json['password'] != null) {
            passwordHint =
                json['password']!.substring(1, json['password']!.length - 1);
            passwordHintColor = Colors.red;
            passwordController.clear();
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Profile'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 31),
                    if (isRegister)
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: nameController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(247, 247, 252, 1),
                            hintStyle: TextStyle(color: nameHintColor),
                            hintText: nameHint,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: emailController,
                      cursorColor: Colors.black,
                      autofocus: false,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(247, 247, 252, 1),
                          hintStyle: TextStyle(color: emailHintColor),
                          hintText: emailHint,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                    TextField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      textInputAction: TextInputAction.next,
                      controller: passwordController,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color.fromRGBO(247, 247, 252, 1),
                          hintStyle: TextStyle(color: passwordHintColor),
                          hintText: passwordHint,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                    if (isRegister)
                      TextField(
                        textInputAction: TextInputAction.next,
                        controller: phoneController,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: const Color.fromRGBO(247, 247, 252, 1),
                            hintStyle: TextStyle(color: phoneHintColor),
                            hintText: phoneHint,
                            border: const OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              setState(() {
                                isRegister = !isRegister;
                              });
                            },
                            child: Text(isRegister ? 'Login' : 'Register'))
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(327, 64),
                      backgroundColor: const Color.fromRGBO(0, 45, 227, 1),
                    ),
                    onPressed: isRegister ? register : login,
                    child: Text(
                      isRegister ? 'Register' : 'Login',
                      style: const TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
