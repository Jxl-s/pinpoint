import 'dart:math';

class User {
  String id;
  String name;
  String email;
  String avatar;
  bool isFriend;
  bool requestSent;

  User({
    // optional props
    String? id,
    bool? isFriend,
    bool? requestSent,

    // required props
    required this.name,
    required this.email,
    required this.avatar,
  })  : id = id ?? '',
        isFriend = isFriend ?? false,
        requestSent = requestSent ?? false;

  Future<List<User>> getFriends() async {
    // TODO: using this user id, fetch the friends
    return User.example(5);
  }

  Future<List<User>> getIncomingRequests() async {
    // TODO: get the requests
    return User.example(5);
  }

  Future<bool> create() async {
    // TODO: create an entry, update the id too
    return true;
  }

  Future<bool> update() async {
    // TODO: using the id, update the fields
    return true;
  }

  Future<bool> delete() async {
    // TODO: using the id, delete the entry
    return true;
  }

  Future<bool> addFriend(User other) async {
    // TODO: create a request
    return true;
  }

  Future<bool> cancel(User other) async {
    // TODO: remove the request
    return true;
  }

  Future<bool> unfriend(User other) async {
    // TODO: using the id, unfriend
    return true;
  }

  Future<bool> accept(User other) async {
    // TODO: accept the request
    return true;
  }

  static List<User> example(int amount) {
    List<User> users = [
      User(
        id: '1',
        name: 'John Smith',
        email: 'john.smith@example.com',
        avatar: 'https://i.pravatar.cc/150?img=1',
        isFriend: false,
        requestSent: true,
      ),
      User(
        id: '2',
        name: 'Emily Jones',
        email: 'emily.jones@example.com',
        avatar: 'https://i.pravatar.cc/150?img=2',
        isFriend: true,
        requestSent: false,
      ),
      User(
        id: '3',
        name: 'William Davis',
        email: 'william.davis@example.com',
        avatar: 'https://i.pravatar.cc/150?img=3',
        isFriend: false,
        requestSent: false,
      ),
      User(
        id: '4',
        name: 'Sarah Brown',
        email: 'sarah.brown@example.com',
        avatar: 'https://i.pravatar.cc/150?img=4',
        isFriend: false,
        requestSent: false,
      ),
      User(
        id: '5',
        name: 'Jacob Johnson',
        email: 'jacob.johnson@example.com',
        avatar: 'https://i.pravatar.cc/150?img=5',
        isFriend: false,
        requestSent: false,
      ),
      User(
        id: '6',
        name: 'Olivia Williams',
        email: 'olivia.williams@example.com',
        avatar: 'https://i.pravatar.cc/150?img=6',
        isFriend: false,
        requestSent: true,
      ),
      User(
        id: '7',
        name: 'Ethan Wilson',
        email: 'ethan.wilson@example.com',
        avatar: 'https://i.pravatar.cc/150?img=7',
        isFriend: true,
        requestSent: false,
      ),
      User(
        id: '8',
        name: 'Sophia Garcia',
        email: 'sophia.garcia@example.com',
        avatar: 'https://i.pravatar.cc/150?img=8',
        isFriend: false,
        requestSent: false,
      ),
      User(
        id: '9',
        name: 'Michael Martinez',
        email: 'michael.martinez@example.com',
        avatar: 'https://i.pravatar.cc/150?img=9',
        isFriend: false,
        requestSent: true,
      ),
      User(
        id: '10',
        name: 'Isabella Anderson',
        email: 'isabella.anderson@example.com',
        avatar: 'https://i.pravatar.cc/150?img=10',
        isFriend: false,
        requestSent: true,
      ),
      User(
        id: '11',
        name: 'Daniel Thomas',
        email: 'daniel.thomas@example.com',
        avatar: 'https://i.pravatar.cc/150?img=11',
        isFriend: true,
        requestSent: false,
      ),
      User(
        id: '12',
        name: 'Mia Jackson',
        email: 'mia.jackson@example.com',
        avatar: 'https://i.pravatar.cc/150?img=12',
        isFriend: false,
        requestSent: false,
      ),
      User(
        id: '13',
        name: 'David White',
        email: 'david.white@example.com',
        avatar: 'https://i.pravatar.cc/150?img=13',
        isFriend: false,
        requestSent: true,
      ),
      User(
        id: '14',
        name: 'Charlotte Harris',
        email: 'charlotte.harris@example.com',
        avatar: 'https://i.pravatar.cc/150?img=14',
        isFriend: false,
        requestSent: true,
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
