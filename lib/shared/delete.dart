import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/database.dart';

// 1 = student delete, 2 = subject delete
deleteDialog(BuildContext context, String docID, int type, [String? subCode, String? subName]) {
  String content = type == 1 ? "student" : "subject";

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete $content?'),
        content: Text('This $content will be permanently removed from the system. Continue?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () async {
              switch (type) {
                case 1:
                  await deleteStudent(docID);
                  break;
                case 2:
                  if (subCode != null || subName != null) {
                    await deleteSubject(docID, subCode!, subName!);
                    Navigator.pop(context);
                  } else {
                    print("Sub Code or Sub Name is null");
                  }
                  break;
              }
            },
            child: const Text('DELETE'),
          ),
        ],
      );
    }
  );
}

// delete student
deleteStudent(String docID) async {

}

// delete subject
deleteSubject(String docID, String subCode, String subName) async {
  DatabaseService dbService = DatabaseService();
  bool subjectDelete = await dbService.deleteSubject(docID);

  if (subjectDelete) {
    bool userSubjectDelete = await dbService.deleteUserSubject(subCode, subName);

    if (userSubjectDelete) {
      print("Successfully deleted");
    }
  } else {
    print("Subject Delete Failed");
  }
}