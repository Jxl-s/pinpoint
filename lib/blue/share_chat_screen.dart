import 'package:flutter/material.dart';
import 'package:pinpoint/blue/chat_screen.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/message.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';

class ShareChatScreen extends StatefulWidget {
  User user;

  ShareChatScreen(this.user);

  @override
  State<ShareChatScreen> createState() => _ShareChatScreenState(this.user);
}

class _ShareChatScreenState extends State<ShareChatScreen>
    with TickerProviderStateMixin {
  User user;
  bool loaded = false;
  List<Location> pins = [];

  _ShareChatScreenState(this.user);

  Future<void> fetchData() async {
    User? loggedUser = await AuthService.getLoggedUser();
    if (loggedUser == null) return;

    List<Location> pins = await Location.getPins(loggedUser!);
    setState(() {
      this.pins = pins;
      loaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          loaded ? "PinPoint - Share" : "Please wait ...",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                "Select location to share:",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: pins.map((e) => ShareLocationCard(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ShareLocationCard(Location location) {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  location.address,
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      // Send the message
                      User? loggedUser = await AuthService.getLoggedUser();
                      if (loggedUser == null) return;

                      // create a new message
                      Message newMessage = Message(
                        author_id: loggedUser.id,
                        recipient_id: user.id,
                        content: Message.encodeLocation(location.id),
                        date: DateTime.now(),
                      );

                      try {
                        await newMessage.create();
                      } catch (e) {}
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext contex) => ChatScreen(loggedUser, user)));
                    },
                    child: Text(
                      'SHARE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
