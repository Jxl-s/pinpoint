import 'package:flutter/material.dart';
import 'package:pinpoint/blue/PinPointPage.dart';

class MapScreen extends PinPointScreen {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "PinPoint - Map",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                text: "NEARBY",
              ),
              Tab(
                text: "MAP",
              ),
              Tab(
                text: "PINS",
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
              NearbyPage(),
              MapPage(),
              PinsPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget NearbyPage() {
    return Placeholder();
  }

  Widget MapPage() {
    return Placeholder();
  }

  Widget PinsPage() {
    return Placeholder();
  }
}
