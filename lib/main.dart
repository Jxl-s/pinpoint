import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/landing_screen.dart';
import 'package:pinpoint/blue/map_screen.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/blue/settings_screen.dart';
import 'package:pinpoint/blue/about_screen.dart';
import 'package:pinpoint/blue/contacts_screen.dart';
import 'package:pinpoint/blue/chat_screen.dart';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AwesomeNotifications().initialize(
      null,
      [            // notification icon
        NotificationChannel(
          channelGroupKey: 'messages_channel_key',
          channelKey: 'messages_group',
          channelName: 'Message notifications',
          channelDescription: 'Notification channel for messages',
          channelShowBadge: true,
          importance: NotificationImportance.High,
        ),
      ]
  );

  AwesomeNotifications().actionStream.listen((ReceivedNotification receivedNotification){});

  FirebaseMessaging.instance.subscribeToTopic("messages"); //subscribe firebase message on topic
  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  runApp(Main());
}

Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();

  User? loggedUser = await AuthService.getLoggedUser();
  if (loggedUser == null) return;
  if (message.data['receiver_id'] != loggedUser!.id) return;

  AwesomeNotifications().createNotification(
      content: NotificationContent( //with image from URL
          id: 1,
          channelKey: 'messages_group', //channel configuration key
          title: message.data["sender_name"],
          body: message.data["content"],
          bigPicture: message.data["image"],
          notificationLayout: NotificationLayout.BigText,
          payload: {"name":"flutter"}
      )
  );
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
    FirebaseMessaging.onMessage.listen(firebaseBackgroundMessage);
    fetchUser();
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
