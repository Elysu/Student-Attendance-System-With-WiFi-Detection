import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/screens/class/class_details.dart';
import 'package:student_attendance_fyp/screens/home/class_listview.dart';
import 'package:student_attendance_fyp/services/database.dart';

class UpcomingClassView extends StatefulWidget {
  const UpcomingClassView({Key? key}) : super(key: key);

  @override
  State<UpcomingClassView> createState() => _UpcomingClassViewState();
}

class _UpcomingClassViewState extends State<UpcomingClassView> with AutomaticKeepAliveClientMixin {
  DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: StreamBuilder<QuerySnapshot>(
        stream: dbService.getUpcomingClassData(context),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: Text("Loading..."));
          }
          
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No upcoming class at the moment."));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: buildClassList(context, snapshot.data!.docs[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClassDetails(docID: snapshot.data!.docs[index].id))
                    );
                  },
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