import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/class/class_attendance/edit_attendance.dart';
import 'package:student_attendance_fyp/services/database.dart';

class ClassAttendance extends StatefulWidget {
  const ClassAttendance({ Key? key, required this.classDocID }) : super(key: key);

  final classDocID;

  @override
  _ClassAttendanceState createState() => _ClassAttendanceState();
}

class _ClassAttendanceState extends State<ClassAttendance> {
  DatabaseService dbService = DatabaseService();
  bool loading = true;
  TextEditingController _searchController = TextEditingController();
  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text( 'Class Attendance' );

  Future? resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getAttendance();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      // we have a search parameter
      for (int i=0; i<_allResults.length; i++) {
        DocumentSnapshot ds = _allResults[i];
        var studentName = ds['name'].toString().toLowerCase();
        var studentID = ds['id'].toString().toLowerCase();

        if (studentName.contains(_searchController.text.toLowerCase()) || studentID.contains(_searchController.text.toLowerCase())) {
          showResults.add(_allResults[i]);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
      loading = false;
    });
  }

  // get all students documents first
  getAttendance() async {
    var data = await dbService.classCollection.doc(widget.classDocID).collection("students").orderBy("name", descending: false).get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "Complete";
  }

  void _searchPressed() {
    setState(() {
      if (_searchIcon.icon == Icons.search) {
        _searchIcon = const Icon(Icons.close);
        _appBarTitle = TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search...'
          ),
        );
      } else {
        _searchIcon = const Icon(Icons.search);
        _appBarTitle = const Text( 'Class Attendance' );
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _appBarTitle,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: _searchIcon,
            onPressed: _searchPressed,
          ),
        ],
      ),
      body: loading ? const Text("Loading...")
      : ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _resultsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_resultsList[index]["name"]),
            subtitle: Text(_resultsList[index]["id"]),
            trailing: attendanceText(_resultsList[index]["status"]),
            onTap: () {
              if (UserModel().getTeacher) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditAttendance(classID: widget.classDocID, uid: _resultsList[index].id))
                ).then((value) {
                  setState(() {
                    didChangeDependencies();
                  });
                });
              }
            },
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 0,
            color: Colors.black38,
          );
        },
      )
    );
  }

  attendanceText(String attendance) {
    String strAttendance = '';
    Color? attendanceColor;

    switch (attendance) {
      case 'present':
        strAttendance = "PRESENT";
        attendanceColor = Colors.green;
        break;
      case 'late':
        strAttendance = "LATE";
        attendanceColor = Colors.orange;
        break;
      case 'n/a':
        strAttendance = "N/A";
        attendanceColor = Colors.grey;
        break;
    }

    return Text(strAttendance, style: TextStyle(color: attendanceColor));
  }
}