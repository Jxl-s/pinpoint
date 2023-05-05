import 'package:flutter/material.dart';
import 'package:pinpoint/blue/chat_screen.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/friends_screen_notes.dart';
import 'package:pinpoint/blue/services/auth.dart';
import './components/drawer.dart';

class FriendsScreen extends StatefulWidget {
  FriendsScreen() {}

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  List<User> friends = [];
  List<User> filteredFriends = [];
  List<User> searchResults = [];
  List<User> requests = [];

  bool loaded = false;
  bool isSearching = false;

  final TextEditingController _friendSearchController =
      new TextEditingController();

  _FriendsScreenState() {
    _friendSearchController.addListener(updateFilteredFriends);
  }

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
        this.filteredFriends = [...friends];
        this.requests = requests;

        loaded = true;
      });
    }
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
            loaded ? "PinPoint - Friends" : "Please wait ...",
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
              FriendsListScreen(),
              FriendsRequestScreen(),
              FriendsSearchScreen()
            ],
          ),
        ),
      ),
    );
  }

  // FRIENDS LIST SCREEN
  void updateFilteredFriends() {
    String filterText = _friendSearchController.text;
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

  Widget FriendsListScreen() {
    return Center(
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
              controller: _friendSearchController,
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
                  onPressed: () async {
                    User? loggedUser = await AuthService.getLoggedUser();
                    if (loggedUser == null) return;

                    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => ChatScreen(loggedUser!, friend)));
                  },
                  child: Text(
                    'MESSAGE',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FriendsScreenNotes(friend),
                      ),
                    );
                  },
                  child: Text(
                    'VIEW NOTES',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showConfirmationDialog(
                      context: context,
                      title: 'Unfriend user?',
                      cancel: 'Cancel',
                      submit: Text(
                        'Yes, unfriend',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).errorColor,
                        ),
                      ),
                      onPressed: () async {
                        User? user = await AuthService.getLoggedUser();
                        if (user == null) return;

                        bool success = await user!.unfriend(friend);
                        showNotification(
                          context: context,
                          text: success
                              ? 'User unfriended!'
                              : 'Error unfriending user',
                        );

                        if (success) {
                          setState(() {
                            friends.remove(friend);
                            updateFilteredFriends();
                          });
                        }
                      },
                    );
                  },
                  child: Text(
                    'UNFRIEND',
                    style: TextStyle(
                        color: Theme.of(context).errorColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // FRIEND REQUESTS

  Widget FriendsRequestScreen() {
    return Column(
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
            children: requests.map((e) => FriendRequestCard(e)).toList(),
          ),
        )
      ],
    );
  }

  Widget FriendRequestCard(User friend) {
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
                    User? user = await AuthService.getLoggedUser();
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
                        requests.remove(friend);
                        friends.add(friend);
                        updateFilteredFriends();
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

  // FRIENDS SEARCH
  TextEditingController _searchFieldController = new TextEditingController();

  Future<void> searchUsers(String user) async {
    setState(() {
      isSearching = true;
    });

    User? loggedUser = await AuthService.getLoggedUser();
    if (loggedUser == null) return;

    var found = await User.searchUsers(user);
    setState(() {
      isSearching = false;
      searchResults = found;
    });
  }

  Future<bool> cancelRequest(User user) async {
    User? me = await AuthService.getLoggedUser();
    if (me == null) return false;

    bool success = await me.cancel(user);
    showNotification(
        context: context,
        text: success ? 'Request cancelled!' : 'Error cancelling request');

    if (success) {
      setState(() {
        user.requestSent = false;
      });
    }

    return true;
  }

  Future<bool> sendRequest(User user) async {
    User? me = await AuthService.getLoggedUser();
    if (me == null) return false;

    bool success = await me.addFriend(user);
    showNotification(
        context: context,
        text: success ? 'Request sent!' : 'Error sending request');

    if (success) {
      setState(() {
        user.requestSent = true;
      });
    }

    return true;
  }

  Widget FriendsSearchScreen() {
    return Center(
      child: Column(
        children: [
          Text(
            isSearching ? 'Searching ...' : 'Search',
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
    );
  }

  Widget SearchResultCard(User friend) {
    String buttonText = friend.requestSent ? 'CANCEL REQUEST' : 'SEND REQUEST';
    Color buttonColor = friend.requestSent
        ? Colors.black.withOpacity(0.5)
        : Theme.of(context).primaryColor;

    print("${friend.isFriend} frien ${friend.name}");
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
