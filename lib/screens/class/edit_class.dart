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
  Map classDetails = {};
  Map classTeacher = {};
  bool loading = true;
  bool? classOngoing;
  Timestamp? tStart, tEnd, tOngoingTime; // to store timestamp from firestore
  DateTime? dStart, dEnd, dOngoingTime; // to convert time stamp to DateTime and store new selected date
  String strDate = "", strStartTime = "", strEndTime = "", strClassStatus = "", classroom = "", startTimePeriod = "", endTimePeriod = "", strOngoingTime = "", error = ""; // String that display on form
  TimeOfDay? startTime, endTime;
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
        dStart = tStart!.toDate();
        dEnd = tEnd!.toDate();
        
        // set date into variables
        strDate = "${DateFormat('d').format(dStart!).toString()}/${DateFormat('yM').format(dStart!).toString()}";
        startTime = TimeOfDay(hour: dStart!.hour, minute: dStart!.minute);
        endTime = TimeOfDay(hour: dEnd!.hour, minute: dEnd!.minute);
        startTimePeriod = startTime!.period == DayPeriod.am ? "AM" : "PM";
        endTimePeriod = endTime!.period == DayPeriod.am ? "AM" : "PM";
        strStartTime = DateFormat("h:mm").format(dStart!).toString() + " " + startTimePeriod;
        strEndTime = DateFormat("h:mm").format(dEnd!).toString() + " " + endTimePeriod;
        classOngoing = classDetails['c_ongoing'];
        strClassStatus = classOngoing! ? "Ongoing" : "Not Available";
        classroom = classDetails['classroom'];
      });
    });

    // loop all classroom to dropdown list
    String strClassroom = "A";
    for (int i=1; i<=50; i++) {
      allClassroom.add(strClassroom + "" + i.toString());
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
    if (classDetails["c_ongoingTime"] != null) {
      tOngoingTime = classDetails["c_ongoingTime"];
      dOngoingTime = tOngoingTime!.toDate();
      strOngoingTime = DateFormat('d/M/y').format(dOngoingTime!).toString() + " - " + DateFormat('jm').format(dOngoingTime!).toString();
    } else {
      strOngoingTime = "Not Available";
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Class"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              deleteDialog(context: context, docID: widget.docID, type: 3);
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
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // classroom
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                label: Text("Classroom")
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
                      const Expanded(flex: 1, child: SizedBox.shrink()),
                      Expanded(
                        flex: 6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // class status
                            DropdownButtonFormField(
                              decoration: const InputDecoration(
                                label: Text("Status")
                              ),
                              value: strClassStatus,
                              items: <String>["Ongoing", "Not Available"].map<DropdownMenuItem<String>>((String val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),  
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  strClassStatus = newValue!;
                                });
                              },
                            )
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

                  // save button
                  const SizedBox(height: 50),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        dStart = updateTime(startTime!);
                        dEnd = updateTime(endTime!);
                        
                        // validation
                        if (dEnd!.isBefore(dStart!)) {
                          setState(() {
                            error = "End time cannot be earlier than start time.";
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 5),
                                content: Text(error, style: const TextStyle(color: Colors.red)),
                              )
                            );
                          });
                        } else {
                          classOngoing = strClassStatus == "Ongoing" ? true : false;
                          dynamic reset;

                          if (classOngoing!) {
                            if (classDetails["c_ongoingTime"] != null) {
                              reset = await ongoingTimeDialog();

                              if (reset == true) {
                                updateClass(DateTime.now());
                              } else if (reset == false) {
                                updateClass(0); // 0 for keeping the ongoing time
                              }
                            } else {
                              updateClass(DateTime.now());
                            }
                          } else {
                            updateClass(null);
                          }
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ),

                  const SizedBox(height: 20),
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
      initialDate: dStart ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );

    if (newDate != null) {
      setState(() {
        dStart = newDate;
        strDate = "${DateFormat('d').format(dStart!).toString()}/${DateFormat('yM').format(dStart!).toString()}";
      });
    }
  }

  // 1 = start time , 2 = end time
  Future pickTime(BuildContext context, int type) async {
    final initialTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    TimeOfDay? newTime;

    switch (type) {
      case 1: {
        newTime = await showTimePicker(
          context: context,
          initialTime: startTime ?? initialTime
        );

        if (newTime != null) {
          setState(() {
            startTime = newTime;
            String timePeriod = startTime!.period == DayPeriod.am ? "AM" : "PM";
            DateTime tempDate = DateFormat("hh:mm").parse(startTime!.hour.toString() + ":" + startTime!.minute.toString());
            strStartTime = DateFormat('h:mm').format(tempDate).toString() + " " + timePeriod;
          });
        }
        break;
      }
      case 2: {
        newTime = await showTimePicker(
          context: context,
          initialTime: endTime ?? initialTime
        );

        if (newTime != null) {
          setState(() {
            endTime = newTime;
            String timePeriod = endTime!.period == DayPeriod.am ? "AM" : "PM";
            DateTime tempDate = DateFormat("hh:mm").parse(endTime!.hour.toString() + ":" + endTime!.minute.toString());
            strEndTime = DateFormat('h:mm').format(tempDate).toString() + " " + timePeriod;
          });
        }
        break;
      }
    }
  }

  DateTime updateTime(TimeOfDay time) {
    return DateTime(
      dStart!.year,
      dStart!.month,
      dStart!.day,
      time.hour,
      time.minute
    );
  }

  void updateClass([dynamic ongoingTime]) async {
    bool status = await dbService.updateClassDetails(widget.docID, dStart!, dEnd!, classroom, classOngoing!, ongoingTime);

    if (status) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Class details has been updated.", style: TextStyle(color: Colors.green)),
      ));
    } else {
      error = "Failed to update class details.";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 5),
        content: Text(error, style: const TextStyle(color: Colors.red)),
      ));
    }
  }

  ongoingTimeDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Reset ongoing start time?"),
          content: const Text("An ongoing start time has already been set, do you want to reset to current time?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 0); // just dummy value to return instead of null
              },
              child: const Text("CANCEL")
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text("NO")
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text("YES")
            ),
          ],
        );
      }
    );
  }
}