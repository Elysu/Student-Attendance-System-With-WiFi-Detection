import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildClassList(BuildContext context, int index, List classList) {
  final classes = classList[index];
  return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text(classes.courseName, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text(classes.courseCode),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text("Time: ${DateFormat('jm').format(classes.startDate).toString()} - ${DateFormat('jm').format(classes.endDate).toString()}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text("Classroom: ${classes.classroom}"),
                ],
              ),
            ),
          ],
        ),
      )
  );
}
Widget buildClassHistory(BuildContext context, int index, List classList) {
  final classes = classList[index];
  return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text(classes.courseName, style: TextStyle(fontSize: 20)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text(classes.courseCode),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text("Time: ${DateFormat('jm').format(classes.startDate).toString()} - ${DateFormat('jm').format(classes.endDate).toString()}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text("Classroom: ${classes.classroom}"),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text("Attendance: ${classes.attendance ? 'present' : 'absent'}"),
                ],
              ),
            ),
          ],
        ),
      )
  );
}