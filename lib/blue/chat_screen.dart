import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';
import './components/drawer.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PinPointDrawer(
        title: "Messages",
      ),
      appBar: AppBar(
        title: Text(
          "Pinpoint - Messages",
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.email),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),

    );
  }
}
