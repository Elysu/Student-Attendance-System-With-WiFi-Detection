import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/add_student/student_list.dart';
import 'package:student_attendance_fyp/screens/subjects/selected_subjects.dart';
import 'package:student_attendance_fyp/services/auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({ Key? key }) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue[500]
            ),
            child: Text(UserModel().getName, style: const TextStyle(color: Colors.white)),
          ),
          buildMenuItem(context, text: "Class Subjects", icon: Icons.book),
          isTeacher(context),
          buildMenuItem(context, text: "Logout", icon: Icons.logout),
        ],
      ),
    );
  }

  Widget isTeacher(BuildContext context) {
    if (UserModel().getTeacher) {
      return buildMenuItem(context, text: "Student List", icon: Icons.person);
    }
    return Container();
  }

  Widget buildMenuItem(BuildContext context, { required String text, required IconData icon }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () async {
        switch (text) {
          case "Logout":
            await _auth.userSignOut();
            break;
          case "Student List":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentList())
            );
            break;
          case "Class Subjects":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelectedSubjects())
            );
            break;
        }
      },
    );
  }
}