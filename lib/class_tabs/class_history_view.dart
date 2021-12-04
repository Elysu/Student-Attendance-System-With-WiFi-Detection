import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/class_data_list.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/home/class_listview.dart';
import 'package:student_attendance_fyp/services/database.dart';

class ClassHistoryView extends StatefulWidget {
  const ClassHistoryView({Key? key}) : super(key: key);

  @override
  State<ClassHistoryView> createState() => _ClassHistoryViewState();
}

class _ClassHistoryViewState extends State<ClassHistoryView> with AutomaticKeepAliveClientMixin {
  DatabaseService dbService = DatabaseService();
  List docs = [];
  final List<ClassDataList> classList = [];
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: dbService.getClassHistoryData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              return StreamBuilder(
                stream: dbService.attendanceExists(UserModel().getUID, snapshot.data!.docs[index].id),
                builder: (context, AsyncSnapshot<int> s) {
                  if (s.hasData) {
                    return buildClassHistory(context, snapshot.data!.docs[index], snapshot.data!.docs[index].id, s.data);
                  } else {
                    return Container();
                  }
                }
              );
            }
          );
        }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
