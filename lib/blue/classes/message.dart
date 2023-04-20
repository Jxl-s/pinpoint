import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinpoint/blue/services/data.dart';

class Message {
  String id;
  String author_id;
  String recipient_id;
  DateTime date;
  String content;

  Message({
    String? id,
    DateTime? date,
    required this.author_id,
    required this.recipient_id,
    required this.content,
  })  : id = id ?? '',
        date = date ?? DateTime.now();

  static Future<List<Message>> getFromChannel(
      String user1, String user2) async {
    QuerySnapshot snapshot1 = await DataService.collection('messages')
        .where('author_id', isEqualTo: user1)
        .where('recipient_id', isEqualTo: user2)
        .get();

    QuerySnapshot snapshot2 = await DataService.collection('messages')
        .where('recipient_id', isEqualTo: user1)
        .where('author_id', isEqualTo: user2)
        .get();

    // format them into messages
    List<Message> messagesList = [];
    List<QueryDocumentSnapshot> messages = [
      ...snapshot1.docs,
      ...snapshot2.docs
    ];

    // sort the messages based on the date
    messages.sort((a, b) {
      DateTime dateA = a.get('date').toDate();
      DateTime dateB = b.get('date').toDate();

      return dateA.compareTo(dateB);
    });

    for (int i = 0; i < messages.length; i++) {
      messagesList.add(
        Message(
          author_id: messages[i].get('author_id'),
          recipient_id: messages[i].get('recipient_id'),
          date: messages[i].get('date').toDate(),
          content: messages[i].get('content'),
        ),
      );
    }

    return messagesList;
  }

  Future<bool> create() async {
    try {
      DocumentReference ref = await DataService.collection('messages').add({
        'author_id': author_id,
        'recipient_id': recipient_id,
        'date': DateTime.now(),
        'content': content,
      });

      this.id = ref.id;
      return true;
    } catch (e) {
      return false;
    }
  }
}
