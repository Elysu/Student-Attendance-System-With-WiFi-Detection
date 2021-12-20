import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance_fyp/screens/class/select_subject.dart';
import 'package:student_attendance_fyp/services/database.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({ Key? key }) : super(key: key);

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbService = DatabaseService();
  Map classSubject = {}, subTeacher = {};
  String subName = "", subCode = "", subTeacherName = "", strDate = "None", strStartTime = "None", strEndTime = "None";
  String? classroom, strClassStatus;
  List<String> allClassroom = [];
  DateTime? dStart, dEnd;
  TimeOfDay? startTime, endTime;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    if (classSubject.isEmpty) {
      subName = "No subject selected";
      subCode = "None";
      subTeacherName = "None";
    } else {
      subName = classSubject["sub_name"];
      subCode = classSubject["sub_code"];
      subTeacher = classSubject["sub_teacher"];
      subTeacherName = subTeacher["t_name"];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Class Session"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // class subject name
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Expanded(
                      flex: 5,
                      child: Text("Class Subject:")
                    ),
                    Expanded(
                      flex: 5,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _navigateSelectTeacher(context);
                        },
                        icon: const Icon(Icons.book),
                        label: const Text("Select Subject")
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  subName,
                  style: const TextStyle(fontSize: 20)
                ),

                // class subject code
                const SizedBox(height: 30),
                const Text("Subject Code:"),
                const SizedBox(height: 5),
                Text(
                  subCode,
                  style: const TextStyle(fontSize: 20)
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

                // start time
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

                // end time
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
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // classroom
                          DropdownButtonFormField(
                            validator: (value) => value == null ? 'Select a classroom.' : null,
                            decoration: const InputDecoration(label: Text("Select Classroom")),
                            value: classroom,
                            items: allClassroom
                                .map<DropdownMenuItem<String>>((String val) {
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
                            validator: (value) => value == null ? 'Select class status.' : null,
                            decoration: const InputDecoration(label: Text("Status")),
                            value: strClassStatus,
                            items: <String>["Ongoing", "Not Available"]
                                .map<DropdownMenuItem<String>>((String val) {
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

                // class teacher
                const SizedBox(height: 30),
                const Text("Lecturer:"),
                const SizedBox(height: 5),
                Text(
                  subTeacherName,
                  style: const TextStyle(fontSize: 20),
                ),

                // save button
                const SizedBox(height: 50),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool isValid = validation();

                      // everything is valid
                      if (isValid) {
                        bool isOngoing = strClassStatus == "Ongoing" ? true : false;

                        print("Subject: " + classSubject.toString());
                        print("datetime_Start: " + dStart.toString());
                        print("datetime_End: " + dEnd.toString());
                        print("classroom: " + classroom!);
                        print("class ongoing: " + isOngoing.toString());
                      }
                    },
                    child: const Text("Save"),
                  ),
                ),

                const SizedBox(height: 20)
              ],
            ),
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

  void _navigateSelectTeacher(BuildContext context) async {
    dynamic result;

    result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SelectSubject(currentSubject: classSubject))
    );

    if (result != null) {
      setState(() {
        classSubject = result;
        subTeacher = classSubject["sub_teacher"];
      });
    }
  }

  bool validation() {
    // if everything is valid
    if (classSubject.isNotEmpty && startTime != null && endTime != null && dStart != null && _formKey.currentState!.validate()) {
      dStart = updateTime(startTime!);
      dEnd = updateTime(endTime!);

      // check if end time is earlier than start time
      if (dEnd!.isBefore(dStart!)) {
        ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
          duration: Duration(seconds: 5),
          content: Text("End time cannot be earlier than start time.", style: TextStyle(color: Colors.red)),
        ));
        return false;
      } else {
        return true;
      }
    } else {
      // if all fields are empty
      if (classSubject.isEmpty && (startTime == null || endTime == null || dStart == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 5),
            content: Text(
              "Please select a subject and specify the date and time.",
              style: TextStyle(color: Colors.red)
            ),
          )
        );
      } else {
        // if no subject selected
        if (classSubject.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 5),
              content: Text(
                "Please select a subject .",
                style: TextStyle(color: Colors.red)
              ),
            )
          );
        }

        // if startTime, endTime, or dStart is not specified
        if (startTime == null || endTime == null || dStart == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 5),
              content: Text(
                "Please select a date and start & end time.",
                style: TextStyle(color: Colors.red)
              ),
            )
          );
        }
      }
      return false;
    }
  }
}