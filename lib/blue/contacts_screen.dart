import 'package:flutter/material.dart';
import 'package:pinpoint/blue/chat_screen.dart';
import 'package:pinpoint/blue/classes/message.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';
import './components/drawer.dart';

String formatTime(Duration time) {
  if (time.inDays > 0) {
    return '${time.inDays}d';
  } else if (time.inHours > 0) {
    return '${time.inHours}h';
  } else if (time.inMinutes > 0) {
    return '${time.inMinutes}m';
  } else {
    return '${time.inSeconds}s';
  }
}

String shortenString(String str) {
  if (str.length > 10) {
    return str.substring(0, 10) + '...';
  } else {
    return str;
  }
}

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  State<ContactsScreen> createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<User> friends = [];
  Map<User, Message?> latestMessages = {};
  User? loggedUser;

  bool loaded = false;

  @override
  void initState() {
    super.initState();

    // Get the data
    fetchData();
  }

  Future<void> fetchData() async {
    User? user = await AuthService.getLoggedUser();
    if (user != null) {
      List<User> friends = await user.getFriends();
      Map<User, Message?> latestMessages = {};

      // get all the user messages
      for (int i = 0; i < friends.length; i++) {
        List<Message> friendMessages =
            await Message.getFromChannel(user!.id, friends[i].id);
        if (friendMessages.isEmpty) {
          latestMessages[friends[i]] = null;
        } else {
          latestMessages[friends[i]] =
              friendMessages[friendMessages.length - 1];
        }
      }

      setState(() {
        this.loggedUser = user;
        this.friends = friends;
        this.latestMessages = latestMessages;

        loaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PinPointDrawer(
        title: "Messages",
      ),
      appBar: AppBar(
        title: Text(
          loaded ? "PinPoint - Messages" : "Please Wait...",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text(
                'Contact List',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  child: ListView(
                children: friends
                    .map((e) => MessageCard(e, latestMessages[e]))
                    .toList(),
              )),
              // MessageCard(),
              // MessageCard(),
              // MessageCard()
            ],
          ),
        ),
      ),
    );
  }

  Widget MessageCard(User user, Message? latestMessage) {
    print('new message card!');
    String timeString = latestMessage != null
        ? formatTime(DateTime.now().difference(latestMessage!.date))
        : "";

    String lastMessageString =
        latestMessage != null ? latestMessage.content : "";

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: new InkWell(
        onTap: () {
          if (loggedUser != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(loggedUser!, user),
              ),
            );
          }
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.black.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  //Profile pic I think
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(user.avatar),
                        ),
                      ),
                    ),
                  ),
                  //Username, I think
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "@${shortenString(user.name)}",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Text(friend.email),
                        Text(
                          shortenString(lastMessageString),
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      child: Text(
                        timeString,
                        textAlign: TextAlign.end,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
