import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/database.dart';

class SelectSubject extends StatefulWidget {
  const SelectSubject({ Key? key, required this.currentSubject }) : super(key: key);

  final currentSubject;

  @override
  _SelectSubjectState createState() => _SelectSubjectState();
}

class _SelectSubjectState extends State<SelectSubject> {
  DatabaseService dbService = DatabaseService();
  List docs = [];
  List subjects = [];
  List subjectTeacher = [];
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllSubjects().whenComplete(() {
      setState((){
        loading = false;
      });
    });
  }

  Future getAllSubjects() async {
    docs = await dbService.getSubjects();

    for (int i=0; i<docs.length; i++) {
      Map data = await dbService.getSubjectDetails(docs[i].toString());
      subjects.add(data);
      subjectTeacher.add(data["sub_teacher"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Subject for Class Session"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: subjects.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(subjects[index]["sub_name"]),
              subtitle: Text(subjects[index]["sub_code"]),
              trailing: subjects[index]["sub_code"] == widget.currentSubject["sub_code"] ? const Icon(Icons.done) : const SizedBox.shrink(),
              onTap: () {
                Navigator.pop(context, subjects[index]);
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(
              height: 0,
              color: Colors.black38,
            );
          },
        ),
      )
    );
  }
}