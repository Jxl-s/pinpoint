import 'package:flutter/material.dart';
import 'package:pinpoint/blue/friends_screen.dart';
import 'package:pinpoint/blue/landing_screen.dart';
import 'package:pinpoint/blue/map_screen.dart';
import 'package:pinpoint/blue/my_pins_screen.dart';

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

class PinPointDrawer extends StatelessWidget {
  String title = "";
  late BuildContext context;

  List<PageItem> pages = [
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
    PageItem(title: 'Friends', icon: Icons.person, page: FriendsScreen())
  ];

  PinPointDrawer({String? title}) {
    this.title = title ?? "";
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;
    return Drawer(
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
                  children: [
                    Expanded(
                      child: Text(
                        'PinPoint',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    Text(
                      '@Jia Xuan Li',
                      style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'jia@gmail.com',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 14,
                      ),
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
    );
  }

  Widget PageButton(PageItem page) {
    ButtonStyle buttonStyle = title == page.title
        ? TextButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.blue)
        : TextButton.styleFrom(
            foregroundColor: Colors.black.withOpacity(0.5),
          );

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
      child: TextButton(
        onPressed: () {
          if (title == page.title) return;

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => page.page),
          ).then((value) {
            Navigator.pop(context);
          });
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
