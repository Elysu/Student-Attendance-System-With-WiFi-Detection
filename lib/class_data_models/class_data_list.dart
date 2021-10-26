class ClassDataList {
  final String courseName;
  final String courseCode;
  final String classroom;
  final DateTime startDate;
  final DateTime endDate;

  ClassDataList(this.courseName, this.courseCode, this.classroom, this.startDate, this.endDate);
}

class ClassHistory extends ClassDataList {
  final bool attendance;
  ClassHistory(String courseName, String courseCode, String classroom, DateTime startDate, DateTime endDate, this.attendance) : super(courseName, courseCode, classroom, startDate, endDate);
}