import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:student_attendance_fyp/models/user_model.dart';

class DatabaseService {
  // collection reference
  // user collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference classCollection = FirebaseFirestore.instance.collection('class');
  UserModel userModel = UserModel();

  /*
  Future updateUserData (String stuID, String stuName, String stuSubject, String stuSubCode, String stuDeviceID) async {
    return await studentCollection.doc(uid).set({
      'stu_id': stuID,
      'stu_name': stuName,
      'stu_subject': stuSubject,
      'stu_sub-code': stuSubCode,
      'stu_deviceID': stuDeviceID
    });
  }
  */

  // firestore streams
  // always listening to changes in the database
  // get users stream


  // get current user data and set it into UserModel
  Future getUserData(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    UserModel().setData(uid, data['deviceID'], data['email'], data['id'], data['name'], data['isTeacher'], data['subjects']);
  }

  // get all students document as a list
  Future getStudents() async {
    var data = await userCollection.where('isTeacher', isNotEqualTo: true).get();
    return data.docs;
  }

  // get class history doc ID (filtered with user's subject)
  Future getClassHistoryDocID() async {
    List<String>? docs = [];
    await classCollection.where('c_sub-code', whereIn: userModel.getSubjects).get().then((QuerySnapshot snapshot){
      snapshot.docs.forEach((DocumentSnapshot c) {
        docs.add(c.id);
      });
    });
    return docs;
  }
  // get class history data
  Stream<QuerySnapshot> getClassHistoryData(BuildContext context) async* {
    yield* classCollection.where('c_sub-code', whereIn: userModel.getSubjects).snapshots();
  }
  // Future getClassHistoryData(String docID) async {
  //   DocumentSnapshot snapshot = await classCollection.doc(docID).get();
  //   print("1.");
  //   return snapshot.data() as Map;
  // }
  // check if student's UID has a document in attendance subcollection
  Future<int> attendanceExists(String uid, String docID) async {
    DocumentSnapshot snapshot = await classCollection.doc(docID).collection('attendance').doc(uid).get();
    if (snapshot.exists) {
      var data = snapshot.data() as Map;
      if (data['isLate'] == true) {
        return 2;
      } else {
        return 1;
      }
    } else {
      return 0;
    }
  }
}