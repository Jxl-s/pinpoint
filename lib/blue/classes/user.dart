import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinpoint/blue/services/auth.dart';
import 'package:pinpoint/blue/services/data.dart';

class User {
  String id;
  String name;
  String email;
  String avatar;
  bool isFriend;
  bool requestSent;

  static CollectionReference userCollection = DataService.collection('users');
  static CollectionReference friendCollection =
      DataService.collection('friends');
  static CollectionReference friendRequestsCollection =
      DataService.collection('friend_requests');

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

  static Future<List<User>> searchUsers(String query) async {
    User? loggedUser = await AuthService.getLoggedUser();
    if (loggedUser == null) {
      return [];
    }

    // TODO: using this user id, fetch the friends
    var searchQueries = await Future.wait([
      userCollection.where('name', isEqualTo: query).get(),
      userCollection.where('email', isEqualTo: query).get()
    ]);

    QuerySnapshot results1 = searchQueries[0];
    QuerySnapshot results2 = searchQueries[1];

    // merge the two arrays of docs
    var results = [...results1.docs, ...results2.docs];

    List<User> friends = [];
    for (int i = 0; i < results.length; i++) {
      var r = results[i];

      // check if it's a friend
      QuerySnapshot isFriendQuery = await friendCollection
          .where('friend_id_1', isEqualTo: loggedUser!.id)
          .where('friend_id_1', isEqualTo: r.get('user_id'))
          .where('friend_id_2', isEqualTo: loggedUser!.id)
          .where('friend_id_2', isEqualTo: r.get('user_id'))
          .get();

      // then check if it has a pending request
      QuerySnapshot hasRequestQuery = await friendRequestsCollection
          .where('request_asker', isEqualTo: loggedUser!.id)
          .where('request_target', isEqualTo: r.get('user_id'))
          .get();

      bool isFriend = !isFriendQuery.docs.isEmpty;
      bool hasRequest = !hasRequestQuery.docs.isEmpty;

      friends.add(
        User(
          id: r.get('user_id'),
          name: r.get('name'),
          email: r.get('email'),
          avatar: r.get('avatar'),
          isFriend: isFriend,
          requestSent: hasRequest,
        ),
      );
    }

    return friends;
  }

  Future<List<User>> getFriends() async {
    // TODO: using this user id, fetch the friends
    QuerySnapshot results = await userCollection
        .where('friend_1', isEqualTo: id)
        .where('friend_2', isEqualTo: id)
        .get();

    List<User> friends = [];
    for (int i = 0; i < results.docs.length; i++) {
      var r = results.docs[i];
      friends.add(
        User(
          id: r.get('user_id'),
          name: r.get('name'),
          email: r.get('email'),
          avatar: r.get('avatar'),
        ),
      );
    }

    return friends;
  }

  Future<List<User>> getIncomingRequests() async {
    QuerySnapshot results =
        await userCollection.where('request_receiver', isEqualTo: id).get();

    List<User> friends = [];
    for (int i = 0; i < results.docs.length; i++) {
      var r = results.docs[i];
      friends.add(
        User(
          id: r.get('user_id'),
          name: r.get('name'),
          email: r.get('email'),
          avatar: r.get('avatar'),
        ),
      );
    }

    return friends;
  }

  Future<bool> create() async {
    // TODO: create an entry, update the id too
    try {
      await userCollection.add({
        'user_id': id,
        'name': name,
        'avatar': avatar,
        'email': email,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> update() async {
    // TODO: using the id, update the fields
    try {
      QuerySnapshot q =
          await userCollection.where('user_id', isEqualTo: id).limit(1).get();

      if (q.docs.length <= 0) return false;

      await userCollection.doc(q.docs[0].id).update({
        'user_id': id,
        'avatar': avatar,
        'email': email,
        'name': name,
      });

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> delete() async {
    // TODO: using the id, delete the entry
    return true;
  }

  Future<bool> addFriend(User other) async {
    User? loggedUser = await AuthService.getLoggedUser();
    if (loggedUser == null) {
      return false;
    }

    // TODO: create a request
    // make sure there's no current entry for that specific
    // relation already
    QuerySnapshot hasRequestQuery = await friendRequestsCollection
        .where('request_asker', isEqualTo: loggedUser!.id)
        .where('request_target', isEqualTo: other.id)
        .get();

    if (!hasRequestQuery.docs.isEmpty) {
      return false;
    }

    // add the request now
    try {
      // if there is a request the other way around, then they are now friends
      QuerySnapshot hasRequestQuery2 = await friendRequestsCollection
          .where('request_target', isEqualTo: loggedUser!.id)
          .where('request_asker', isEqualTo: other.id)
          .get();

      if (hasRequestQuery2.docs.isNotEmpty) {
        // make the friends
        await friendCollection
            .add({'friend_id_1': loggedUser!.id, 'friend_id_2': other.id});
      } else {
        // make the relation
        await friendRequestsCollection.add({
          'request_asker': loggedUser!.id,
          'request_target': other.id,
        });
      }

      return true;
    } catch (e) {
      return false;
    }
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
