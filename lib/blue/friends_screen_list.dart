import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/friend.dart';

class FriendsScreenList extends StatefulWidget {
  List<User> friends = [];

  FriendsScreenList(this.friends);

  @override
  State<FriendsScreenList> createState() => _FriendsScreenListState(this.friends);
}

class _FriendsScreenListState extends State<FriendsScreenList> {
  List<User> friends = [];
  List<User> filteredFriends = [];

  _FriendsScreenListState(List<User> friends) {
    this.friends = friends;
    filteredFriends = [...friends];

    _searchFieldController.addListener(updateFilteredFriends);
  }

  TextEditingController _searchFieldController = TextEditingController();

  void updateFilteredFriends() {
    String filterText = _searchFieldController.text;
    List<User> newFiltered = [];

    for (int i = 0; i < friends.length; i++) {
      if (friends[i].email.toLowerCase().contains(filterText)) {
        newFiltered = [...newFiltered, friends[i]];
        continue;
      }

      if (friends[i].name.toLowerCase().contains(filterText)) {
        newFiltered = [...newFiltered, friends[i]];
        continue;
      }
    }

    setState(() {
      filteredFriends = newFiltered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // child: SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Friends',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            child: TextField(
              controller: _searchFieldController,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                prefixIcon: Icon(Icons.search),
                hintText: 'Search Friends',
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: filteredFriends.map((e) => FriendCard(e)).toList(),
            ),
          ),
        ],
      ),
      // ),
    );
  }

  Widget FriendCard(User friend) {
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
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'MESSAGE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'VIEW NOTES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'UNFRIEND',
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
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
