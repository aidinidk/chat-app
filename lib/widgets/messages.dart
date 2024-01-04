import 'dart:convert';

import 'package:chat/data/user.dart';
import 'package:chat/models/message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:http/http.dart' as http;

class Messages extends StatelessWidget {
  const Messages(
      {super.key, required this.messages, required this.scrollController});
  final List<Message> messages;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    void updateReadContact(id, index) async {
      const baseUrl = '10.0.2.2:8000';

      var url = Uri.http(baseUrl, 'api/message/update/read/contact');

      final header = {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${user['token']}',
      };
      var response = await http.post(url, headers: header, body: {
        'message_id': id.toString(),
      });
      var parsed = jsonDecode(response.body);
      if (parsed == 1) {
        messages[index].isRead = true;
      }
    }

    String getMonthName(int month) {
      // Helper function to get the month name based on the month number
      List<String> monthNames = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
      ];
      return monthNames[month - 1];
    }

    String extractDate(String timestamp) {
      DateTime dateTime = DateTime.parse(timestamp);
      DateTime now = DateTime.now();
      if (now.year == dateTime.year) {
        // If the year is the same as the current year, display only the day and month
        return "${getMonthName(dateTime.month)} ${dateTime.day}";
      } else {
        // If a year has passed, display the year along with the day and month
        return "${dateTime.day} ${getMonthName(dateTime.month)} ${dateTime.year},  ";
      }
    }

    final DateFormat formatter = DateFormat('hh:mm a');
    return ListView.builder(
      controller: scrollController,
      reverse: true,
      padding: const EdgeInsets.only(bottom: 40, left: 13, right: 13),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        String? nextDate;
        String thisDate = extractDate(messages[index].time);
        if (index == messages.length - 1) {
        } else {
          nextDate = extractDate(messages[index + 1].time);
        }

        return Column(
          children: [
            if (thisDate != nextDate)
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.5),
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  thisDate,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            VisibilityDetector(
              key: Key(messages[index].id.toString()),
              onVisibilityChanged: (info) {
                if (info.visibleFraction == 1.0 &&
                    messages[index].isRead == false &&
                    !messages[index].isOwn) {
                  updateReadContact(messages[index].id, index);
                }
              },
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: messages[index].isOwn
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: messages[index].isOwn
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: messages[index].isOwn
                                    ? const Color.fromRGBO(55, 95, 255, 1)
                                    : Colors.white,
                                borderRadius: BorderRadius.only(
                                  topLeft: const Radius.circular(16),
                                  topRight: const Radius.circular(16),
                                  bottomLeft: messages[index].isOwn
                                      ? const Radius.circular(16)
                                      : Radius.zero,
                                  bottomRight: messages[index].isOwn
                                      ? Radius.zero
                                      : const Radius.circular(16),
                                )),
                            constraints: const BoxConstraints(maxWidth: 250),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            margin: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 12,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  messages[index].text,
                                  style: TextStyle(
                                    // Add a little line spacing to make the text look nicer
                                    // when multilined.
                                    height: 1.3,
                                    color: messages[index].isOwn
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                  softWrap: true,
                                ),
                                SizedBox(
                                  width: 69,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        formatter.format(DateTime.parse(
                                            messages[index].time)),
                                        style: TextStyle(
                                          color: messages[index].isOwn
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  173, 181, 189, 1),
                                          fontSize: 10,
                                        ),
                                      ),
                                      Icon(
                                        messages[index].isOwn &&
                                                messages[index].isRead
                                            ? Icons.checklist_rounded
                                            : messages[index].isOwn
                                                ? Icons.check
                                                : null,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
