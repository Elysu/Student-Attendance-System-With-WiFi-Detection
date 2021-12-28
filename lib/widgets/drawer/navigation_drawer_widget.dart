import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/students/student_list.dart';
import 'package:student_attendance_fyp/screens/subjects/all_subjects.dart';
import 'package:student_attendance_fyp/screens/subjects/selected_subjects.dart';
import 'package:student_attendance_fyp/screens/teacher/all_teachers.dart';
import 'package:student_attendance_fyp/services/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
          buildMenuItem(context, text: "My Subjects", icon: Icons.book),
          isTeacher(context),
          buildMenuItem(context, text: "Logout", icon: Icons.logout),
        ],
      ),
    );
  }

  Widget isTeacher(BuildContext context) {
    if (UserModel().getTeacher) {
      return Column(
        children: <Widget>[
          buildMenuItem(context, text: "All Subjects", icon: Icons.menu_book),
          buildMenuItem(context, text: "All Students", icon: Icons.person),
          buildMenuItem(context, text: "All Teachers", icon: FontAwesomeIcons.chalkboardTeacher),
        ],
      );
    } else {
      return Container();
    }
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
          case "All Students":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StudentList())
            );
            break;
          case "My Subjects":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelectedSubjects())
            );
            break;
          case "All Subjects":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllSubjects())
            );
            break;
          case "All Teachers":
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AllTeachers())
            );
            break;
        }
      },
    );
  }
}