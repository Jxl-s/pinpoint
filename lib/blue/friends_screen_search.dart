import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/_logged_user.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';

class FriendsScreenSearch extends StatefulWidget {
  @override
  State<FriendsScreenSearch> createState() => _FriendsScreenSearchState();
}

class _FriendsScreenSearchState extends State<FriendsScreenSearch> {
  List<User> searchResults = [];
  TextEditingController _searchFieldController = new TextEditingController();

  _FriendsScreenSearchState() {
    searchResults = User.example(10);
  }

  void searchUsers(String user) {
    // will be implemented in the future
    setState(() {
      searchResults = User.example(10);
    });
  }

  Future<bool> cancelRequest(User user) async {
    User? me = getLoggedUser();
    if (me == null) return false;

    bool success = await me.cancel(user);
    showNotification(context: context, text: success ? 'Request cancelled!' : 'Error cancelling request');

    if (success) {
      setState(() {
        user.requestSent = false;
      });
    }

    return true;
  }

  Future<bool> sendRequest(User user) async {
    User? me = getLoggedUser();
    if (me == null) return false;

    bool success = await me.addFriend(user);
    showNotification(context: context, text: success ? 'Request sent!' : 'Error sending request');

    if (success) {
      setState(() {
        user.requestSent = true;
      });
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text(
            'Search',
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
                hintText: 'Search Users',
              ),
              onSubmitted: ((value) {
                searchUsers(value);
              }),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView(
              children: searchResults.map((e) => SearchResultCard(e)).toList(),
            ),
          ),
        ],
      ),
      // ),
    );
  }

  Widget SearchResultCard(User friend) {
    String buttonText = friend.requestSent ? 'CANCEL REQUEST' : 'SEND REQUEST';
    Color buttonColor =
        friend.requestSent ? Colors.black.withOpacity(0.5) : Colors.blue;

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
                      image: NetworkImage(
                        friend.avatar,
                      ),
                      fit: BoxFit.fill,
                    ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                !friend.isFriend
                    ? TextButton(
                        onPressed: friend.requestSent
                            ? () {
                                cancelRequest(friend);
                              }
                            : () {
                                sendRequest(friend);
                              },
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: buttonColor,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 16.0,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
