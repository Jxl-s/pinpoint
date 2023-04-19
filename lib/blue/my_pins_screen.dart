import 'package:flutter/material.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/classes/note.dart';
import 'package:pinpoint/blue/components/confirm_dialog.dart';
import 'package:pinpoint/blue/components/drawer.dart';
import 'package:pinpoint/blue/my_pins_notes_screen.dart';
import 'package:pinpoint/blue/services/auth.dart';

class MyPinsScreen extends StatefulWidget {
  @override
  State<MyPinsScreen> createState() => _MyPinsScreenState();
}

class _MyPinsScreenState extends State<MyPinsScreen>
    with TickerProviderStateMixin {
  List<String> sortOptions = ['Distance', 'Name'];

  int order = 1;
  int sortIndex = 0;

  List<Location> pinnedLocations = [];

  Future<void> fetchData() async {
    User? user = await AuthService.getLoggedUser();
    if (user != null) {
      List<Location> locations = await Location.getPins(user);
      
      setState(() {
        pinnedLocations = locations;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData().then((value) => sortPins());
  }
  
  Future<bool> addNote(Location location, String note) async {
    User? loggedUser = await AuthService.getLoggedUser();
    if (note.isEmpty) return false;
    if (loggedUser == null) return false;
    // create the new note

    Note newNote = Note(
      author: loggedUser!,
      note: note,
      location: location,
    );

    bool success = await newNote.create();
    showNotification(context: context, text: success ? 'Added note!' : 'Error adding note');

    return true;
  }

  void _showDialog(Location location) {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create a note'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Note"),
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
                'Create Note',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                String inputText = _textFieldController.text;

                Navigator.pop(context);
                addNote(location, inputText);
              },
            ),
          ],
        );
      },
    );
  }

  void nextSort() {
    setState(() {
      sortIndex++;

      if (sortIndex >= sortOptions.length) {
        sortIndex = 0;
      }
    });

    sortPins();
  }

  void nextOrder() {
    setState(() {
      order = -order;
    });

    sortPins();
  }

  void sortPins() {
    switch (sortOptions[sortIndex]) {
      case 'Distance':
        pinnedLocations.sort((a, b) => (a.distance - b.distance) * order);
        break;
      case 'Name':
        pinnedLocations.sort((a, b) => a.name.compareTo(b.name) * order);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PinPointDrawer(
        title: 'My Pins',
      ),
      appBar: AppBar(
        title: Text(
          "PinPoint - My Pins",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // add the temporary drawer thing here
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
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                TextButton(
                  onPressed: () {
                    nextSort();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  child: Text(
                    "Sort By: ${sortOptions[sortIndex]}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    nextOrder();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  child: Text(
                    "Order: ${order == 1 ? 'Ascending' : 'Descending'}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView(
                children: pinnedLocations.map((e) => PinCard(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget PinCard(Location location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        padding: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
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
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      formatPlaceType(location.type),
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Text(
                  location.getDistanceString(),
                  style: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 4),
              child: Text(
                location.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              location.address,
              style: TextStyle(
                fontSize: 12,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _showDialog(location);
                  },
                  child: Text(
                    'ADD NOTE',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyPinsNotesScreen(location),
                      ),
                    );
                  },
                  child: Text(
                    'VIEW NOTES',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black.withOpacity(0.5),
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
}
