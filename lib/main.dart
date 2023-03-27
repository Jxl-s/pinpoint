import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PinPoint',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(252, 107, 98, 1),
                Color.fromRGBO(248, 209, 151, 1)
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text(
                  'Welcome To Pinpoint',
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 40,
                      fontFamily: "RubikMonoOne"),
                  textAlign: TextAlign.center,
                ),
                Image.asset(
                    "assets/images/front_logo.png",
                  scale: 0.5,
                ),
                const Text(
                  'Never forget your favourite locations. '
                  'Pin them and come back at a later time.',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      fontFamily: "RubikMonoOne"),
                  textAlign: TextAlign.center,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Sign in with Facebook',
                          style: TextStyle(
                            fontFamily: "RubikMonoOne",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Sign in with Discord',
                          style: TextStyle(
                            fontFamily: "RubikMonoOne",
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text(
                          'Sign in with Google',
                          style: TextStyle(
                            fontFamily: "RubikMonoOne",
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
