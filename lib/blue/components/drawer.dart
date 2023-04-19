import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/friends_screen.dart';
import 'package:pinpoint/blue/friends_screen_notes.dart';
import 'package:pinpoint/blue/landing_screen.dart';
import 'package:pinpoint/blue/map_screen.dart';
import 'package:pinpoint/blue/my_pins_screen.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/blue/settings_screen.dart';
import 'package:pinpoint/main.dart';

class PageItem {
  String title;
  IconData icon;
  Widget page;

  PageItem({
    required this.title,
    required this.icon,
    required this.page,
  });
}

class PinPointDrawer extends StatefulWidget {
  String title = "";

  PinPointDrawer({String? title}) {
    this.title = title ?? "";
  }

  @override
  State<PinPointDrawer> createState() => _PinPointDrawerState();
}

class _PinPointDrawerState extends State<PinPointDrawer> {
  User? loggedUser;

  late BuildContext context;

  Future<User?> fetchUser() async {
    User? user = await AuthService.getLoggedUser();

    setState(() {
      loggedUser = user;
    });

    return user;
  }

  late List<PageItem> pages;

  _PinPointDrawerState() {
    this.pages = [
      PageItem(
        title: 'Map View',
        icon: Icons.map,
        page: MapScreen(),
      ),
      PageItem(
        title: 'My Pins',
        icon: Icons.pin_drop,
        page: MyPinsScreen(),
      ),
      PageItem(
        title: 'Friends',
        icon: Icons.person,
        page: FriendsScreen(),
      ),
      PageItem(
        title: 'Settings',
        icon: Icons.settings,
        page: SettingsScreen(),
      ),
    ];

    fetchUser().then((value) {
      setState(() {
        this.pages.add(
              PageItem(
                title: 'View My Notes',
                icon: Icons.note,
                page: FriendsScreenNotes(value!),
              ),
            );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(child: Container()), // fill out empty space

                          Container(
                            // margin: const EdgeInsets.only(left: 10.0, right: 15.0),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(loggedUser?.avatar ?? ''),
                                  fit: BoxFit.fill),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "@${loggedUser?.name ?? 'name'}",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.75),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                loggedUser?.email ?? 'email',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ] +
                  pages.map((e) => PageButton(e)).toList(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                AuthService.signOut().then((value) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Main()),
                  ).then((value) {
                    Navigator.pop(context);
                  });
                });
              },
              child: Text(
                'SIGN OUT',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget PageButton(PageItem page) {
    ButtonStyle buttonStyle = widget.title == page.title
        ? TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue)
        : TextButton.styleFrom(
            foregroundColor: Colors.black.withOpacity(0.5),
          );

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      child: TextButton(
        onPressed: () {
          if (widget.title == page.title) return;

          // if it's the my pins page, it's special
          if (page.title == 'View My Notes') {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page.page),
            ).then((value) {
              Navigator.pop(context);
            });
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => page.page),
            ).then((value) {
              Navigator.pop(context);
            });
          }

          Scaffold.of(context).closeDrawer();
        },
        style: buttonStyle,
        child: Row(
          children: [
            Icon(page.icon),
            SizedBox(
              width: 10,
            ),
            Text(page.title)
          ],
        ),
      ),
    );
  }
}
