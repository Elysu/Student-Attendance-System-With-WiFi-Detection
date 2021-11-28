import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();
  UserModel userModel = UserModel();
  bool isTeacher = false;

  void teacher(User user) async {
    await _dbService.getUserTeacher(user.uid).then((value){
      print("1. $value");
      isTeacher = value;
      userModel.setTeacher = value;
    });
    print("2. Actual isTeacher is $isTeacher");
    userModel.setUID = user.uid;
    print("3. Model isTeacher is ${userModel.getTeacher}");
  }

  // use user data model to create user object based on firebase User
  UserModel? _userFromFirebase(User user) {
    if (user != null) {
      teacher(user);
      return UserModel();
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

      // create a new document for the user with the uid
      // await DatabaseService(uid: user!.uid).updateUserData('1850232', 'Lee Sang Kit', 'HCI,PHP,C#,Networking', '132,BIBGGE122,BIBDD-233,WDIW-123', '666348384');

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