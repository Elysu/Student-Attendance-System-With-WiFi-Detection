import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseService _dbService = DatabaseService();
  UserModel userModel = UserModel();
  bool isTeacher = false;

  getAndSetUserDataIntoModel(String uid) async {
    await _dbService.getUserDataAndSetIntoModel(uid);
  }

  // use user data model to create user object based on firebase User
  UserModel? _userFromFirebase(User? user) {
    if (user != null) {
      getAndSetUserDataIntoModel(user.uid);
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

  // teacher register student
  Future registerStudent(String email, String password, String name, String id, List subjects) async {
    try {
      FirebaseApp app = await Firebase.initializeApp(name: 'Secondary', options: Firebase.app().options);
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
      .createUserWithEmailAndPassword(email: email, password: password);

      // create a document for the newly added student with their uid
      bool addStudentStatus = await _dbService.addUser(userCredential.user!.uid, email, password, name, id, subjects);

      await app.delete();
      return addStudentStatus;
    }
    on FirebaseAuthException catch (e) {
      // Do something with exception. This try/catch is here to make sure 
      // that even if the user creation fails, app.delete() runs, if is not, 
      // next time Firebase.initializeApp() will fail as the previous one was
      // not deleted.
      return e.code;
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

  Future deleteUser(String email) async {
    dynamic password = await _dbService.getUserPasswordWithEmail(email);
    if (password != null) {
      try {
        FirebaseApp app = await Firebase.initializeApp(name: 'Delete', options: Firebase.app().options);
        UserCredential userCredential = await FirebaseAuth.instanceFor(app: app).signInWithEmailAndPassword(email: email, password: password);
        User? currentUser = FirebaseAuth.instanceFor(app: app).currentUser;
        await currentUser!.delete();
        await app.delete();
        return true;
      }
      on FirebaseAuthException catch (e) {
        // Do something with exception. This try/catch is here to make sure 
        // that even if the user deletion fails, app.delete() runs, if is not, 
        // next time Firebase.initializeApp() will fail as the previous one was
        // not deleted.
        return e.code;
      }
    } else {
      print("Failed to delete student");
      return false;
    }
  }
}