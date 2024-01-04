class Message {
  Message({
    required this.id,
    required this.isRead,
    required this.time,
    required this.text,
    required this.isOwn,
  });
  int id;
  bool isOwn;
  String text;
  String time;
  bool isRead;
}
