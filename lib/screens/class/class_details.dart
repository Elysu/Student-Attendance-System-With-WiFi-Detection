import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/class/class_attendance/class_attendance.dart';
import 'package:student_attendance_fyp/screens/class/edit_class.dart';
import 'package:student_attendance_fyp/services/database.dart';

class ClassDetails extends StatefulWidget {
  const ClassDetails({ Key? key, required this.docID }) : super(key: key);

  final docID;

  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  DatabaseService dbService = DatabaseService();
  bool isTeacher = UserModel().getTeacher;
  dynamic classDetails;
  Map classTeacher = {};
  bool loading = true;
  int? attendance, totalAttendance, totalStudent;
  String attendanceText = "", attendanceLabel = "", strTotalAttendance = "";
  Color? attendanceColor;
  Timestamp? tStart;
  Timestamp? tEnd;
  DateTime? dStart;
  DateTime? dEnd;
  String classStatus = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getClass().whenComplete(() {
      getTotalAttendance(classDetails["c_sub-code"], classDetails["c_sub-name"], widget.docID).whenComplete(() {
        setState(() {
          classTeacher = classDetails["c_teacher"];
          loading = false;
          tStart = classDetails['c_datetimeStart'];
          tEnd = classDetails['c_datetimeEnd'];
          dStart = tStart!.toDate();
          dEnd = tEnd!.toDate();
          classStatus = classDetails['c_ongoing'] ? "Ongoing" : "Not Available";
          
          switch (attendance) {
            case 0:
              attendanceText = "ABSENT";
              attendanceColor = Colors.red;
              break;
            case 1:
              attendanceText = "PRESENT";
              attendanceColor = Colors.green;
              break;
            case 2:
              attendanceText = "LATE";
              attendanceColor = Colors.orange;
              break;
          }
        });
      });
    });
  }

  Future getTotalAttendance(String subCode, String subName, String classID) async {
    totalStudent = await dbService.getTotalStudentsForSubject(subCode, subName);
    totalAttendance = await dbService.getTotalAttendance(classID);
  }

  Future getClass() async {
    classDetails = await dbService.getClassDetails(widget.docID);
    attendance = await dbService.getClassAttendance(UserModel().getUID, widget.docID);
  }

  @override
  Widget build(BuildContext context) {
    if (isTeacher) {
      attendanceLabel = "Total attendance:";
      attendanceColor = Colors.black;
      strTotalAttendance = totalAttendance.toString() + "/" + totalStudent.toString();
    } else {
      attendanceLabel = "Your attendance:";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.people_alt),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClassAttendance(classDocID: widget.docID))
              );
            },
          )
        ],
      ),
      body: loading ? const Text("Loading...") 
      : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // class name
                const SizedBox(height: 20),
                const Text("Class:"),
                const SizedBox(height: 5),
                Text(
                  classDetails["c_sub-name"],
                  style: const TextStyle(fontSize: 20),
                ),
      
                // class subject code
                const SizedBox(height: 30),
                const Text("Subject Code:"),
                const SizedBox(height: 5),
                Text(
                  classDetails["c_sub-code"],
                  style: const TextStyle(fontSize: 20),
                ),
      
                // class datetime
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // date
                          const SizedBox(height: 30),
                          const Text("Date:"),
                          const SizedBox(height: 5),
                          Text(
                            "${DateFormat('d').format(dStart!).toString()}/${DateFormat('yM').format(dStart!).toString()}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // time
                          const SizedBox(height: 30),
                          const Text("Time:"),
                          const SizedBox(height: 5),
                          Text(
                            "${DateFormat('jm').format(dStart!).toString()} - ${DateFormat('jm').format(dEnd!).toString()}",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      
                // class status and classroom
                const SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // classroom
                          const Text("Classroom:"),
                          const SizedBox(height: 5),
                          Text(
                            classDetails["classroom"],
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // class status
                          const Text("Class Status:"),
                          const SizedBox(height: 5),
                          Text(
                            classStatus,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
      
                // class teacher
                const SizedBox(height: 30),
                const Text("Lecturer:"),
                const SizedBox(height: 5),
                Text(
                  classTeacher["t_name"],
                  style: const TextStyle(fontSize: 20),
                ),
      
                // class attendance
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(attendanceLabel),
                          const SizedBox(height: 5),
                          Text(
                            isTeacher ? strTotalAttendance : attendanceText,
                            style: TextStyle(fontSize: 20, color: attendanceColor),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isTeacher ? false : true,
                      child: Expanded(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.note_alt),
                                  label: const Text("Mark Attendance")),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
        ),
      ),
      floatingActionButton: Visibility(
        visible: isTeacher,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EditClass(docID: widget.docID))
            ).then((value) {
              didChangeDependencies();
            });
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}
