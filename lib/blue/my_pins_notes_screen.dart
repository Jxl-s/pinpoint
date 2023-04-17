import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/note.dart';
import 'package:pinpoint/blue/components/drawer.dart';
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

  _MyPinsNotesScreenState(this.location) {
    // TODO: fetch the notes in here
    myNotes = Note.example(5);
    friendNotes = Note.example(2);
  }

  void deleteNote(Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Do you really want to delete the note?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'No, cancel',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text(
                'Yes, delete',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              onPressed: () {
                // TODO: now actually delete it here
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void editNote(Note note) {
    TextEditingController _textFieldController = TextEditingController(text: note.note);

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
              onPressed: () {
                String inputText = _textFieldController.text;

                // TODO: actually make the note edit, make sure to check that the user is allowed
                // to edit this note
                print('edit note!');
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
                        fontWeight: FontWeight.w600, color: Colors.red),
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
                  "@${note.author}",
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
