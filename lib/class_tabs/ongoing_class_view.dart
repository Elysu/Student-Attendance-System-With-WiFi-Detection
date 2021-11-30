import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/class_data_list.dart';
import 'package:student_attendance_fyp/screens/home/class_listview.dart';

class OngoingClassView extends StatefulWidget {
  const OngoingClassView({Key? key}) : super(key: key);

  @override
  State<OngoingClassView> createState() => _OngoingClassViewState();
}

class _OngoingClassViewState extends State<OngoingClassView> {
  final List<ClassDataList> classList = [
    ClassDataList("Human Computer Interaction", "123", "B2", Timestamp.now(), Timestamp.now()),
    ClassDataList("Network Security", "BIBGE2113", "B3", Timestamp.now(), Timestamp.now()),
    ClassDataList("Software Engineering", "123", "B405", Timestamp.now(), Timestamp.now()),
    ClassDataList("IT Ethnic", "123", "A305", Timestamp.now(), Timestamp.now())
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(
        itemCount: classList.length,
        itemBuilder: (BuildContext context, int index) => buildClassList(context, index, classList)
      ),
    );
  }
}