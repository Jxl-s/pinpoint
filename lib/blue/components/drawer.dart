import 'package:flutter/material.dart';

class PinPointDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
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
                    fontWeight: FontWeight.w600
                  ),
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
          ListTile(
            title: const Text(
              'Map View',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            title: const Text(
              'Map View',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
