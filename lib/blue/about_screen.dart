import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/note.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/main.dart';
import './components/drawer.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PinPointDrawer(
        title: "About",
      ),
      appBar: AppBar(
        title: Text(
          "PinPoint - About",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Text(
                "About Us",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 30, right: 20, left: 20),
            child: Center(
              child: Text(
                "This application was developped by college students for a mobile "
                "application development course.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
          ),
          Text(
            "Jia Xuan Li",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          Text(
            "Mert Kairstan Salvador",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ],
      ),
    );
  }
}
