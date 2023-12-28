class Message {
  Message({required this.text, required this.isOwn});

  bool isOwn;
  String text;
  DateTime time = DateTime.now();
}
