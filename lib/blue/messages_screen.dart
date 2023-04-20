import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';
import './components/drawer.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<User> friends = [];
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
      List<User> requests = await user.getIncomingRequests();

      setState(() {
        this.friends = friends;

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
              icon: const Icon(Icons.email),
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
              MessageCard(),
              MessageCard(),
              MessageCard()
            ],
          ),
        ),
      ),
    );
  }

  Widget MessageCard() {
    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: new InkWell(
        onTap: () {
          print("Container clicked");
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
                  Column(
                    children: [
                      Text(
                        "16h",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                  //Profile pic I think
                  Container(
                    margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            // image: NetworkImage(friend.avatar), fit: BoxFit.fill),
                            image: NetworkImage(
                                "https://cdn-prod.medicalnewstoday.com/content/images/articles/271/271157/bananas-chopped-up-in-a-bowl.jpg"))),
                  ),
                  //Username, I think
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // "@${friend.name}",
                        "BananaJoe",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // Text(friend.email),
                      FittedBox(
                        child: Text(
                          "Banana are the best!",
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    ],
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
