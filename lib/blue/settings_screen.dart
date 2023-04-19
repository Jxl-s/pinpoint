import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';
import './components/drawer.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool loaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PinPointDrawer(
        title: "Settings",
      ),
      appBar: AppBar(
        title: Text(
          loaded ? "PinPoint - Settings" : "Please wait ...",
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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(20),
        child: settingsMenu(),
      ),
    );
  }

  Widget settingsMenu() {
    return Center(
      child: Column(
        children: [
          Text("Settings"),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: (){},
              child: Text("Clear All Pinpoints"),
            ),
          ),
          Text("Change Username"),
          TextField(
            decoration: InputDecoration(
              hintText: 'Donkey Mario Bowser'
            ),
          ),
          Container(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: (){},
                child: Text("Change Username")
            )
          ),

          //Added temporary gap
          //Issues: overflow when textfield is used
          SizedBox(
            height: 473,
          ),

          Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (){},
                child: Text("Delete Account"),
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  onPrimary: Colors.white
                )
              )
          )
        ],
      ),
    );
  }
}
