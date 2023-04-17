import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/note.dart';
import 'package:pinpoint/blue/components/drawer.dart';

class MyPinsNotesScreen extends StatefulWidget {
  int locationId;

  MyPinsNotesScreen(this.locationId);

  @override
  State<MyPinsNotesScreen> createState() => _MyPinsNotesScreenState(locationId);
}

class _MyPinsNotesScreenState extends State<MyPinsNotesScreen>
    with TickerProviderStateMixin {
  int locationId;
  List<Note> notes = [];

  _MyPinsNotesScreenState(this.locationId) {
    // TODO: fetch the notes in here
    notes = Note.example(5);
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
        child: Placeholder(),
      ),
    );
  }
}
