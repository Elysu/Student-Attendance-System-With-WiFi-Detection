import 'package:firebase_auth/firebase_auth.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();
  UserModel userModel = UserModel();
  bool isTeacher = false;

  void getAndSetUserDataIntoModel(User user) async {
    await _dbService.getUserData(user.uid);
  }

  // use user data model to create user object based on firebase User
  UserModel? _userFromFirebase(User user) {
    if (user != null) {
      getAndSetUserDataIntoModel(user);
      return userModel;
    } else {
      return null;
    }
  }

  // auth change user stream
  // map the user from firebase to our UserModel from the stream to determine if user object is null or has value
  Stream<UserModel?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebase(user!));
    //.map() is to pass the user from firebase to our own user custom model
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
  Future signInEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future userSignOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}