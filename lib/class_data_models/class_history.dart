import 'package:student_attendance_fyp/class_data_models/class_data_list.dart';

class ClassHistory extends ClassDataList {
  final bool attendance;
  ClassHistory(String courseName, String courseCode, String classroom, DateTime startDate, DateTime endDate, this.attendance) : super(courseName, courseCode, classroom, startDate, endDate);
}