import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/landing_screen.dart';
import 'package:pinpoint/blue/map_screen.dart';
import 'package:pinpoint/blue/search_screen.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/blue/settings_screen.dart';
import 'package:pinpoint/blue/about_screen.dart';
import 'package:pinpoint/blue/contacts_screen.dart';
import 'package:pinpoint/blue/chat_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Main());
}

class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  // Main({super.key});
  late Widget screen;
  _MainState() {
    // For testing purposes
    // screen = ChatScreen();
    screen = LandingScreen(onSignin: fetchUser);
  }

  Future<void> fetchUser() async {
    User? user = await AuthService.getLoggedUser();
    if (user != null) {
      setState(() {
        screen = MapScreen();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinPoint',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        errorColor: Colors.red,
        fontFamily: "Poppins",
      ),
      home: screen,
    );
  }
}
