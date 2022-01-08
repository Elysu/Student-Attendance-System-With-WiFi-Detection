import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/class_tabs/class_history_view.dart';
import 'package:student_attendance_fyp/class_tabs/ongoing_class_view.dart';
import 'package:student_attendance_fyp/screens/class/create_class.dart';
import 'package:student_attendance_fyp/services/database.dart';
import 'package:student_attendance_fyp/services/network_info.dart';
import 'package:student_attendance_fyp/widgets/drawer/navigation_drawer_widget.dart';

//this is just TabBar so stateless is fine
class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DatabaseService dbService = DatabaseService();
  var wifiBSSID;
  bool isTeacher = false;
  Map userData = {};
  //bool isTeacher = UserModel().getTeacher;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTeacher().whenComplete(() {
      setState(() {
        if (userData["isTeacher"]) {
          isTeacher = true;
        }
      });
    });
  }

  Future getTeacher() async {
    userData = await dbService.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Student Attendance System"),
          centerTitle: true,
          bottom: const TabBar(
            tabs: <Widget>[
              Tab(child: Text("Classes")),
              Tab(child: Text("Class History")),
            ],
          ),
        ),
        floatingActionButton: Visibility(
          visible: isTeacher,
          child: FloatingActionButton(
            onPressed: () async {
              NetInfo netInfo = NetInfo();
              await netInfo.getBSSID();

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CreateClass())
              );
            },
            child: const Icon(Icons.add),
            backgroundColor: Colors.blue[500],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[
            OngoingClassView(),
            ClassHistoryView()
          ],
        ),
        drawer: NavigationDrawerWidget()
      ),
    );
  }
}