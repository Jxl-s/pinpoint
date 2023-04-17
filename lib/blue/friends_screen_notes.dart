import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/classes/note.dart';
import 'package:pinpoint/blue/map_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class FriendsScreenNotes extends StatefulWidget {
  User friend;

  FriendsScreenNotes(this.friend);

  @override
  State<FriendsScreenNotes> createState() =>
      _FriendsScreenNotesState(this.friend);
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
}

class _FriendsScreenNotesState extends State<FriendsScreenNotes> {
  User friend;
  List<Note> notes = [];

  _FriendsScreenNotesState(this.friend) {
    this.notes = Note.example(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PinPoint - Friends",
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
            Text(
              "Notes from @${friend.name}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: notes.map((e) => NoteCard(e)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget NoteCard(Note note) {
    DateTime now = DateTime.now();
    String timeAgo = timeago.format(now.subtract(now.difference(note.date)));

    return Padding(
      padding: const EdgeInsets.only(top: 4, bottom: 4),
      child: Container(
        padding: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.black.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  truncateWithEllipsis(20, note.location.name),
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

            SizedBox(
              height: 4,
            ),
            Text(
              note.note,
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapScreen(note.location)),
                  );
                },
                child: Text(
                  'VIEW LOCATION',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
