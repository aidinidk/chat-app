import 'package:chat/screens/tabs.dart';
import 'package:chat/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    bool isLogged = true;

    if (box.read('token') == null) {
      isLogged = false;
    }

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/home': (context) => const MyApp(),
      },
      home: isLogged ? const TabsScreen() : const SignUpScreen(),
    );
  }
}
