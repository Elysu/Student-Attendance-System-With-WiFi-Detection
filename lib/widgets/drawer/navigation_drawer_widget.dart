import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/services/auth.dart';

class NavigationDrawerWidget extends StatelessWidget {
  NavigationDrawerWidget({ Key? key }) : super(key: key);

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[500]
              ),
              child: Text(UserModel().getName, style: const TextStyle(color: Colors.white)),
            ),
            buildMenuItem(text: "Logout", icon: Icons.logout),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({ required String text, required IconData icon }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(text),
      onTap: () async {
        await _auth.userSignOut();
      },
    );
  }
}