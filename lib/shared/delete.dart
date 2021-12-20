import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/auth.dart';
import 'package:student_attendance_fyp/services/database.dart';

// 1 = student delete, 2 = subject delete
deleteDialog({ required BuildContext context, required String docID, required int type, String? subCode, String? subName, String? email }) {
  String content = "";

  switch (type) {
    case 1:
      content = "student";
      break;
    case 2:
      content = "subject";
      break;
    case 3:
      content = "class";
      break;
  }

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
                  if (email != null) {
                    await deleteStudent(context, docID, email);
                  } else {
                    print("Email is null");
                  }
                  break;
                case 2:
                  if (subCode != null || subName != null) {
                    await deleteSubject(context, docID, subCode!, subName!);
                  } else {
                    print("Sub Code or Sub Name is null");
                  }
                  break;
                case 3:
                  await deleteClass(context, docID);
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
deleteStudent(BuildContext context, String docID, String email) async {
  AuthService auth = AuthService();
  dynamic result = await auth.deleteUser(email);

  if (result == true) {
    DatabaseService dbService = DatabaseService();
    bool studentDelete = await dbService.deleteStudent(docID);

    if (studentDelete) {
      // pop twice
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Student successfully deleted from the system.", style: TextStyle(color: Colors.green)),
        )
      );
    } else {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to delete student.", style: TextStyle(color: Colors.red)),
        )
      );
    }
  } else {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Failed to delete student.", style: TextStyle(color: Colors.red)),
      )
    );
  }
}

// delete subject
deleteSubject(BuildContext context, String docID, String subCode, String subName) async {
  DatabaseService dbService = DatabaseService();
  bool subjectDelete = await dbService.deleteSubject(docID);

  if (subjectDelete) {
    bool userSubjectDelete = await dbService.deleteUserSubject(subCode, subName);

    if (userSubjectDelete) {
      // pop twice
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Subject successfully deleted from the system.", style: TextStyle(color: Colors.green)),
        )
      );
    }
  } else {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to delete subject.", style: TextStyle(color: Colors.red)),
      )
    );
  }
}

deleteClass(BuildContext context, String docID) async {
  DatabaseService dbService = DatabaseService();
  bool classDelete = await dbService.deleteClass(docID);

  if (classDelete) {
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 3);
  } else {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to delete class session.", style: TextStyle(color: Colors.red)),
      )
    );
  }
}