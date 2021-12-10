import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/home/class_listview.dart';
import 'package:student_attendance_fyp/services/database.dart';

class OngoingClassView extends StatefulWidget {
  const OngoingClassView({Key? key}) : super(key: key);

  @override
  State<OngoingClassView> createState() => _OngoingClassViewState();
}

class _OngoingClassViewState extends State<OngoingClassView> with AutomaticKeepAliveClientMixin {
  DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: dbService.getOngoingClassData(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No ongoing class at the moment."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return StreamBuilder(
                  stream: dbService.attendanceExists(UserModel().getUID, snapshot.data!.docs[index].id),
                  builder: (context, AsyncSnapshot<int> s) {
                    if (s.hasData) {
                      return buildClassList(context, snapshot.data!.docs[index], s.data);
                    } else {
                      return Container();
                    }
                  }
                );
              }
            );
          }
        }
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}