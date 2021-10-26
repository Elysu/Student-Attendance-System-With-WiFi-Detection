import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/class_data_models/class_data_list.dart';
import 'package:student_attendance_fyp/class_listview.dart';

class UpcomingClassView extends StatefulWidget {
  const UpcomingClassView({Key? key}) : super(key: key);

  @override
  State<UpcomingClassView> createState() => _UpcomingClassViewState();
}

class _UpcomingClassViewState extends State<UpcomingClassView> {
  final List<ClassDataList> classList = [
    ClassDataList("Human Computer Interaction", "123", "B2", DateTime.now(), DateTime.now().add(const Duration(hours: 2))),
    ClassDataList("Network Security", "BIBGE2113", "B3", DateTime.now(), DateTime.now().add(const Duration(hours: 2))),
    ClassDataList("Software Engineering", "123", "B405", DateTime.now(), DateTime.now().add(const Duration(hours: 2))),
    ClassDataList("IT Ethnic", "123", "A305", DateTime.now(), DateTime.now().add(const Duration(hours: 2)))
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(
          itemCount: classList.length,
          itemBuilder: (BuildContext context, int index) => buildClassList(context, index, classList)
      ),
    );
  }
}