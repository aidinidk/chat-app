import 'package:chat/data/messages.dart';
import 'package:chat/models/contanct.dart';

final allContacts = [
  Contact(
      image: 'athaila.png',
      name: 'Athaila Putri',
      messages: athalia,
      isOnline: true),
  Contact(
    image: 'erlan.png',
    name: 'Erlan Sadewa',
    messages: erlan,
    isOnline: false,
    lastOnline: DateTime.utc(2023, 12, 28, 10, 04, 9),
  ),
  Contact(
      image: 'midala.png', name: 'Midala Huera', messages: [], isOnline: true),
  Contact(
      image: 'nafisa.png',
      name: 'Nafisa Gitari',
      isOnline: false,
      messages: [],
      lastOnline: DateTime.utc(2023, 12, 28, 7, 55, 5)),
  Contact(
    image: 'raki.png',
    name: 'Raki Devon',
    messages: raki,
    isOnline: false,
    lastOnline: DateTime.utc(2023, 12, 28, 11, 51, 0),
  ),
];
