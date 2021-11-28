import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_attendance_fyp/models/user_model.dart';

class DatabaseService {
  // collection reference
  // user collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

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


  // get current user isTeacher to determine if current user is teacher
  Future getUserTeacher(String uid) async {
    DocumentSnapshot snapshot = await userCollection.doc(uid).get();
    var data = snapshot.data() as Map;
    return data['isTeacher'];
  }

  /*
   bool isTeacher(String uid) {
    bool teacher = true;

    // userCollection.doc(uid).get().then((value){
    //   teacher = value.data()!['isTeacher'];
    //   print(teacher);
    // });

    Map<String, dynamic> data = userCollection.doc(uid).get();

    return teacher;
  }
  */
}