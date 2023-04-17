import 'package:flutter/material.dart';
import 'package:pinpoint/blue/landing_screen.dart';
import 'package:pinpoint/blue/map_screen.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  Main({super.key});

  final Widget screen = MapScreen();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinPoint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Poppins",
      ),
      home: screen,
    );
  }
}
