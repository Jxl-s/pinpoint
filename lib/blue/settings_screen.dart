import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/note.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/main.dart';
import './components/drawer.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool loaded = false;
  User? user;
  TextEditingController usernameController = TextEditingController();
  TextEditingController deleteEmailController = TextEditingController();

  Future<void> fetchData() async {
    User? user = await AuthService.getLoggedUser();
    setState(() {
      loaded = true;
      this.user = user;
      usernameController.text = user?.name ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Center(
              child: Text(
                "Settings",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Text(
            'Pinpoint Settings',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showConfirmationDialog(
                    context: context,
                    title: 'Delete all pinpoints?',
                    cancel: 'No, cancel',
                    submit: Text(
                      'Yes, delete',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                    onPressed: () async {
                      if (user == null) {
                        return showNotification(
                            context: context, text: 'Not logged in?');
                      }

                      // get all the pinpoints from that user
                      List<Location> pins = await Location.getPins(user!);

                      List<Future<bool>> removeRuns = [];

                      // for each of them, send a delete request
                      for (int i = 0; i < pins.length; i++) {
                        Location pin = pins[i];
                        removeRuns.add(pin.removePin(user!));
                      }

                      await Future.wait(removeRuns);

                      return showNotification(
                          context: context, text: 'Cleared pinpoints!');
                    });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).errorColor,
              ),
              child: Text(
                "Clear All Pinpoints",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showConfirmationDialog(
                    context: context,
                    title: 'Delete all notes?',
                    cancel: 'No, cancel',
                    submit: Text(
                      'Yes, delete',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).errorColor,
                      ),
                    ),
                    onPressed: () async {
                      if (user == null) {
                        return showNotification(
                            context: context, text: 'Not logged in?');
                      }

                      // get all the pinpoints from that user
                      List<Note> notes = await Note.getNotes(user!);

                      List<Future<bool>> removeRuns = [];

                      // for each of them, send a delete request
                      for (int i = 0; i < notes.length; i++) {
                        Note note = notes[i];
                        removeRuns.add(note.delete());
                      }

                      await Future.wait(removeRuns);
                      return showNotification(
                          context: context, text: 'Cleared notes!');
                    });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).errorColor,
              ),
              child: Text(
                "Delete All Notes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Change Username',
            style: TextStyle(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          TextField(
            controller: usernameController,
            decoration: InputDecoration(hintText: 'New Username'),
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (user == null) {
                  return showNotification(
                      context: context, text: 'Not logged in?');
                }

                user!.name = usernameController.text;
                bool success = await user!.update();
                if (success) {
                  return showNotification(
                      context: context, text: 'Username changed!');
                }

                return showNotification(
                    context: context, text: 'Erorr changing username!');
              },
              child: Text("Change Username"),
            ),
          ),
          Expanded(child: SizedBox()),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('Enter email to confirm deletion'),
                      content: TextField(
                        controller: deleteEmailController,
                        decoration: InputDecoration(hintText: "Email"),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        TextButton(
                          child: Text(
                            'Delete Account',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: Theme.of(context).errorColor),
                          ),
                          onPressed: () async {
                            print(deleteEmailController.text);
                            if (user == null) {
                              return showNotification(
                                  context: context, text: 'Not logged in?');
                            }

                            if (deleteEmailController.text != user!.email) {
                              return showNotification(
                                  context: context,
                                  text: 'Emails do not match');
                            }

                            print("ABOUE TO DELETE");
                            bool success = await user!.delete();
                            if (!success) {
                              return showNotification(
                                  context: context,
                                  text: 'Error deleting account');
                            }

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => Main()),
                            ).then((value) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "Delete Account",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).errorColor),
            ),
          )
        ],
      ),
    );
  }
}
