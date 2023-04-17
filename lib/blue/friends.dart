import 'package:flutter/material.dart';
import 'friendTabs/friendList.dart';
import 'friendTabs/request.dart';
import 'friendTabs/search.dart';

class Friends extends StatelessWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('P I N P O I N T - F R I E N D S'),
        ),
        body: Column(
          children: [
            TabBar(
              labelColor: Colors.deepOrangeAccent,
              unselectedLabelColor: Colors.deepPurple,
              tabs: [
                Tab(
                  text: 'Friends',
                ),
                Tab(
                  text: 'Requests',
                ),
                Tab(
                  text: 'Search',
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  FriendList(),
                  Request(),
                  Search(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
