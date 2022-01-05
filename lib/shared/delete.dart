import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/main.dart';
import 'package:student_attendance_fyp/services/auth.dart';
import 'package:student_attendance_fyp/services/database.dart';

// 1 = student delete, 2 = subject delete
deleteDialog({ required BuildContext context, required String docID, required int type, String? subCode, String? subName, String? email, String? id, String? name}) {
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
    case 4:
      content = "lecturer";
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
                // delete student
                case 1:
                  if (email != null) {
                    // delete student
                    await deleteStudent(context, docID, email);
                  } else {
                    print("Email is null");
                  }
                  break;
                // delete subject
                case 2:
                  if (subCode != null || subName != null) {
                    await deleteSubject(context, docID, subCode!, subName!);
                  } else {
                    print("Sub Code or Sub Name is null");
                  }
                  break;
                // delete class
                case 3:
                  await deleteClass(context, docID);
                  break;
                // delete teacher
                case 4: {
                  if (email != null && id != null && name != null) {
                    await deleteTeacher(context, docID, email, id, name);
                  } else {
                    if (email == null) {
                      print("Email is null");
                    }

                    if (id == null) {
                      print("ID is null");
                    }

                    if (name == null) {
                      print("Name is null");
                    }
                  }
                  break;
                }
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
deleteStudent(BuildContext context, String docID, String email, [List? subjectList]) async {
  AuthService auth = AuthService();
  dynamic result = await auth.deleteUser(email);

  if (result == true) {
    DatabaseService dbService = DatabaseService();
    bool studentDelete = await dbService.deleteUser(docID);

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
    } else {
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to remove this subject from lecturer.", style: TextStyle(color: Colors.red)),
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

// delete class
deleteClass(BuildContext context, String docID) async {
  DatabaseService dbService = DatabaseService();
  bool classDelete = await dbService.deleteClass(docID);

  if (classDelete) {
    Navigator.pushAndRemoveUntil(
      context, 
      MaterialPageRoute(
        builder: (context) => const Main()
      ),
     ModalRoute.withName("/Main")
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Class session deleted.", style: TextStyle(color: Colors.green)),
      )
    );
  } else {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Failed to delete class session.", style: TextStyle(color: Colors.red)),
      )
    );
  }
}

// delete teacher
deleteTeacher(BuildContext context, String docID, String email, String id, String name) async {
  AuthService auth = AuthService();
  dynamic result = await auth.deleteUser(email);

  if (result == true) {
    DatabaseService dbService = DatabaseService();
    bool deleteSubjectTeacher = await dbService.deleteSubjectTeacher(docID, id, name);
    bool teacherDelete = await dbService.deleteUser(docID);

    if (teacherDelete && deleteSubjectTeacher) {
      // pop twice
      int count = 0;
      Navigator.of(context).popUntil((_) => count++ >= 2);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lecturer successfully deleted from the system.", style: TextStyle(color: Colors.green)),
        )
      );
    } else {
      Navigator.pop(context);

      if (!teacherDelete && !deleteSubjectTeacher) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to delete lecturer and reset subject under this lecturer.", style: TextStyle(color: Colors.red)),
          )
        );
      } else {
        if (!teacherDelete) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to delete lecturer.", style: TextStyle(color: Colors.red)),
            )
          );
        }

        if (!deleteSubjectTeacher) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to reset subjects under this lecturer.", style: TextStyle(color: Colors.red)),
            )
          );
        }
      }
    }
  } else {
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Failed to delete lecturer.", style: TextStyle(color: Colors.red)),
      )
    );
  }
}