import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinpoint/blue/services/data.dart';
import 'package:pinpoint/blue/classes/user.dart' as UserClass;

class AuthService {
  static final GoogleSignIn googleSignIn = GoogleSignIn();
  static final CollectionReference usersCollection =
      DataService.collection('users');

  static UserClass.User? loggedUser;

  static Future<void> signOut() async {
    loggedUser = null;
    await googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
  }

  static Future<UserClass.User?> getLoggedUser() async {
    if (loggedUser == null) {
      // try finding it
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // fetch the user from the database
        final QuerySnapshot q = await usersCollection
            .where('user_id', isEqualTo: user.uid)
            .limit(1)
            .get();

        // not found, so create it
        if (q.docs.length <= 0) {
          await googleSignIn.signOut();
          await FirebaseAuth.instance.signOut();

          return null;
        }

        UserClass.User newUser = UserClass.User(
          id: q.docs[0].get("user_id"),
          name: q.docs[0].get('name'),
          email: user.email!,
          avatar: q.docs[0].get('avatar'),
        );

        // if the user has a new avatar, update the avatar
        if (user.photoURL != q.docs[0].get('avatar')) {
          newUser.avatar = user.photoURL!;
          await newUser.update();
        }

        loggedUser = newUser;
      }
    }

    return loggedUser;
  }

  static Future<UserClass.User> doGoogleSignin() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    FirebaseAuth auth = FirebaseAuth.instance;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await auth.signInWithCredential(credential);
    User user = userCredential.user!;

    // Find the user in the database now
    final QuerySnapshot q = await usersCollection
        .where('user_id', isEqualTo: user.uid)
        .limit(1)
        .get();

    // if it does not exist, create it
    if (q.docs.length <= 0) {
      UserClass.User newUser = UserClass.User(
        id: user.uid,
        name: user.displayName!,
        email: user.email!,
        avatar: user.photoURL!,
      );

      await newUser.create();
      return newUser;
    }

    // Create the user
    return UserClass.User(
      id: q.docs[0].get('user_id'),
      name: q.docs[0].get('name'),
      email: q.docs[0].get('email'),
      avatar: q.docs[0].get('avatar'),
    );
  }
}
