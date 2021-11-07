import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_attendance_fyp/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // use user data model to create user object based on firebase User
  UserModel? _userFromFirebase(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  // auth change user stream
  // map the user from firebase to our UserModel from the stream to determine if user object is null or has value
  Stream<UserModel?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebase(user!));
  }

  // sign in anonymously
  Future anonSignIn() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with username & password

  // sign out
}