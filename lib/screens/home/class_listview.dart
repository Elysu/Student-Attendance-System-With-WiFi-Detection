import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance_fyp/models/user_model.dart';

Widget buildClassList(BuildContext context, DocumentSnapshot classes, [dynamic attendance]) {
  return ClassList_ListView(classes: classes, attendance: attendance);
}

class ClassList_ListView extends StatefulWidget {
  const ClassList_ListView({ Key? key, required this.classes, this.attendance }) : super(key: key);

  final classes;
  final attendance;

  @override
  _ClassList_ListViewState createState() => _ClassList_ListViewState();
}

class _ClassList_ListViewState extends State<ClassList_ListView> {
  @override
  Widget build(BuildContext context) {
    Timestamp tStart = widget.classes['c_datetimeStart'];
    Timestamp tEnd = widget.classes['c_datetimeEnd'];
    DateTime dStart = tStart.toDate();
    DateTime dEnd = tEnd.toDate();

    Widget checkUpcomingOrOngoing() {
      if (widget.attendance != null) {
        String attendance = "";
        Color? attendanceColor;

        switch (widget.attendance) {
          case 0:
            attendance = "N/A";
            attendanceColor = Colors.grey;
            break;
          case 1:
            attendance = "PRESENT";
            attendanceColor = Colors.green;
            break;
          case 2:
            attendance = "LATE";
            attendanceColor = Colors.orange;
            break;
        }

        return Padding(
                  padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  child: Row(
                    children: <Widget>[
                      const Text("Attendance: "),
                      Text(
                        attendance,
                        style: TextStyle(color: attendanceColor),
                      ),
                    ],
                  ),
                );
      } else {
        return const SizedBox.shrink();
      }
    }

    return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    Text(widget.classes['c_sub-name'], style: const TextStyle(fontSize: 20))
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
                    Text("Date: ${DateFormat('d/M/y').format(dStart).toString()}"),
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
              checkUpcomingOrOngoing()
            ],
          ),
        )
    );
  }
}

Widget buildClassHistory(BuildContext context, DocumentSnapshot classes, [dynamic attendance]) {
  return ClassListHistory_ListView(classes: classes, attendance: attendance);
}

class ClassListHistory_ListView extends StatefulWidget {
  const ClassListHistory_ListView({ Key? key, required this.classes, this.attendance }) : super(key: key);
  final classes;
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
                    Text("Date: ${DateFormat('d/M/y').format(dStart).toString()}"),
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
              isTeacherOrStudent()
            ],
          ),
        )
    );
  }

  Widget isTeacherOrStudent() {
    String attendance = "";
    Color? attendanceColor;

    if (widget.attendance != null) {
      switch (widget.attendance) {
        case 0:
          attendance = "ABSENT";
          attendanceColor = Colors.red;
          break;
        case 1:
          attendance = "PRESENT";
          attendanceColor = Colors.green;
          break;
        case 2:
          attendance = "LATE";
          attendanceColor = Colors.orange;
          break;
      }

      return Padding(
                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                child: Row(
                  children: <Widget>[
                    const Text("Attendance: "),
                    Text(
                      attendance,
                      style: TextStyle(color: attendanceColor),
                    ),
                  ],
                ),
              );
    } else {
      return const SizedBox.shrink();
    }
  }
}