import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/note.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/components/drawer.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:timeago/timeago.dart' as timeago;

class MyPinsNotesScreen extends StatefulWidget {
  Location location;

  MyPinsNotesScreen(this.location);

  @override
  State<MyPinsNotesScreen> createState() => _MyPinsNotesScreenState(location);
}

class _MyPinsNotesScreenState extends State<MyPinsNotesScreen>
    with TickerProviderStateMixin {
  Location location;

  List<Note> myNotes = [];
  List<Note> friendNotes = [];

  Future<void> fetchData() async {
    User? user = await AuthService.getLoggedUser();
    if (user != null) {
      List<Note> myNotes = await Note.getLocationNotes(user, location);
      List<Note> friendNotes = await Note.getFriendNotes(user, location);

      setState(() {
        this.myNotes = myNotes;
        this.friendNotes = friendNotes;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  _MyPinsNotesScreenState(this.location);

  void deleteNote(Note note) {
    showConfirmationDialog(
      context: context,
      title: 'Delete the note?',
      cancel: 'Cancel',
      submit: Text(
        'Yes, delete',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).errorColor,
        ),
      ),
      onPressed: () async {
        bool success = await note.delete();
        showNotification(
            context: context,
            text: success ? 'Deleted note!' : 'Error deleting note');

        if (success) {
          setState(() {
            myNotes.remove(note);
          });
        }
      },
    );
  }

  void editNote(Note note) {
    TextEditingController _textFieldController =
        TextEditingController(text: note.note);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit note'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "New note"),
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
                'Edit Note',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () async {
                String inputText = _textFieldController.text;

                note.note = inputText;
                bool success = await note.update();

                showNotification(
                    context: context,
                    text: success ? 'Modified note!' : 'Error modifying note');

                if (success) {
                  setState(() {});
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PinPoint - My Pins",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Notes for '${location.name}' (${myNotes.length})",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: myNotes.map((e) => NoteCard(e)).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "From Friends (${friendNotes.length})",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: friendNotes.map((e) => FriendNoteCard(e)).toList(),
                ),
              ),
            ],
          )),
    );
  }

  Widget NoteCard(Note note) {
    DateTime now = DateTime.now();
    String timeAgo = timeago.format(now.subtract(now.difference(note.date)));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.only(
          top: 10.0,
          left: 16.0,
          right: 16.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 4),
              child: Text(
                note.note,
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              timeAgo,
              style:
                  TextStyle(fontSize: 14, color: Colors.black.withOpacity(0.5)),
              textAlign: TextAlign.left,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    deleteNote(note);
                  },
                  child: Text(
                    'DELETE',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    editNote(note);
                  },
                  child: Text(
                    'EDIT',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget FriendNoteCard(Note note) {
    DateTime now = DateTime.now();
    String timeAgo = timeago.format(now.subtract(now.difference(note.date)));

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 4),
              child: Text(
                note.note,
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "@${note.author.name}",
                  style: TextStyle(
                      fontSize: 14, color: Colors.black.withOpacity(0.5)),
                  textAlign: TextAlign.left,
                ),
                Text(
                  timeAgo,
                  style: TextStyle(
                      fontSize: 14, color: Colors.black.withOpacity(0.5)),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
