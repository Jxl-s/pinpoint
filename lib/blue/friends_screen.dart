import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/_logged_user.dart';
import 'package:pinpoint/blue/classes/user.dart';
import './components/drawer.dart';

import './friends_screen_list.dart';
import './friends_screen_request.dart';
import './friends_screen_search.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen() {}

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<User> friends = [];
  List<User> requests = [];

  bool loaded = false;

  @override
  void initState() {
    super.initState();
    User? user = getLoggedUser();

    if (user != null) {
      Future<List<User>> friends = user.getFriends();
      Future<List<User>> requests = user.getIncomingRequests();

      Future.wait<List<User>>([friends, requests]).then((value) {
        setState(() {
          this.friends = User.example(4);
          this.requests = User.example(4);
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(this.friends);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: PinPointDrawer(
          title: 'Friends',
        ),
        appBar: AppBar(
          title: Text(
            "PinPoint - Friends",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: "FRIENDS",
              ),
              Tab(
                text: "REQUESTS",
              ),
              Tab(
                text: "SEARCH",
              )
            ],
          ),
          // add the temporary drawer thing here
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
          child: TabBarView(
            children: [
              FriendsScreenList(this.friends),
              FriendsScreenRequest(this.requests, this.friends),
              FriendsScreenSearch(),
              // MapPage(),
              // PinsPage(),
            ],
          ),
        ),
      ),
    );
  }
}
