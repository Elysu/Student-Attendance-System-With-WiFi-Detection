import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/class/class_details.dart';
import 'package:student_attendance_fyp/screens/home/class_listview.dart';
import 'package:student_attendance_fyp/services/database.dart';

class OngoingClassView extends StatefulWidget {
  const OngoingClassView({Key? key}) : super(key: key);

  @override
  State<OngoingClassView> createState() => _OngoingClassViewState();
}

class _OngoingClassViewState extends State<OngoingClassView> with AutomaticKeepAliveClientMixin {
  DatabaseService dbService = DatabaseService();
  List<Widget> ongoingList = [];
  List<Widget> upcomingList = [];

  @override
  Widget build(BuildContext context) {
    streamBuilder(ongoingList, upcomingList);
    return Column(
      children: <Widget>[
        ExpansionTile(
          title: const Text("Ongoing"),
          children: [
            Column(children: ongoingList)
          ],
        ),
        ExpansionTile(
          title: const Text("Upcoming"),
          children: [
            Column(children: upcomingList)
          ],
        ),
      ],
    );
  }

  Widget streamBuilder(List ongoingList, List upcomingList) {
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
            return const Center(child: Text("No ongoing or upcoming classes at the moment."));
          } else {
            for (int i=0; i<snapshot.data!.docs.length; i++) {
              DocumentSnapshot ds = snapshot.data!.docs[i];
              if (ds['c_ongoing']) {
                ongoingList.add(checkTeacherOrStudentStreamBuilder(snapshot.data!.docs[i].id, snapshot.data!.docs[i]));
              } else {
                upcomingList.add(checkTeacherOrStudentStreamBuilder(snapshot.data!.docs[i].id, snapshot.data!.docs[i]));
              }
            }

            return const Text("BRUH");
          }
        }
      ),
    );
  }

  Widget checkTeacherOrStudentStreamBuilder(String classDocID, DocumentSnapshot ds) {
    if (UserModel().getTeacher) {
      return GestureDetector(
        child: buildClassList(context, ds),
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
                          child: buildClassList(context, ds, s.data),
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