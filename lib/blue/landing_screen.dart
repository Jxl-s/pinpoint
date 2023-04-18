import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/map_screen.dart';
import 'package:pinpoint/blue/services/auth.dart';

class LandingScreen extends StatefulWidget {
  Function onSignin;
  LandingScreen({required Function this.onSignin});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PinPoint",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Welcome to PinPoint",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 50,
              ),
            ),
            Text(
              "Never forget your favourite locations. "
              "Pin them and come back at a later time.",
              style: TextStyle(
                fontWeight: FontWeight.w100,
                fontSize: 20,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  signinButton(
                      provider: "Google",
                      onPressed: () async {
                        User user = await AuthService.doGoogleSignin();
                        if (user != null) {
                          widget.onSignin();
                        }
                      }),
                  // signinButton(provider: "Facebook", onPressed: () {}),
                  // signinButton(provider: "Discord", onPressed: () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget signinButton(
      {required String provider, required void Function() onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        width: double.infinity,
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            "SIGN IN WITH ${provider.toUpperCase()}",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ),
      ),
    );
  }
}
