import 'package:chat/widgets/contact_builder.dart';
import 'package:flutter/material.dart';

class ContanctsScreen extends StatelessWidget {
  const ContanctsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ContactBuilder(),
    );
  }
}
