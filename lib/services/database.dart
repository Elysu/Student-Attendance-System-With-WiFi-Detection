import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      'last_deviceID': null,
      'current_deviceID': null,
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
  Future<bool> updateUserData(String uid, String name, String id, List subjects) async {
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
  // check if ID exists
  Future checkIDExist(String studentID) async {
    var data = await userCollection.where('id', isEqualTo: studentID).get();
    if (data.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
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
  // update subjects on teacher user (add subject)
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
  // update subject details
  Future<bool> updateSubject(String docID, String subCode, String subName, Map subTeacher) async {
    bool status = await subjectCollection.doc(docID).update({
      'sub_code': subCode,
      'sub_name': subName,
      'sub_teacher': subTeacher
    }).then((value) => true)
    .catchError((error) {
      return false;
    });

    return status;
  }
  // update subjects under teacher when teacher changed for this subject (edit subject)
  Future<bool> updateTeacherSubject(String subjectDocID, String oldSubCode, String oldSubName, String newSubCode, String newSubName, Map currentTeacher, Map newTeacher) async {
    List oldSubject = [{"sub_code": oldSubCode, "sub_name": oldSubName}];
    List newSubject = [{"sub_code": newSubCode, "sub_name": newSubName}];
    
    if (currentTeacher == newTeacher) {
      bool isSubCodeSame = oldSubCode == newSubCode ? true : false;
      bool isSubNameSame = oldSubName == newSubName ? true : false;

      if (isSubCodeSame && isSubNameSame) {
        return true;
      } else {
        // remove old sub code and sub name from teacher
        bool removeOldSubject = await userCollection.doc(currentTeacher["t_uid"]).update({
        'subjects': FieldValue.arrayRemove(oldSubject),
        }).then((value) => true)
        .catchError((error) {
          return false;
        });

        // update new sub code and sub name for teacher
        bool addNewSubject = await userCollection.doc(currentTeacher["t_uid"]).update({
        'subjects': FieldValue.arrayUnion(newSubject),
        }).then((value) => true)
        .catchError((error) {
          return false;
        });

        if (removeOldSubject && addNewSubject) {
          return true;
        } else {
          return false;
        }
      }
    } else {
      // remove old sub code and sub name for old teacher
      bool statusCurrentTeacher = await userCollection.doc(currentTeacher["t_uid"]).update({
        'subjects': FieldValue.arrayRemove(oldSubject),
      }).then((value) => true)
      .catchError((error) {
        print(error.toString());
        return false;
      });

      // update new sub code and sub name to new teacher
      bool statusNewTeacher = await userCollection.doc(newTeacher["t_uid"]).update({
        'subjects': FieldValue.arrayUnion(newSubject),
      }).then((value) => true)
      .catchError((error) {
        print(error.toString());
        return false;
      });

      if (statusCurrentTeacher && statusNewTeacher) {
        return true;
      } else {
        return false;
      }
    }
  }

  // get current user data and set it into UserModel
  Future getUserDataAndSetIntoModel(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    String currentDeviceID = data['current_deviceID'] != null ? data['deviceID'].toString() : '';
    String lastDeviceID = data['last_deviceID'] != null ? data['deviceID'].toString() : '';
    List subjects = data['subjects'];
    userModel.setData(uid, currentDeviceID, lastDeviceID, data['email'], data['id'], data['name'], data['isTeacher'], subjects);
  }

  Future getUserData() async {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    return data;
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
    return docs;
  }
  // get subject details based on single document
  Future getSubjectDetails(String subjectID) async {
    DocumentSnapshot snapshot = await subjectCollection.doc(subjectID).get();
    var data = snapshot.data() as Map;
    return data;
  }

  // get class details based on single document
  Future getClassDetails(String docID) async {
    DocumentSnapshot snapshot = await classCollection.doc(docID).get();
    var data = snapshot.data() as Map;
    return data;
  }
  // update class details
  Future<bool> updateClassDetails(String docID, DateTime datetimeStart, DateTime datetimeEnd, String classroom, bool classOngoing, [dynamic ongoingTime]) async {
    bool status;
    
    // if user wish to keep ongoing time
    if (ongoingTime == 0) {
      status = await classCollection.doc(docID).update({
        'c_datetimeStart': datetimeStart,
        'c_datetimeEnd': datetimeEnd,
        'classroom': classroom,
        'c_ongoing': classOngoing
      }).then((value) => true)
      .catchError((error) => false);
    } else {
      // reset ongoing time to new time or set it to null
      status = await classCollection.doc(docID).update({
        'c_datetimeStart': datetimeStart,
        'c_datetimeEnd': datetimeEnd,
        'classroom': classroom,
        'c_ongoing': classOngoing,
        'c_ongoingTime': ongoingTime
      }).then((value) => true)
      .catchError((error) => false);
    }

    return status;
  }
  // delete class session based on single document
  Future deleteClass(String docID) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // delete subcollection documents with loop
    bool batchStatus = await classCollection.doc(docID).collection('students').get().then((qs) {
      qs.docs.forEach((doc) {
        batch.delete(doc.reference);
      });

      return batch.commit().then((value) => true).catchError((error) => false);
    });

    // delete main document in class collection
    bool status = await classCollection.doc(docID).delete()
    .then((value) => true)
    .catchError((error) {
      print(error.toString());
      return false;
    });

    if (status && batchStatus) {
      return true;
    } else {
      return false;
    }
  }
  // check if there are any ongoing class for this subjects
  Future checkOngoingClassForSubject(String subCode) async {
    var data = await classCollection.where("c_sub-code", isEqualTo: subCode).where("c_ongoing", isEqualTo: true).get();
    if (data.docs.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
  // create class session
  Future createClassSession(Map subject, DateTime dStart, DateTime dEnd, String classroom, bool isOngoing, dynamic ongoingTime) async {
    Map subTeacher = subject["sub_teacher"];
    String docID = classCollection.doc().id;

    bool status = await classCollection.doc(docID).set({
      "c_datetimeEnd": dEnd,
      "c_datetimeStart": dStart,
      "c_ongoing": isOngoing,
      "c_sub-code": subject["sub_code"],
      "c_sub-name": subject["sub_name"],
      "c_teacher": {"t_id": subTeacher["t_id"], "t_name": subTeacher["t_name"]},
      "classroom": classroom,
      'c_ongoingTime': ongoingTime
    }).then((value) => true)
    .catchError((error) => false);

    if (status) {
      return docID;
    } else {
      return false;
    }
  }
  // set student with this subject into the subcollection (students) of this class session
  Future addStudentsIntoClass(Map subject, String classID) async {
    var docList = await userCollection
    .where("subjects", arrayContains: {"sub_code": subject["sub_code"], "sub_name": subject["sub_name"]})
    .where("isTeacher", isEqualTo: false)
    .get();

    if (docList.docs.isNotEmpty) {
      bool returnStatus = true;

      for (int i=0; i<docList.docs.length; i++){
        DocumentSnapshot ds = await userCollection.doc(docList.docs[i].id).get();

        bool status = await classCollection.doc(classID).collection("students").doc(docList.docs[i].id).set({
          "datetime": null,
          "deviceID": null,
          "id": ds["id"],
          "name": ds["name"],
          "status": "n/a",
          "uid": docList.docs[i].id
        }).then((value) => true)
        .catchError((error) {
          print(error.toString());
          return false;
        });

        if (status == false) {
          returnStatus = false;
          break;
        }
      }

      return returnStatus;
    } else {
      return "no-student";
    }
  }

  // get ongoing class
  Stream<QuerySnapshot> getOngoingClassData(BuildContext context) async* {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;

    if (data["isTeacher"] == false) {
      List subjects = data['subjects'];
      List subjectCode = [];

      for (int i=0; i<subjects.length; i++) {
        subjectCode.add(subjects[i]['sub_code']);
      }

      yield* classCollection
      .where('c_sub-code', whereIn: subjectCode)
      .where('c_ongoing', isEqualTo: true)
      .orderBy("c_datetimeEnd", descending: false)
      .snapshots();
    } else {
      Map teacher = {"t_id": data["id"], "t_name": data["name"]};

      yield* classCollection
      .where('c_teacher', isEqualTo: teacher)
      .where('c_ongoing', isEqualTo: true)
      .orderBy("c_datetimeEnd", descending: false)
      .snapshots();
    }
  }

  // get upcoming class
  Stream<QuerySnapshot> getUpcomingClassData(BuildContext context) async* {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;

    if (data["isTeacher"] == false) {
      List subjects = data['subjects'];
      List subjectCode = [];

      for (int i=0; i<subjects.length; i++) {
        subjectCode.add(subjects[i]['sub_code']);
      }

      yield* classCollection
      .where('c_sub-code', whereIn: subjectCode)
      .where('c_datetimeEnd', isGreaterThan: DateTime.now())
      .where('c_ongoing', isEqualTo: false)
      .orderBy("c_datetimeEnd", descending: false)
      .snapshots();
    } else {
      Map teacher = {"t_id": data["id"], "t_name": data["name"]};

      yield* classCollection
      .where('c_teacher', isEqualTo: teacher)
      .where('c_datetimeEnd', isGreaterThan: DateTime.now())
      .where('c_ongoing', isEqualTo: false)
      .orderBy("c_datetimeEnd", descending: false)
      .snapshots();
    }
  }

  // get class history data
  Stream<QuerySnapshot> getClassHistoryData(BuildContext context) async* {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    
    if (data["isTeacher"] == false) {
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
    } else {
      Map teacher = {"t_id": data["id"], "t_name": data["name"]};

      yield* classCollection
      .where('c_teacher', isEqualTo: teacher)
      .where('c_datetimeEnd', isLessThan: DateTime.now())
      .where('c_ongoing', isEqualTo: false)
      .orderBy("c_datetimeEnd", descending: true)
      .snapshots();
    }
  }

  // check if student's UID has a document in attendance subcollection
  // 0 = absent, 1 = present, 2 = late
  Stream<int> streamGetAttendance(String docID) async* {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await classCollection.doc(docID).collection('students').doc(uid).get();

    if (snapshot.exists){
      var data = snapshot.data() as Map;
      if (data["status"] == "present") {
        yield 1;
      } else  if (data["status"] == "late") {
        yield 2;
      } else {
        yield 0;
      }
    }
  }
  // Future version of attendance exists
  Future futureGetAttendance(String docID) async {
    final uid = await _auth.currentUser!.uid;
    DocumentSnapshot snapshot = await classCollection.doc(docID).collection('students').doc(uid).get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map;
      if (data['status'] == "present") {
        return 1;
      } else  if (data["status"] == "late") {
        return 2;
      } else {
        return 0;
      }
    }
  }

  // get user data based on email
  Future getUserPasswordWithEmail(String email) async {
    var docList = await userCollection.where("email", isEqualTo: email).get();

    if (docList.docs.isNotEmpty) {
      DocumentSnapshot ds = await userCollection.doc(docList.docs[0].id).get();
      var data = ds.data() as Map;
      
      return data["password"].toString();
    } else {
      print("No user document to delete");
      return null;
    }
  }

  // get total students in this class
  Future getTotalAttendance(String classID) async {
    var docList = await classCollection.doc(classID).collection('students').get();
    CollectionReference attendanceCollection = classCollection.doc(classID).collection('students');
    int totalAttendance = 0;

    if (docList.docs.isNotEmpty) {
      for (int i=0; i<docList.docs.length; i++) {
        DocumentSnapshot ds = await attendanceCollection.doc(docList.docs[i].id).get();
        var data = ds.data() as Map;

        if (data["status"] == "present" || data["status"] == "late") {
          totalAttendance++;
        }
      }
      String strAttendance = totalAttendance.toString() + "/" + docList.docs.length.toString();
      return strAttendance;
    } else {
      return "This class has no student.";
    }
  }

  Future takeAttendance(String classID, String attendance) async {
    final uid = await _auth.currentUser!.uid;
    bool status = await classCollection.doc(classID).collection('students').doc(uid).update({
      'status': attendance,
      'datetime': DateTime.now()
    }).then((value) => true)
    .catchError((error) => false);

    return status;
  }
}