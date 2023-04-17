import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import './components/drawer.dart';

import './friends_screen_list.dart';
import './friends_screen_request.dart';
import './friends_screen_search.dart';

class FriendsScreen extends StatelessWidget {
  List<User> friends = [];
  List<User> requests = [];

  FriendsScreen() {
    friends = User.example(5);
    requests = User.example(5);
  }

  @override
  Widget build(BuildContext context) {
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
