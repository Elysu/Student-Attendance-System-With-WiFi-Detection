import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/class/class_attendance/class_attendance.dart';
import 'package:student_attendance_fyp/screens/class/edit_class.dart';
import 'package:student_attendance_fyp/services/database.dart';
import 'package:permission_handler/permission_handler.dart';

class ClassDetails extends StatefulWidget {
  const ClassDetails({ Key? key, required this.docID }) : super(key: key);

  final docID;

  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService dbService = DatabaseService();
  bool isTeacher = UserModel().getTeacher, loading = true;
  bool? manualStatus;
  dynamic classDetails;
  Map classTeacher = {};
  int? attendance, totalAttendance, totalStudent;
  String attendanceText = "", attendanceLabel = "", strTotalAttendance = "", strOngoingTime = "";
  Color? attendanceColor;
  Timestamp? tStart, tEnd, tOngoingTime;
  DateTime? dStart, dEnd, dOngoingTime;
  String classStatus = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getClass().whenComplete(() {
      getTotalAttendance(widget.docID).whenComplete(() {
        setState(() {
          classTeacher = classDetails["c_teacher"];
          loading = false;
          tStart = classDetails['c_datetimeStart'];
          tEnd = classDetails['c_datetimeEnd'];
          dStart = tStart!.toDate();
          dEnd = tEnd!.toDate();
          classStatus = classDetails['c_ongoing'] ? "Ongoing" : "Not Available";

          if (classDetails["c_ongoingTime"] != null) {
            tOngoingTime = classDetails["c_ongoingTime"];
            dOngoingTime = tOngoingTime!.toDate();
            strOngoingTime = DateFormat('d/M/y').format(dOngoingTime!).toString() + " - " + DateFormat('jm').format(dOngoingTime!).toString();
          } else {
            strOngoingTime = "Not Available";
          }
          
          if (isTeacher) {
            attendanceLabel = "Total attendance:";
          } else {
            attendanceLabel = "Your attendance:";
            switch (attendance) {
              case 0: {
                attendanceText = "N/A";
                attendanceColor = Colors.grey;

                // if (classDetails['c_ongoing']) {
                //   attendanceText = "N/A";
                //   attendanceColor = Colors.grey;
                // } else {
                //   attendanceText = "ABSENT";
                //   attendanceColor = Colors.red;
                // }
                break;
              }
              case 1:
                attendanceText = "PRESENT";
                attendanceColor = Colors.green;
                break;
              case 2:
                attendanceText = "LATE";
                attendanceColor = Colors.orange;
                break;
            }
          }
        });
      });
    });
  }

  Future getTotalAttendance(String classID) async {
    strTotalAttendance = await dbService.getTotalAttendance(classID);
  }

  Future getClass() async {
    classDetails = await dbService.getClassDetails(widget.docID);

    if (!isTeacher) {
      attendance = await dbService.futureGetAttendance(widget.docID);
      manualStatus = await dbService.getManualAttendance(widget.docID);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              ).then((value) {
                didChangeDependencies();
              });
            },
          )
        ],
      ),
      body: loading ? const Center(child: Text("Loading...")) 
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

                // class ongoing time
                const SizedBox(height: 30),
                const Text("Ongoing Time:"),
                const SizedBox(height: 5),
                Text(
                  strOngoingTime,
                  style: const TextStyle(fontSize: 20),
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
                    checkClassOngoing()
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

  checkClassOngoing() {
    if (classDetails["c_ongoing"]) {
      if (attendance == 0 && manualStatus == false) {
        return Visibility(
          visible: isTeacher ? false : true,
          child: Expanded(
            flex: 5,
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await checkDeviceID();
                    },
                    icon: const Icon(Icons.note_alt),
                    label: const Text("Mark Attendance")
                  ),
                )
              ],
            ),
          ),
        );
      }
    }
    return const SizedBox.shrink();
  }

  checkDeviceID() async {
    // check current deviceID and last attendance deviceID
    Map currentUserData = await dbService.getUserData();
    var deviceData = await dbService.getDeviceData(currentUserData['current_deviceID']);

    // no last device ID means the signed in device is the first device for attendance
    // check if last device is null or is the same as current device
    if (currentUserData["last_deviceID"] == null || currentUserData["last_deviceID"] == currentUserData["current_deviceID"]) {
      if (deviceData == 0) {
        // if there's no document with this deviceID in devices collection, then straight away take attendance as this is the new device on the db
        takeAttendance(currentUserData["id"], currentUserData["name"]);
      } else {
        final uid = await _auth.currentUser!.uid;
        Map lastAttendance = deviceData["last_attendance"];

        if (lastAttendance["uid"] == uid) { // if last attendance uid is the same with currently signed in UID, then user can take attendance right away
          takeAttendance(currentUserData["id"], currentUserData["name"]);
        } else { // if last attendance uid is not the same as current UID
          Timestamp tLastAttendance = lastAttendance["datetime"];
          DateTime dLastAttendance = tLastAttendance.toDate();

          // check if last attendance taken with this device has passed 15
          if (DateTime.now().isAfter(dLastAttendance.add(const Duration(minutes: 15)))) { // passed 15 minutes, so can take attendance
            takeAttendance(currentUserData["id"], currentUserData["name"]);
          } else {
            // 15 minutes haven't passed yet, so user cannot take attendance unless they log in to the account with the same UID as last_attendance UID
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              duration: Duration(seconds: 5),
              content: Text(
                "This device is used to take attendance on another account not more than 15 minutes. You cannot take attendance now unless it is after 15 minutes or currently signed-in account is the same as previous attendance taken with this device.",
                style: TextStyle(color: Colors.red)
              ),
            ));
          }
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 5),
        content: Text(
          "Please take attendance with the device that is used for your previous attendance or ask your lecturer to reset the device owner.",
          style: TextStyle(color: Colors.red)
        ),
      ));
    }
  }

  takeAttendance(String id, String name) async {
    String dbAttendance = "";

    if (DateTime.now().isAfter(dOngoingTime!.add(const Duration(minutes: 15)))) {
      dbAttendance = "late";
    } else {
      dbAttendance = "present";
    }

    bool status = await dbService.takeAttendance(widget.docID, dbAttendance, id, name);

    if (status) {
      didChangeDependencies();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: Text("Your attendance is " + dbAttendance.toUpperCase() + ".", style: const TextStyle(color: Colors.green)),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Failed to take attendace, please try again.", style: TextStyle(color: Colors.red)),
      ));
    }
  }
}
