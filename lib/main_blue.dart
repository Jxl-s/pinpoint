import 'package:flutter/material.dart';
import 'package:pinpoint/blue/PinPointPage.dart';
import 'package:pinpoint/blue/landing_screen.dart';
import 'package:pinpoint/blue/map_screen.dart';

class MainBlue extends StatelessWidget {
  PinPointScreen screen = MapScreen();

  MainBlue({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinPoint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Poppins",
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            screen.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
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
        // drawer: Drawer(),
        body: screen,
      ),
    );
  }
}
