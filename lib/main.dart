import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/class_tabs/class_history.dart';
import 'package:student_attendance_fyp/class_tabs/ongoing_class.dart';
import 'package:student_attendance_fyp/class_tabs/upcoming_class.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Attendance System"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(child: Text("Ongoing Classes")),
              Tab(child: Text("Upcoming Classes")),
              Tab(child: Text("Class History")),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            OngoingClass(),
            UpcomingClass(),
            ClassHistory()
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Text("YOLO"),
        ),
        drawer: Drawer(
          child: Center(
            child: Text("yo"),
          ),
        ),
      ),
    );
  }
}