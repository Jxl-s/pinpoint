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
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    'WELCOME TO PINPOINT',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Text(
                    '(picture of the icon goes here)',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 30,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Text(
                    'NEVER FORGET YOUR FAVOURITE LOCATIONS. PIN THEN AND COME BACK AT A LATER TIME',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            // Add your onPressed code here!
                          },
                          label: const Text('SIGN IN WITH FACEBOOK'),
                        ),
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            // Add your onPressed code here!
                          },
                          label: const Text('SIGN IN WITH DISCORD'),
                        ),
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: FloatingActionButton.extended(
                          onPressed: () {
                            // Add your onPressed code here!
                          },
                          label: const Text('SIGN IN WITH TWITTER'),
                        ),
                        width: double.infinity,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
