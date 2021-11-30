import 'package:cloud_firestore/cloud_firestore.dart';

class ClassDataList {
  final String courseName;
  final String courseCode;
  final String classroom;
  final Timestamp startDate;
  final Timestamp endDate;

  ClassDataList(this.courseName, this.courseCode, this.classroom, this.startDate, this.endDate);
}

class ClassHistory extends ClassDataList {
  final int attendance; // 0 = absent, 1 = present, 2 = late
  ClassHistory(String courseName, String courseCode, String classroom, Timestamp startDate, Timestamp endDate, this.attendance) : super(courseName, courseCode, classroom, startDate, endDate);
}