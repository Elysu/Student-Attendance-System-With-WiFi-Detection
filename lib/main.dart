import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/class_tabs/class_history_view.dart';
import 'package:student_attendance_fyp/class_tabs/ongoing_class_view.dart';
import 'package:student_attendance_fyp/class_tabs/upcoming_class_view.dart';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

//this is just TabBar so stateless is fine
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
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          child: Icon(Icons.add),
          backgroundColor: Colors.blue[500],
        ),
        body: TabBarView(
          children: <Widget>[
            OngoingClassView(),
            UpcomingClassView(),
            ClassHistoryView()
          ],
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