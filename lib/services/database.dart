import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_attendance_fyp/models/user_model.dart';

class DatabaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // collection reference
  // user collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference classCollection = FirebaseFirestore.instance.collection('class');
  final CollectionReference subjectCollection = FirebaseFirestore.instance.collection('subjects');
  UserModel userModel = UserModel();

  // firestore streams
  // always listening to changes in the database
  // get users stream

  // register student from teacher side
  Future<bool> addUser(String uid, String email, String password, String name, String id, List subjects) async {
    bool status = await userCollection.doc(uid).set({
      'deviceID': null,
      'email': email,
      'password': password,
      'id': id,
      'isTeacher': false,
      'name': name,
      'subjects': subjects
    }).then((value) => true)
    .catchError((error) => false);

    return status;
  }
  // update student data
  Future<bool> updateUserData (String uid, String name, String id, List subjects) async {
    bool status = await userCollection.doc(uid).update({
      'id': id,
      'name': name,
      'subjects': subjects
    }).then((value) => true)
    .catchError((error) => false);

    return status;
  }
  // delete student based on docID
  Future deleteStudent(String docID) async {
    bool status = await userCollection.doc(docID).delete()
    .then((value) => true)
    .catchError((error) {
      print(error.toString());
      return false;
    });

    return status;
  }

  // add subject into database
  Future<bool> addSubject(String subCode, String subName, Map subTeacher) async {
    bool status = await subjectCollection.add({
      "sub_code": subCode,
      "sub_name": subName,
      "sub_teacher": subTeacher
    }).then((value) => true)
    .catchError((error) => false);

    return status;
  }
  // check if subject exist before adding into database
  Future<bool> checkSubjectExist(String subCode) async {
    var data = await subjectCollection.where('sub_code', isEqualTo: subCode).get();
    if (data.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  // update subjects on teacher user
  Future<bool> updateUserTeacherSubject (String uid, List subject) async {
    bool status = await userCollection.doc(uid).update({
      "subjects": FieldValue.arrayUnion(subject)
    }).then((value) => true)
    .catchError((error) => false);

    return status;
  }
  // delete subject based on doc ID
  Future deleteSubject(String docID) async {
    bool status = await subjectCollection.doc(docID).delete()
    .then((value) => true)
    .catchError((error) {
      print(error.toString());
      return false;
    });

    return status;
  }
  // delete subject details under users
  Future deleteUserSubject(String subCode, String subName) async {
    var data = await userCollection.where("subjects", arrayContains: {"sub_code": subCode, "sub_name": subName}).get();

    if (data.docs.isNotEmpty) {
      List elementDelete = [{"sub_code": subCode, "sub_name": subName}];
      bool? status;
      for (int i=0; i<data.docs.length; i++) {
        status = await userCollection.doc(data.docs[i].id).update({
          "subjects": FieldValue.arrayRemove(elementDelete)
        }).then((value) => true)
        .catchError((error) {
          print(error.toString());
          return false;
        });

        if (status == false) {
          break;
        }
      }

      return status;
    } else {
      print("No document with this sub_code in Users collection");
      return false;
    }
  }

  // get current user data and set it into UserModel
  Future getUserData(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    String deviceID = data['deviceID'] != null ? data['deviceID'].toString() : '';
    List subjects = data['subjects'];
    UserModel().setData(uid, deviceID, data['email'], data['id'], data['name'], data['isTeacher'], subjects);
  }

  // get all teachers document as a list
  Future getTeachers() async {
    var data = await userCollection.where('isTeacher', isEqualTo: true).get();
    return data.docs;
  }
  // get teacher details
  Future getTeacherDetails(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    return data;
  }

  // get all students document as a list
  Future getStudents() async {
    var data = await userCollection.where('isTeacher', isNotEqualTo: true).get();
    return data.docs;
  }
  // get a student detail
  Future getStudentDetails(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    return data;
  }

  // get all subjects document as a list
  Future getSubjects() async {
    List docs = [];
    await subjectCollection.get().then((snapshot) {
      for (var doc in snapshot.docs) {
        docs.add(doc.id);
      }
    });
    print(docs);
    return docs;
  }
  // get subject details based on single document
  Future getSubjectDetails(String subjectID) async {
    DocumentSnapshot snapshot = await subjectCollection.doc(subjectID).get();
    var data = snapshot.data() as Map;
    return data;
  }

  // get ongoing class
  Stream<QuerySnapshot> getOngoingClassData(BuildContext context) async* {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    List subjects = data['subjects'];
    List subjectCode = [];

    for (int i=0; i<subjects.length; i++) {
      subjectCode.add(subjects[i]['sub_code']);
    }

    yield* classCollection
    .where('c_sub-code', whereIn: subjectCode)
    .where('c_ongoing', isEqualTo: true)
    .orderBy("c_datetimeStart", descending: false)
    .snapshots();
  }

  // get upcoming class
  Stream<QuerySnapshot> getUpcomingClassData(BuildContext context) async* {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    List subjects = data['subjects'];
    List subjectCode = [];

    for (int i=0; i<subjects.length; i++) {
      subjectCode.add(subjects[i]['sub_code']);
    }

    yield* classCollection
    .where('c_sub-code', whereIn: subjectCode)
    .where('c_datetimeStart', isGreaterThan: DateTime.now())
    .where('c_ongoing', isEqualTo: false)
    .orderBy("c_datetimeStart", descending: false)
    .snapshots();
  }

  // get class history data
  Stream<QuerySnapshot> getClassHistoryData(BuildContext context) async* {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    List subjects = data['subjects'];
    List subjectCode = [];

    for (int i=0; i<subjects.length; i++) {
      subjectCode.add(subjects[i]['sub_code']);
    }

    yield* classCollection
    .where('c_sub-code', whereIn: subjectCode)
    .where('c_datetimeEnd', isLessThan: DateTime.now())
    .where('c_ongoing', isEqualTo: false)
    .orderBy("c_datetimeEnd", descending: true)
    .snapshots();
  }

  // check if student's UID has a document in attendance subcollection
  // 0 = absent, 1 = present, 2 = late
  Stream<int> attendanceExists(String uid, String docID) async* {
    DocumentSnapshot snapshot = await classCollection.doc(docID).collection('attendance').doc(uid).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map;
      if (data['isLate'] == true) {
        yield 2;
      } else {
        yield 1;
      }
    } else {
      yield 0;
    }
  }
}