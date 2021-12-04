import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildClassList(BuildContext context, int index, List<dynamic> classList) {
  final classes = classList[index];
  return ClassList_ListView(classes: classes);
}

class ClassList_ListView extends StatefulWidget {
  const ClassList_ListView({
    Key? key,
    required this.classes,
  }) : super(key: key);

  final classes;

  @override
  State<ClassList_ListView> createState() => _ClassList_ListViewState();
}

class _ClassList_ListViewState extends State<ClassList_ListView> {
  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(widget.classes.courseName, style: const TextStyle(fontSize: 20))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(widget.classes.courseCode),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Time: ${DateFormat('jm').format(widget.classes.startDate).toString()} - ${DateFormat('jm').format(widget.classes.endDate).toString()}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Classroom: ${widget.classes.classroom}"),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

Widget buildClassHistory(BuildContext context, DocumentSnapshot classes, String docID, dynamic attendance) {
  print("checkAttendance XDXDXD: $attendance");
  return ClassListHistory_ListView(classes: classes, docID: docID, attendance: attendance);
}

class ClassListHistory_ListView extends StatefulWidget {
  const ClassListHistory_ListView({ Key? key, required this.classes, required this.docID, required this.attendance }) : super(key: key);
  final classes;
  final docID;
  final attendance;

  @override
  _ClassListHistory_ListViewState createState() => _ClassListHistory_ListViewState();
}

class _ClassListHistory_ListViewState extends State<ClassListHistory_ListView> {
  @override
  Widget build(BuildContext context) {
    Timestamp tStart = widget.classes['c_datetimeStart'];
    Timestamp tEnd = widget.classes['c_datetimeEnd'];
    DateTime dStart = tStart.toDate();
    DateTime dEnd = tEnd.toDate();

    return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(widget.classes['c_sub-name'], style: const TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(widget.classes['c_sub-code']),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Time: ${DateFormat('jm').format(dStart).toString()} - ${DateFormat('jm').format(dEnd).toString()}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text("Classroom: ${widget.classes['classroom']}"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    const Text("Attendance: "),
                    Text(
                      widget.attendance == 1 ? 'PRESENT' : widget.attendance == 2 ? 'LATE' : 'ABSENT',
                      style: TextStyle(
                        color: widget.attendance == 1 ? Colors.green : widget.attendance == 2 ? Colors.orange[700] : Colors.red
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

// Future<int> checkAttendance(String docID) async {
//   print("The attendance is ${await DatabaseService().attendanceExists(UserModel().getUID, docID)}");
//   int attendance = await DatabaseService().attendanceExists(UserModel().getUID, docID);
//   return attendance;
// }