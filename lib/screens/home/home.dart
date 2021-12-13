import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/class_tabs/class_history_view.dart';
import 'package:student_attendance_fyp/class_tabs/ongoing_class_view.dart';
import 'package:student_attendance_fyp/class_tabs/upcoming_class_view.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/shared/delete.dart';
import 'package:student_attendance_fyp/widgets/drawer/navigation_drawer_widget.dart';
import 'package:student_attendance_fyp/services/network_info.dart';

//this is just TabBar so stateless is fine
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var wifiBSSID;

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
          onPressed: () async {
            UserModel userModel = UserModel();
            NetInfo netInfo = NetInfo();
            var bssid = await netInfo.getBSSID();

            print("MAC ADDRESS: ${bssid}");
            print('User ID: ${userModel.getUID}');
            print('Device ID: ${userModel.getDeviceID}');
            print('Email: ${userModel.getEmail}');
            print('ID: ${userModel.getID}');
            print('Name: ${userModel.getName}');
            print('isTeacher: ${userModel.getTeacher}');
            print('Subjects: ${userModel.getSubjects}');
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.blue[500],
        ),
        body: const TabBarView(
          children: <Widget>[
            OngoingClassView(),
            UpcomingClassView(),
            ClassHistoryView()
          ],
        ),
        drawer: NavigationDrawerWidget()
      ),
    );
  }
}