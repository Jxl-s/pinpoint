import 'dart:math';

class Note {
  int id;
  String author;
  String note;
  DateTime date;

  Note({
    required this.id,
    required this.author,
    required this.note,
    required this.date,
  });

  static List<Note> example(int amount) {
    List<Note> notes = [
      Note(
          id: 1,
          author: 'John',
          note: 'Lorem ipsum dolor sit amet',
          date: DateTime.now()),
      Note(
          id: 2,
          author: 'Jane',
          note: 'Consectetur adipiscing elit',
          date: DateTime.now()),
      Note(
          id: 3,
          author: 'Bob',
          note: 'Sed do eiusmod tempor incididunt',
          date: DateTime.now()),
      Note(
          id: 4,
          author: 'Alice',
          note: 'Ut enim ad minim veniam',
          date: DateTime.now()),
      Note(
          id: 5,
          author: 'Charlie',
          note: 'Quis nostrud exercitation ullamco',
          date: DateTime.now()),
      Note(
          id: 6,
          author: 'Dave',
          note: 'Laboris nisi ut aliquip ex ea commodo consequat',
          date: DateTime.now()),
      Note(
          id: 7,
          author: 'Eve',
          note: 'Duis aute irure dolor in reprehenderit',
          date: DateTime.now()),
      Note(
          id: 8,
          author: 'Frank',
          note: 'Excepteur sint occaecat cupidatat non proident',
          date: DateTime.now()),
      Note(
          id: 9,
          author: 'Grace',
          note: 'Sunt in culpa qui officia deserunt mollit anim',
          date: DateTime.now()),
      Note(
          id: 10,
          author: 'Harry',
          note: 'Id est laborum et dolorum fuga',
          date: DateTime.now()),
      Note(
          id: 11,
          author: 'Ivy',
          note: 'Et harum quidem rerum facilis est et expedita distinctio',
          date: DateTime.now()),
      Note(
          id: 12,
          author: 'Jack',
          note: 'Nam libero tempore, cum soluta nobis est eligendi',
          date: DateTime.now()),
      Note(
          id: 13,
          author: 'Karen',
          note: 'Optio cumque nihil impedit quo minus',
          date: DateTime.now()),
      Note(
          id: 14,
          author: 'Leo',
          note: 'Temporibus autem quibusdam et aut officiis debitis',
          date: DateTime.now()),
      Note(
          id: 15,
          author: 'Maggie',
          note: 'On the other hand, we denounce with righteous',
          date: DateTime.now()),
      Note(
          id: 16,
          author: 'Nick',
          note: 'But I must explain to you how all this mistaken idea',
          date: DateTime.now()),
      Note(
          id: 17,
          author: 'Olivia',
          note: 'At vero eos et accusamus et iusto odio dignissimos',
          date: DateTime.now()),
      Note(
          id: 18,
          author: 'Pete',
          note: 'Similique sunt in culpa qui officia deserunt mollitia',
          date: DateTime.now()),
      Note(
          id: 19,
          author: 'Quinn',
          note: 'Itaque earum rerum hic tenetur a sapiente delectus',
          date: DateTime.now()),
      Note(
          id: 20,
          author: 'Rose',
          note: 'Neque porro quisquam est, qui dolorem ipsum quia',
          date: DateTime.now()),
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
