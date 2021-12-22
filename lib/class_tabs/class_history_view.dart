import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/class/class_details.dart';
import 'package:student_attendance_fyp/screens/home/class_listview.dart';
import 'package:student_attendance_fyp/services/database.dart';

class ClassHistoryView extends StatefulWidget {
  const ClassHistoryView({Key? key}) : super(key: key);

  @override
  State<ClassHistoryView> createState() => _ClassHistoryViewState();
}

class _ClassHistoryViewState extends State<ClassHistoryView> with AutomaticKeepAliveClientMixin {
  DatabaseService dbService = DatabaseService();
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: dbService.getClassHistoryData(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: Text("Loading..."));
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No recent class."));
          } else {
            return SingleChildScrollView(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return checkTeacherOrStudentStreamBuilder(snapshot.data!.docs[index].id, snapshot.data!.docs[index]);
                }
              ),
            );
          }
        }
      ),
    );
  }

  Widget checkTeacherOrStudentStreamBuilder(String classDocID, DocumentSnapshot ds) {
    if (UserModel().getTeacher) {
      return GestureDetector(
        child: buildClassHistory(context, ds),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ClassDetails(docID: classDocID)));
        },
      );
    } else {
      return StreamBuilder(
                    stream: dbService.streamGetAttendance(classDocID),
                    builder: (context, AsyncSnapshot<int> s) {
                      if (s.hasData) {
                        return GestureDetector(
                          child: buildClassHistory(context, ds, s.data),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ClassDetails(docID: classDocID))
                            );
                          },
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }
                  );
    }
  }

  @override
  bool get wantKeepAlive => true;
}
