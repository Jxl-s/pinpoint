import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinpoint/blue/classes/user.dart';
import 'package:pinpoint/blue/classes/location.dart';
import 'package:pinpoint/blue/services/data.dart';

class Note {
  String id;
  User author;
  String note;
  Location location;
  DateTime date;

  Note({
    // optional props
    String? id,
    DateTime? date,

    // required props
    required this.author,
    required this.note,
    required this.location,
  })  : date = date ?? DateTime.now(),
        id = id ?? '';

  static Future<List<Note>> getNotes(User user) async {
    // TODO: using the user id, fetch their notes
    return Note.example(5);
  }

  static Future<List<Note>> getLocationNotes(
      User user, Location location) async {
    // Future<QuerySnapshot> friendQuery1 = DataService.collection('friends')
    //     .where('friend_id_1', isEqualTo: user.id)
    //     .get();
    //
    // Future<QuerySnapshot> friendQuery2 = DataService.collection('friends')
    //     .where('friend_id_1', isEqualTo: user.id)
    //     .get();

    // 2. get the notes of that location
    QuerySnapshot noteQuery = await DataService.collection('notes')
        .where('location_id', isEqualTo: location.id)
        .get();

    // var allQueries =
    //     await Future.wait([friendQuery1, friendQuery2, locationPinsQuery]);

    // TODO: optimize the speed
    List<Note> userNotes = [];
    List<Future<QuerySnapshot>> noteQueries = [];

    for (int i = 0; i < noteQuery.docs.length; i++) {
      var element = noteQuery.docs[i];
      if (element.get('author_id') != user.id) continue;

      // get the author with it
      noteQueries.add(DataService.collection("users")
          .where('user_id', isEqualTo: element.get('author_id'))
          .get());
    }

    var noteQueriesRun = await Future.wait(noteQueries);
    for (int i = 0; i < noteQuery.docs.length; i++) {
      var element = noteQuery.docs[i];
      var authorUserQuery = noteQueriesRun[i];

      if (element.get('author_id') != user.id) continue;
      if (authorUserQuery.docs.isEmpty) continue;

      User noteAuthor = User(
        id: element.get('author_id'),
        name: authorUserQuery.docs[0].get('name'),
        email: authorUserQuery.docs[0].get('email'),
        avatar: authorUserQuery.docs[0].get('avatar'),
      );

      userNotes.add(
        Note(
          id: element.id,
          date: element.get('date').toDate(),
          author: noteAuthor,
          note: element.get('note'),
          location: location,
        ),
      );
    }

    return userNotes;
  }

  static Future<List<Note>> getFriendNotes(User user, Location location) async {
    // TODO: maybe a joined query for this one
    return Note.example(5);
  }

  Future<bool> create() async {
    try {
      DocumentReference newNote = await DataService.collection("notes").add({
        'author_id': author.id,
        'date': DateTime.now(),
        'location_id': location.id,
        'note': note
      });

      this.id = newNote.id;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update() async {
    try {
      // find the existing note
      await DataService.collection("notes")
          .doc(this.id)
          .update({'date': DateTime.now(), 'note': note});

      return true;
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> delete() async {
    try {
      // find the existing note
      await DataService.collection("notes").doc(this.id).delete();

      return true;
    } catch (e) {
      return false;
    }
  }

  static List<Note> example(int amount) {
    List<Note> notes = [
      Note(
        id: '1',
        author: User.example(1)[0],
        note: 'Lorem ipsum dolor sit amet',
        date: DateTime(2022, 5, 12),
        location: Location.example(1)[0],
      ),
      Note(
        id: '2',
        author: User.example(1)[0],
        note: 'Consectetur adipiscing elit',
        date: DateTime(2023, 1, 2),
        location: Location.example(1)[0],
      ),
      Note(
        id: '3',
        author: User.example(1)[0],
        note: 'Sed do eiusmod tempor incididunt',
        date: DateTime(2021, 1, 20),
        location: Location.example(1)[0],
      ),
      Note(
        id: '4',
        author: User.example(1)[0],
        note: 'Ut enim ad minim veniam',
        date: DateTime(2023, 1, 30),
        location: Location.example(1)[0],
      ),
      Note(
        id: '5',
        author: User.example(1)[0],
        note: 'Quis nostrud exercitation ullamco',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '6',
        author: User.example(1)[0],
        note: 'Laboris nisi ut aliquip ex ea commodo consequat',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '7',
        author: User.example(1)[0],
        note: 'Duis aute irure dolor in reprehenderit',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '8',
        author: User.example(1)[0],
        note: 'Excepteur sint occaecat cupidatat non proident',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '9',
        author: User.example(1)[0],
        note: 'Sunt in culpa qui officia deserunt mollit anim',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '10',
        author: User.example(1)[0],
        note: 'Id est laborum et dolorum fuga',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '11',
        author: User.example(1)[0],
        note: 'Et harum quidem rerum facilis est et expedita distinctio',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '12',
        author: User.example(1)[0],
        note: 'Nam libero tempore, cum soluta nobis est eligendi',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '13',
        author: User.example(1)[0],
        note: 'Optio cumque nihil impedit quo minus',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '14',
        author: User.example(1)[0],
        note: 'Temporibus autem quibusdam et aut officiis debitis',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '15',
        author: User.example(1)[0],
        note: 'On the other hand, we denounce with righteous',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '16',
        author: User.example(1)[0],
        note: 'But I must explain to you how all this mistaken idea',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '17',
        author: User.example(1)[0],
        note: 'At vero eos et accusamus et iusto odio dignissimos',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '18',
        author: User.example(1)[0],
        note: 'Similique sunt in culpa qui officia deserunt mollitia',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '19',
        author: User.example(1)[0],
        note: 'Itaque earum rerum hic tenetur a sapiente delectus',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
      Note(
        id: '20',
        author: User.example(1)[0],
        note: 'Neque porro quisquam est, qui dolorem ipsum quia',
        date: DateTime.now(),
        location: Location.example(1)[0],
      ),
    ];

    Random random = Random();
    List<Note> result = [];

    while (result.length < amount) {
      final element = notes[random.nextInt(notes.length)];
      if (!result.contains(element)) {
        result.add(element);
      }
    }

    return result;
  }
}
