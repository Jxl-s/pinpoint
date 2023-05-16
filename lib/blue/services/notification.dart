import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationService {
  static Future sendMessageNotif(
      String sender_name, String content, String receiver_id) async {

    http.Response res =  await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      body: jsonEncode(<String, dynamic>{
        "to": "/topics/messages",
        "data": {
          "sender_name": sender_name,
          "content": content,
          "receiver_id": receiver_id
        }
      }),
      headers: {
        'Authorization':
            'key=AAAAwioVj6g:APA91bFka9_P3LHXtP322DjE9YDr6CYnf-2H4tgLMKxdmi0pxmNVxbv-xo7CZngGS3FYmekPawy_J5O0kacfI4WHVvixw-sGY9tk158xYacwCvg48u3TlbW65UyNoYgv2b2hjJXkjGFY',
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
  }
}
