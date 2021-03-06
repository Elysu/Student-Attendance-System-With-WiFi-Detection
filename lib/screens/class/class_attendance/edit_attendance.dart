import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance_fyp/screens/students/edit_student.dart';
import 'package:student_attendance_fyp/services/database.dart';

class EditAttendance extends StatefulWidget {
  const EditAttendance({ Key? key, required this.classID, required this.uid }) : super(key: key);
  
  final classID;
  final uid;

  @override
  _EditAttendanceState createState() => _EditAttendanceState();
}

class _EditAttendanceState extends State<EditAttendance> {
  DatabaseService dbService = DatabaseService();
  Map attendanceDetails = {};
  bool loading = true;
  String? strAttendanceDateTime, strAttendance;
  Timestamp? tAttendance;
  DateTime? dAttendance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAttendance().whenComplete(() {
      setState(() {
        loading = false;
        strAttendance = attendanceText(attendanceDetails["status"].toString());

        if (attendanceDetails["datetime"] != null) {
          tAttendance = attendanceDetails["datetime"];
          dAttendance = tAttendance!.toDate();
          strAttendanceDateTime = DateFormat('d/M/y').format(dAttendance!).toString() + " - " + DateFormat('jm').format(dAttendance!).toString();
        } else {
          strAttendanceDateTime = "None";
        }
      });
    });
  }

  Future getAttendance() async {
    attendanceDetails = await dbService.getAttendanceDetails(widget.classID, widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Attendance"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditStudent(docID: widget.uid))
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
              // student name
              const SizedBox(height: 20),
              const Text("Student Name:"),
              const SizedBox(height: 5),
              Text(
                attendanceDetails['name'],
                style: const TextStyle(fontSize: 20),
              ),

              // student ID
              const SizedBox(height: 30),
              const Text("Student ID:"),
              const SizedBox(height: 5),
              Text(
                attendanceDetails['id'],
                style: const TextStyle(fontSize: 20),
              ),

              // attendance datetime
              const SizedBox(height: 30),
              const Text("Attendance Date and Time:"),
              const SizedBox(height: 5),
              Text(
                strAttendanceDateTime!,
                style: const TextStyle(fontSize: 20),
              ),

              // manual attendance by teacher: YES OR NO
              const SizedBox(height: 30),
              const Text("Manual Attendance:"),
              const SizedBox(height: 5),
              Text(
                attendanceDetails['manual_status'] ? "Yes" : "No",
                style: const TextStyle(fontSize: 20),
              ),

              // attendance status
              const SizedBox(height: 30),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  label: Text("Attendance")
                ),
                value: strAttendance,
                items: <String>["PRESENT", "LATE", "N/A"].map<DropdownMenuItem<String>>((String val){
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    strAttendance = newValue!;
                  });
                },
              ),

              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    String attendance = "";

                    switch (strAttendance) {
                      case "PRESENT":
                        attendance = "present";
                        break;
                      case "LATE":
                        attendance = "late";
                        break;
                      case "N/A":
                        attendance = "n/a";
                        break;
                    }

                    bool status = await dbService.editAttendance(widget.classID, widget.uid, attendance);

                    if (status) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text("Attendance has been updated.", style: TextStyle(color: Colors.green)),
                      ));

                      getAttendance().whenComplete(() {
                        setState(() {});
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        duration: Duration(seconds: 5),
                        content: Text("Failed to save attendance, please try again.", style: TextStyle(color: Colors.red)),
                      ));
                    }
                  },
                  child: const Text("Save"),
                ),
              ),

              const SizedBox(height: 20)
            ],
          ),
        ),
      )
    );
  }

  attendanceText(String attendance) {
    String text = '';

    switch (attendance) {
      case 'present':
        text = "PRESENT";
        break;
      case 'late':
        text = "LATE";
        break;
      case 'n/a':
        text = "N/A";
        break;
    }

    return text;
  }
}