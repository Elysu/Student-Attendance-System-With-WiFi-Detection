import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/class_data_models/ongoing_class_model.dart';
import 'package:intl/intl.dart';

class OngoingClass extends StatelessWidget {
  OngoingClass({Key? key}) : super(key: key);

  final List<OngoingClassModel> classList = [
    OngoingClassModel("Human Computer Interaction", "123", DateTime.now(), DateTime.now()),
    OngoingClassModel("Network Security", "123", DateTime.now(), DateTime.now()),
    OngoingClassModel("Software Engineering", "123", DateTime.now(), DateTime.now()),
    OngoingClassModel("IT Ethnic", "123", DateTime.now(), DateTime.now())
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
        child: Column(
          children: <Widget>[
            Text(index.toString()),
            Text(classes.courseName),
            Text(classes.courseCode),
            Text(DateFormat('jm').format(classes.startDate).toString()),
            Text(DateFormat('jm').format(classes.endDate).toString()),
          ],
        )
    );
  }
}