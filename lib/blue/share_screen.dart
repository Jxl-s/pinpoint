import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/message.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';

class ShareScreen extends StatefulWidget {
  Location location;

  ShareScreen(this.location);

  @override
  State<ShareScreen> createState() => _ShareScreenState(location);
}

class _ShareScreenState extends State<ShareScreen>
    with TickerProviderStateMixin {
  Location location;
  bool loaded = false;
  List<User> friends = [];

  _ShareScreenState(this.location);

  Future<void> fetchData() async {
    User? loggedUser = await AuthService.getLoggedUser();
    if (loggedUser == null) return;

    List<User> friends = await loggedUser!.getFriends();
    setState(() {
      this.friends = friends;
      loaded = true;
    });
  }

  Future<bool> shareLocationTo(User friend) async {
    User? loggedUser = await AuthService.getLoggedUser();
    if (loggedUser == null) return false;

    // create a new message
    Message newMessage = Message(
      author_id: loggedUser.id,
      recipient_id: friend.id,
      content: Message.encodeLocation(location.id),
      date: DateTime.now(),
    );

    try {
      await newMessage.create();
      return true;
    } catch (e) {
      return false;
    }
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
                "Share '${location.name}' to",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: friends.map((e) => ShareFriendCard(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ShareFriendCard(User friend) {
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
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(friend.avatar), fit: BoxFit.fill),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "@${friend.name}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(friend.email),
                  ],
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
                      // send it now
                      bool success = await shareLocationTo(friend);
                      if (success) {
                        showNotification(context: context, text: 'Sent location!');
                        Navigator.pop(context);
                      } else {
                        showNotification(context: context, text: 'Error sharing location');
                      }
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
