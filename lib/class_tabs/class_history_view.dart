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

class _ClassHistoryViewState extends State<ClassHistoryView> {
  DatabaseService dbService = DatabaseService();
  List<dynamic> docs = ['HYMypNK1RQNNPSKIGZFs'];
  final List<ClassDataList> classList = [];

  void awaitGetClassHistoryDocID() async {
    //docs.add(await dbService.getClassHistoryDocID());

    if (docs.isNotEmpty) {
      for(int i=0; i<docs.length; i++) {
        Map<dynamic, dynamic> data = await dbService.getClassHistoryData(docs[i].toString());

        int attendance = await dbService.attendanceExists(UserModel().getUID.toString(), docs[i].toString());
        classList.add(ClassHistory(data['c_sub-name'], data['c_sub-code'], data['classroom'], data['c_datetimeStart'], data['c_datetimeStart'], attendance));
      }
    } else {
      print('No document class');
    }
  }

  @override
  Widget build(BuildContext context) {
    awaitGetClassHistoryDocID();
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: ListView.builder(
          itemCount: classList.length,
          itemBuilder: (BuildContext context, int index) => buildClassHistory(context, index, classList)
      ),
    );
  }
}
