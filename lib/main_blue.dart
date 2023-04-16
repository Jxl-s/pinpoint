import 'package:flutter/material.dart';
import 'package:pinpoint/blue/landing_screen.dart';
import './nearby_item.dart';

class MainBlue extends StatelessWidget {
  var screen = LandingScreen();
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
          title: Center(
            child: Text(
              screen.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        body: screen,
      ),
    );
  }
}
