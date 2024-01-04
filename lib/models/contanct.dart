import 'message.dart';

class Contact {
  Contact({
    required this.lastMessage,
    required this.lastSeen,
    required this.id,
    required this.photo,
    required this.isOnline,
    required this.phone,
    required this.name,
  });

  final int id;
  final String name;
  final String? photo;
  final String phone;
  bool isOnline = false;
  String lastSeen;
  final Message? lastMessage;

  int get getid => id;
}
