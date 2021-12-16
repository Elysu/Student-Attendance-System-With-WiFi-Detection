import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/database.dart';

// 1 = student delete, 2 = subject delete
deleteDialog(BuildContext context, String docID, int type, [String? subCode, String? subName]) {
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
                  await deleteStudent(context, docID);
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
deleteStudent(BuildContext context, String docID) async {
  DatabaseService dbService = DatabaseService();
  bool studentDelete = await dbService.deleteStudent(docID);

  if (studentDelete) {
    // pop twice
    int count = 0;
    Navigator.of(context).popUntil((_) => count++ >= 2);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Student successfully deleted from the system."),
      )
    );
  } else {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to delete student."),
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
          content: Text("Subject successfully deleted from the system."),
        )
      );
    }
  } else {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to delete subject."),
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
        content: Text("Failed to delete class session."),
      )
    );
  }
}