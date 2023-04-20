import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/main.dart';
import './components/drawer.dart';

class ChatScreen extends StatefulWidget {
  User user;

  ChatScreen(this.user);

  @override
  State<ChatScreen> createState() => _ChatScreenState(this.user);
}

class _ChatScreenState extends State<ChatScreen> {
  User user;

  _ChatScreenState(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PinPointDrawer(
        title: "Messages",
      ),
      appBar: AppBar(
        title: Text(
          "Pinpoint - Chat",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                "Doctor Strange",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: ListView(
                children: [
                  ChatCards(true, "Hello There Strange Doctor"),
                  ChatCards(false, "Hello There Iron Man",
                      "https://lumiere-a.akamaihd.net/v1/images/p_doctorstrange_19918_516f94d3.jpeg?region=0%2C0%2C540%2C810"),
                  ChatCards(false, "How are you doing today?",
                      "https://lumiere-a.akamaihd.net/v1/images/p_doctorstrange_19918_516f94d3.jpeg?region=0%2C0%2C540%2C810"),
                  ChatCards(true, "The weather is very nice!"),
                  ChatCards(true, "Thank you I made it rain"),
                ],
              ),
            ),
          ),
          Container(
            child: Row(
              children: [
                ButtonTheme(
                    height: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {}, child: Icon(Icons.send))),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a search term',
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget ChatCards(bool isSender, String message, [String? receiverImage]) {
    return Container(
      child: isSender
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Colors.blueAccent),
                      color: Colors.lightBlueAccent),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          // image: NetworkImage(friend.avatar), fit: BoxFit.fill),
                          image: NetworkImage(isSender
                              ? "https://m.media-amazon.com/images/M/MV5BMjE5MzcyNjk1M15BMl5BanBnXkFtZTcwMjQ4MjcxOQ@@._V1_FMjpg_UX1000_.jpg"
                              : receiverImage!))),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          // image: NetworkImage(friend.avatar), fit: BoxFit.fill),
                          image: NetworkImage(isSender
                              ? "https://m.media-amazon.com/images/M/MV5BMjE5MzcyNjk1M15BMl5BanBnXkFtZTcwMjQ4MjcxOQ@@._V1_FMjpg_UX1000_.jpg"
                              : receiverImage!))),
                ),
                Container(
                  margin: const EdgeInsets.all(15.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.blueAccent),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
    );
  }
}
