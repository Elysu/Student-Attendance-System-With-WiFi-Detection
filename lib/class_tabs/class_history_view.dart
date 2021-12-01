import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/class_data_list.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/home/class_listview.dart';
import 'package:student_attendance_fyp/services/database.dart';
import 'package:provider/provider.dart';

class ClassHistoryView extends StatefulWidget {
  const ClassHistoryView({Key? key}) : super(key: key);

  @override
  State<ClassHistoryView> createState() => _ClassHistoryViewState();
}

class _ClassHistoryViewState extends State<ClassHistoryView> with AutomaticKeepAliveClientMixin {
  DatabaseService dbService = DatabaseService();
  List docs = [];
  final List<ClassDataList> classList = [];

  /*
  Stream<QuerySnapshot> awaitGetClassHistoryDocID() async* {
    // set class doc ID into docs
    docs = await dbService.getClassHistoryDocID();

    if (docs.isNotEmpty) {
      // loop through docs to find out each class details
      for(int i=0; i<docs.length; i++) {
        Map<dynamic, dynamic> data = await dbService.getClassHistoryData(docs[i].toString());
        Timestamp tStart = data['c_datetimeStart'];
        Timestamp tEnd = data['c_datetimeEnd'];

        int attendance = await dbService.attendanceExists(UserModel().getUID.toString(), docs[i].toString());
        classList.add(ClassHistory(data['c_sub-name'], data['c_sub-code'], data['classroom'], DateTime.parse(tStart.toDate().toString()), DateTime.parse(tEnd.toDate().toString()), attendance));
      }
    } else {
      print('No document class');
    }
  }
  */

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: dbService.getClassHistoryData(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Text("Loading...");
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) => buildClassHistory(context, snapshot.data!.docs[index], snapshot.data!.docs[index].id)
          );
        }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
