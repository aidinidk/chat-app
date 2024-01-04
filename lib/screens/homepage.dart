import 'package:chat/widgets/home_builder.dart';
import 'package:flutter/material.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeBuilder(),
    );
  }
}
