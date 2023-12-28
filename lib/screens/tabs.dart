import 'package:chat/screens/homepage.dart';
import 'package:chat/screens/contacts.dart';
import 'package:chat/screens/more.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key, required this.user});
  final Map<String, String> user;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 1;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = SafeArea(
        child: HomePageScreen(
      user: widget.user,
    ));

    if (_selectedPageIndex == 0) {
      activePage = const SafeArea(child: ContanctsScreen());
    }
    if (_selectedPageIndex == 2) {
      activePage = SafeArea(
        child: MoreScreen(
          user: widget.user,
        ),
      );
    }

    return Scaffold(
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.perm_contact_calendar_outlined),
            label: 'Contancts'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chats'),
        BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_rounded), label: 'More'),
      ], currentIndex: _selectedPageIndex, onTap: _selectPage),
    );
  }
}
