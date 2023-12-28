import 'message.dart';

class Contact {
  Contact(
      {required this.image,
      required this.name,
      required this.messages,
      this.lastOnline,
      this.isOnline});

  final List<Message> messages;
  final String image;
  final String name;
  bool? isOnline = true;
  DateTime? lastOnline;
}
