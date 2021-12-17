import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance_fyp/services/database.dart';
import 'package:student_attendance_fyp/shared/delete.dart';

class EditClass extends StatefulWidget {
  const EditClass({ Key? key, required this.docID}) : super(key: key);

  final docID;

  @override
  _EditClassState createState() => _EditClassState();
}

class _EditClassState extends State<EditClass> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbService = DatabaseService();
  dynamic classDetails;
  Map classTeacher = {};
  bool loading = true;
  int? attendance;
  Timestamp? tStart, tEnd; // to store timestamp from firestore
  DateTime? dStart, dEnd, newStartDateTime, newEndDateTime; // to convert time stamp to DateTime and store new selected date
  String strDate = "", strStartTime = "", strEndTime = "", classStatus = "", classroom = ""; // String that display on form
  TimeOfDay? startTime, endTime, newStartTime, newEndTime;
  List<String> allClassroom = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getClass().whenComplete(() {
      setState(() {
        classTeacher = classDetails["c_teacher"];
        loading = false;
        tStart = classDetails['c_datetimeStart'];
        tEnd = classDetails['c_datetimeEnd'];

        // set date into variables
        dStart = tStart!.toDate();
        dEnd = tEnd!.toDate();
        newStartDateTime = dStart;
        strDate = "${DateFormat('d').format(newStartDateTime!).toString()}/${DateFormat('yM').format(newStartDateTime!).toString()}";
        startTime = TimeOfDay(hour: dStart!.hour, minute: dStart!.minute);
        endTime = TimeOfDay(hour: dEnd!.hour, minute: dEnd!.minute);
        strStartTime = DateFormat('jm').format(dStart!).toString();
        strEndTime = DateFormat('jm').format(dEnd!).toString();
        classStatus = classDetails['c_ongoing'] ? "Ongoing" : "Not Available";
        classroom = classDetails['classroom'];
      });
    });

    // loop all classroom to dropdown list
    String strClassroom = "A";
    for (int i=1; i<=50; i++) {
      allClassroom.add("${strClassroom}${i}");
      if (i == 50) {
        switch (strClassroom) {
          case "A":
            strClassroom = "B";
            i = 0;
            break;
          case "B":
            strClassroom = "C";
            i = 0;
            break;
        }
      }
    }
  }

  Future getClass() async {
    classDetails = await dbService.getClassDetails(widget.docID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Details"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteDialog(context, widget.docID, 3);
            },
          )
        ],
      ),
      body: loading ? const Text("Loading...") 
      : SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Form(
            key: _formKey,
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
                  
                  // date
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Date:"),
                            const SizedBox(height: 5),
                            Text(
                              strDate,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  pickDate(context);
                                },
                                icon: const Icon(Icons.date_range),
                                label: const Text("PICK A DATE")),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),

                  // time
                  const SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      // start time
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Start Time:"),
                            const SizedBox(height: 5),
                            Text(
                              strStartTime,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                      // start time button
                      Expanded(
                        flex: 5,   
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              pickTime(context, 1);
                            },
                            icon: const Icon(Icons.access_time),
                            label: const Text("PICK A TIME")
                          ),
                        )
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  Row(
                    children: <Widget>[
                      // End time
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("End Time:"),
                            const SizedBox(height: 5),
                            Text(
                              strEndTime,
                              style: const TextStyle(fontSize: 20),
                            )
                          ],
                        ),
                      ),
                      // End time button
                      Expanded(
                        flex: 5,   
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              pickTime(context, 2);
                            },
                            icon: const Icon(Icons.share_arrival_time_outlined),
                            label: const Text("PICK A TIME")
                          ),
                        )
                      ),
                    ],
                  ),
          
                  // class status and classroom
                  const SizedBox(height: 30),
                  Row(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // classroom
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                label: Text("Select Classroom")
                              ),
                              value: classroom,
                              items: allClassroom.map<DropdownMenuItem<String>>((String val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),  
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  classroom = newValue!;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // class status
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                label: Text("Status")
                              ),
                              value: classStatus,
                              items: <String>["Ongoing", "Not Available"].map<DropdownMenuItem<String>>((String val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),  
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  classStatus = newValue!;
                                });
                              },
                            )
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

                  // save button
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        newStartDateTime

                        print(newStartDateTime);
                      },
                      child: const Text("Save"),
                    ),
                  )
                ]),
          ),
        ),
      ),
    );
  }

  // functions to show date and time picker
  Future pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: newStartDateTime ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate == null) return;

    setState(() {
      newStartDateTime = newDate;
      strDate = "${DateFormat('d').format(newStartDateTime!).toString()}/${DateFormat('yM').format(newStartDateTime!).toString()}";
    });
  }

  // 1 = start time , 2 = end time
  Future pickTime(BuildContext context, int type) async {
    final initialTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    TimeOfDay? newTime;
    var dateFormat = DateFormat("h:mm a"); // convert to 12 hours format

    switch (type) {
      case 1: {
        newTime = await showTimePicker(
          context: context,
          initialTime: newStartTime ?? startTime!
        );

        if (newTime == null) return;

        setState(() {
          newStartTime = newTime;
          //newStartDateTime.hour(newStartTime.hour);
          DateTime tempDate = DateFormat("hh:mm").parse(newStartTime!.hour.toString() + ":" + newStartTime!.minute.toString());
          strStartTime = dateFormat.format(tempDate);
        });
        break;
      }
      case 2: {
        newTime = await showTimePicker(
          context: context,
          initialTime: newEndTime ?? endTime!
        );

        if (newTime == null) return;

        setState(() {
          newEndTime = newTime;
          DateTime tempDate = DateFormat("hh:mm").parse(newEndTime!.hour.toString() + ":" + newEndTime!.minute.toString());
          strEndTime = dateFormat.format(tempDate);
        });
        break;
      }
    }

    if (newTime == null) return;
  }
}