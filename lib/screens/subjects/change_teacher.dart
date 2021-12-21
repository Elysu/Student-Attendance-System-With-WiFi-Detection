import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/database.dart';

class ChangeTeacher extends StatefulWidget {
  const ChangeTeacher({ Key? key, required this.currentTeacher }) : super(key: key);

  final currentTeacher;

  @override
  _ChangeTeacherState createState() => _ChangeTeacherState();
}

class _ChangeTeacherState extends State<ChangeTeacher> {
  DatabaseService dbService = DatabaseService();
  List docs = [];
  List teachers = [];
  bool loading = true;

  Future getAllTeachersDocAndSetIntoList() async {
    docs = await dbService.getTeachers();

    for (int i=0; i<docs.length; i++) {
      DocumentSnapshot ds = docs[i];
      teachers.add({"t_name": ds["name"].toString(), "t_id": ds["id"].toString(), "t_uid": ds.id});
      print(ds.id);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    getAllTeachersDocAndSetIntoList().whenComplete(() {
      setState((){
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change Subject Teacher"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: teachers.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(teachers[index]["t_name"]),
              subtitle: Text(teachers[index]["t_id"]),
              trailing: teachers[index]["t_id"] == widget.currentTeacher["t_id"] ? const Icon(Icons.done) : const SizedBox.shrink(),
              onTap: () {
                Navigator.pop(context, {"t_id": teachers[index]["t_id"], "t_name": teachers[index]["t_name"], "t_uid": teachers[index]["t_uid"]});
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