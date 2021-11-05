import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/class_data_list.dart';
import 'package:student_attendance_fyp/screens/home/class_listview.dart';

class ClassHistoryView extends StatefulWidget {
  const ClassHistoryView({Key? key}) : super(key: key);

  @override
  State<ClassHistoryView> createState() => _ClassHistoryViewState();
}

class _ClassHistoryViewState extends State<ClassHistoryView> {
  final List<ClassDataList> classList = [
    ClassHistory("Human Computer Interaction", "123", "B2", DateTime.now(), DateTime.now().add(const Duration(hours: 2)), 2),
    ClassHistory("Network Security", "BIBGE2113", "B3", DateTime.now(), DateTime.now().add(const Duration(hours: 2)), 1),
    ClassHistory("Software Engineering", "123", "B405", DateTime.now(), DateTime.now().add(const Duration(hours: 2)), 1),
    ClassHistory("IT Ethnic", "123", "A305", DateTime.now(), DateTime.now().add(const Duration(hours: 2)), 0)
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(
          itemCount: classList.length,
          itemBuilder: (BuildContext context, int index) => buildClassHistory(context, index, classList)
      ),
    );
  }
}
