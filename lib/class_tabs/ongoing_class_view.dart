import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/class_data_models/ongoing_class.dart';
import 'package:intl/intl.dart';

class OngoingClassView extends StatelessWidget {
  OngoingClassView({Key? key}) : super(key: key);

  final List<OngoingClass> classList = [
    OngoingClass("Human Computer Interaction", "123", "B2", DateTime.now(), DateTime.now().add(const Duration(hours: 2))),
    OngoingClass("Network Security", "BIBGE2113", "B3", DateTime.now(), DateTime.now().add(const Duration(hours: 2))),
    OngoingClass("Software Engineering", "123", "B405", DateTime.now(), DateTime.now().add(const Duration(hours: 2))),
    OngoingClass("IT Ethnic", "123", "A305", DateTime.now(), DateTime.now().add(const Duration(hours: 2)))
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(
        itemCount: classList.length,
        itemBuilder: (BuildContext context, int index) => buildOngoingClass(context, index)
      ),
    );
  }

  Widget buildOngoingClass(BuildContext context, int index) {
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
}