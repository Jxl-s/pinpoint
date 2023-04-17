import 'package:flutter/material.dart';
import 'package:pinpoint/blue/components/drawer.dart';
import 'package:pinpoint/blue/friendTabs/friendList.dart';
import 'package:pinpoint/blue/friendTabs/request.dart';
import 'package:pinpoint/blue/friendTabs/search.dart';

class FriendsScreen extends StatelessWidget {
  const FriendsScreen({Key? key}) : super(key: key);

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
              FriendList(),
              Request(),
              Search()
              // MapPage(),
              // PinsPage(),
            ],
          ),
        ),
      ),
    );
  }

}
