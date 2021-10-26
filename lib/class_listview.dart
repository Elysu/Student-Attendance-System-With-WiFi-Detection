import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildClassList(BuildContext context, int index, List classList) {
  final classes = classList[index];
  return ClassList_ListView(classes: classes);
}

class ClassList_ListView extends StatelessWidget {
  const ClassList_ListView({
    Key? key,
    required this.classes,
  }) : super(key: key);

  final classes;

  @override
  Widget build(BuildContext context) {
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
}

Widget buildClassHistory(BuildContext context, int index, List classList) {
  final classes = classList[index];
  return ClassHistory_ListView(classes: classes);
}

class ClassHistory_ListView extends StatelessWidget {
  const ClassHistory_ListView({
    Key? key,
    required this.classes,
  }) : super(key: key);

  final classes;

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
                    const Text("Attendance: "),
                    Text(
                      classes.attendance == 1 ? 'Present' : classes.attendance == 2 ? 'Late' : 'Absent',
                      style: TextStyle(
                        color: classes.attendance == 1 ? Colors.green : classes.attendance == 2 ? Colors.orange[700] : Colors.red
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