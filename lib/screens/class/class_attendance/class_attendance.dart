import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/database.dart';

class ClassAttendance extends StatefulWidget {
  const ClassAttendance({ Key? key, required this.classDocID }) : super(key: key);

  final classDocID;

  @override
  _ClassAttendanceState createState() => _ClassAttendanceState();
}

class _ClassAttendanceState extends State<ClassAttendance> {
  DatabaseService dbService = DatabaseService();
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Attendance"),
        centerTitle: true,
      ),
      // body: loading ? const Text("Loading...")
      // : SingleChildScrollView(
      //   child: ListView.separated(
      //     scrollDirection: Axis.vertical,
      //     shrinkWrap: true,
      //     itemCount: subjects.length,
      //     itemBuilder: (BuildContext context, int index) {
      //       return ListTile(
      //         title: Text(subjects[index]["sub_name"]),
      //         subtitle: Text(subjects[index]["sub_code"]),
      //         onTap: () {
                
      //         },
      //       );
      //     },
      //     separatorBuilder: (context, index) {
      //       return const Divider(
      //         height: 0,
      //         color: Colors.black38,
      //       );
      //     },
      //   ),
      // )
    );
  }
}