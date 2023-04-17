import 'dart:math';

class User {
  int id;
  String name;
  String email;
  String avatar;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
  });

  static List<User> example(int amount) {
    List<User> users = [
      User(
        id: 1,
        name: 'John Smith',
        email: 'john.smith@example.com',
        avatar: 'https://i.pravatar.cc/150?img=1',
      ),
      User(
        id: 2,
        name: 'Emily Jones',
        email: 'emily.jones@example.com',
        avatar: 'https://i.pravatar.cc/150?img=2',
      ),
      User(
        id: 3,
        name: 'William Davis',
        email: 'william.davis@example.com',
        avatar: 'https://i.pravatar.cc/150?img=3',
      ),
      User(
        id: 4,
        name: 'Sarah Brown',
        email: 'sarah.brown@example.com',
        avatar: 'https://i.pravatar.cc/150?img=4',
      ),
      User(
        id: 5,
        name: 'Jacob Johnson',
        email: 'jacob.johnson@example.com',
        avatar: 'https://i.pravatar.cc/150?img=5',
      ),
      User(
        id: 6,
        name: 'Olivia Williams',
        email: 'olivia.williams@example.com',
        avatar: 'https://i.pravatar.cc/150?img=6',
      ),
      User(
        id: 7,
        name: 'Ethan Wilson',
        email: 'ethan.wilson@example.com',
        avatar: 'https://i.pravatar.cc/150?img=7',
      ),
      User(
        id: 8,
        name: 'Sophia Garcia',
        email: 'sophia.garcia@example.com',
        avatar: 'https://i.pravatar.cc/150?img=8',
      ),
      User(
        id: 9,
        name: 'Michael Martinez',
        email: 'michael.martinez@example.com',
        avatar: 'https://i.pravatar.cc/150?img=9',
      ),
      User(
        id: 10,
        name: 'Isabella Anderson',
        email: 'isabella.anderson@example.com',
        avatar: 'https://i.pravatar.cc/150?img=10',
      ),
      User(
        id: 11,
        name: 'Daniel Thomas',
        email: 'daniel.thomas@example.com',
        avatar: 'https://i.pravatar.cc/150?img=11',
      ),
      User(
        id: 12,
        name: 'Mia Jackson',
        email: 'mia.jackson@example.com',
        avatar: 'https://i.pravatar.cc/150?img=12',
      ),
      User(
        id: 13,
        name: 'David White',
        email: 'david.white@example.com',
        avatar: 'https://i.pravatar.cc/150?img=13',
      ),
      User(
        id: 14,
        name: 'Charlotte Harris',
        email: 'charlotte.harris@example.com',
        avatar: 'https://i.pravatar.cc/150?img=14',
      )
    ];

    Random random = Random();
    List<User> result = [];

    while (result.length < amount) {
      final element = users[random.nextInt(users.length)];
      if (!result.contains(element)) {
        result.add(element);
      }
    }

    return result;
  }
}
