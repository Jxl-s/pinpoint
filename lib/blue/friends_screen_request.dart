import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/_logged_user.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';

class FriendsScreenRequest extends StatefulWidget {
  List<User> requests;
  FriendsScreenRequest(List<User> this.requests);

  @override
  State<FriendsScreenRequest> createState() => _FriendsScreenRequestState(this.requests);
}

class _FriendsScreenRequestState extends State<FriendsScreenRequest> {
  late BuildContext context;
  List<User> requests;

  _FriendsScreenRequestState(List<User> this.requests);
  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Center(
      child: Column(
        children: [
          Text(
            'Requests',
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
              shrinkWrap: true,
              children: widget.requests.map((e) => FriendCard(e)).toList(),
            ),
          )
        ],
      ),
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
                TextButton(
                  onPressed: () async {
                    User? user = getLoggedUser();
                    if (user == null) return;

                    bool success = await user!.accept(friend);
                    showNotification(
                      context: context,
                      text: success
                          ? 'Request accepted!'
                          : 'Error accepting request',
                    );

                    if (success) {
                      setState(() {
                        widget.requests.remove(friend);
                      });
                    }
                  },
                  child: Text(
                    'ACCEPT REQUEST',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
