import 'package:pinpoint/blue/classes/user.dart';

User? loggedUser = null;

User? getLoggedUser() {
  if (loggedUser == null) {
    // try to fetch the user
    // loggedUser ??= User(
    //   name: 'Jia',
    //   email: 'jia@jia.com',
    //   avatar:
    //       'https://lh3.googleusercontent.com/ogw/AOLn63G9zxI6m2QCJv8VMG_nBCeMOUIFEgTZwI2dTKOGUA=s32-c-mo',
    // );
  }

  return loggedUser;
}
