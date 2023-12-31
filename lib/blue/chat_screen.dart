
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/message.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/map_screen.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/blue/services/data.dart';
import 'package:pinpoint/blue/share_chat_screen.dart';
import 'package:pinpoint/main.dart';
import './components/drawer.dart';

class ChatScreen extends StatefulWidget {
  User user;
  User loggedUser;

  ChatScreen(this.loggedUser, this.user);

  @override
  State<ChatScreen> createState() =>
      _ChatScreenState(this.loggedUser, this.user);
}

class _ChatScreenState extends State<ChatScreen> {
  User user;
  User loggedUser;
  TextEditingController messageController = TextEditingController();

  _ChatScreenState(this.loggedUser, this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Pinpoint - Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "@${user.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: DataService.collection('messages')
                    .orderBy('date')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }

                  final messages = snapshot.data!.docs;
                  var myMessages = [];

                  for (var message in messages) {
                    String authorId = message.get('author_id');
                    String recipientId = message.get('recipient_id');

                    // make sure the message is part of the recipient
                    if ((authorId == user.id && recipientId == loggedUser.id) ||
                        (authorId == loggedUser.id && recipientId == user.id)) {
                      myMessages.add(message);
                    }
                  }

                  // convert it into a message
                  return ListView(
                      reverse: true,
                      children: myMessages
                          .map((e) {
                        User targetUser =
                        e.get('author_id') == loggedUser.id
                            ? loggedUser
                            : user;
                        Message formattedMessage = Message(
                            author_id: e.get('author_id'),
                            recipient_id: e.get('recipient_id'),
                            content: e.get('content'),
                            date: e.get('date').toDate());

                        if (Message.isEncodedLocation(e.get('content'))) {
                          return ChatLocationCard(loggedUser, targetUser,
                              Message.decodeLocation(e.get('content')));
                        }

                        return ChatCard(targetUser, formattedMessage);
                      })
                          .toList()
                          .reversed
                          .toList());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ShareChatScreen(user)));
                      },
                      child: Icon(Icons.pin_drop, size: 20),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: TextField(
                          controller: messageController,
                          decoration: InputDecoration(
                            hintText: 'Enter text here',
                            contentPadding: EdgeInsets.all(10.0),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 70,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        String text = messageController.text;
                        if (text.isEmpty) return;

                        Message newMessage = Message(
                            author_id: loggedUser.id,
                            recipient_id: user.id,
                            content: text);
                        await newMessage.create();
                        messageController.clear();
                      },
                      child: Icon(Icons.send, size: 20),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ChatCard(User sender, Message message) {
    var messageBubble = [
      Container(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            // image: NetworkImage(friend.avatar), fit: BoxFit.fill),
            image: NetworkImage(sender.avatar),
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Expanded(
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: sender == loggedUser
                ? Theme.of(context).primaryColor
                : Colors.blueGrey,
          ),
          child: Text(
            message.content,
            // textAlign: sender == loggedUser ? TextAlign.end : TextAlign.start,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    ];
    //

    if (sender == loggedUser) {
      messageBubble = messageBubble.reversed.toList();
    }

    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: sender == loggedUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messageBubble,
      ),
    );
  }
}

class ChatLocationCard extends StatefulWidget {
  User loggedUser;
  User sender;
  String locationId;

  ChatLocationCard(this.loggedUser, this.sender, this.locationId);

  @override
  State<ChatLocationCard> createState() => _ChatLocationCardState();
}

class _ChatLocationCardState extends State<ChatLocationCard> {
  Location? loc;

  Future<void> fetchLocation() async {
    print("FETCHING LOC");
    Location l = await Location.getLocationFromId(widget.locationId);
    setState(() {
      loc = l;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchLocation();
  }

  @override
  Widget build(BuildContext context) {
    var messageBubble = [
      Container(
        margin: const EdgeInsets.only(left: 5.0, right: 5.0),
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            // image: NetworkImage(friend.avatar), fit: BoxFit.fill),
            image: NetworkImage(widget.sender.avatar),
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
      loc == null
          ? Text('hi')
          : Expanded(
        child: Container(
          padding:
          EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: widget.sender == widget.loggedUser
                ? Theme.of(context).primaryColor
                : Colors.blueGrey,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc!.name,
                // textAlign: sender == loggedUser ? TextAlign.end : TextAlign.start,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white),
              ),
              Text(
                loc!.address,
                style: TextStyle(color: Colors.white.withOpacity(0.5)),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MapScreen(loc)));
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      widget.sender == widget.loggedUser
                          ? Theme.of(context).primaryColor
                          : Colors.blueGrey,
                    ),
                  ),
                  child: Text(
                    'VIEW LOCATION',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    //

    if (widget.sender == widget.loggedUser) {
      messageBubble = messageBubble.reversed.toList();
    }

    // return Placeholder();
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4, left: 15, right: 15),
      child: Row(
        mainAxisAlignment: widget.sender == widget.loggedUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: messageBubble,
      ),
    );
  }
}

