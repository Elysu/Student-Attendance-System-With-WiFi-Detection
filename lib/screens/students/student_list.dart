import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/screens/students/add_student.dart';
import 'package:student_attendance_fyp/screens/students/edit_student.dart';
import 'package:student_attendance_fyp/services/database.dart';

class StudentList extends StatefulWidget {
  const StudentList({ Key? key }) : super(key: key);

  @override
  _StudentListState createState() => _StudentListState();
}

class _StudentListState extends State<StudentList> {
  DatabaseService dbService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  String _searchText = "";
  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text( 'Students List' );

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
    resultsLoaded = getStudents();
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
        var name = ds['name'].toString().toLowerCase();
        var id = ds['id'].toString().toLowerCase();

        if (name.contains(_searchController.text.toLowerCase()) || id.contains(_searchController.text.toLowerCase())) {
          showResults.add(_allResults[i]);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  // get all students documents first
  getStudents() async {
    var data = await dbService.userCollection.where('isTeacher', isNotEqualTo: true).get();
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
        _appBarTitle = const Text( 'Students List' );
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
      body: ListView.separated(
        itemCount: _resultsList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(_resultsList[index]["name"]),
            subtitle: Text(_resultsList[index]["id"]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditStudent(docID: _resultsList[index].id))
              );
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStudent())
          ).then((value) {
            if (value != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Student successfully added."),
                )
              );
            }
            didChangeDependencies();
            setState(() {});
          });
        },
        child: const Icon(Icons.person_add),
      ),
      resizeToAvoidBottomInset: false
    );
  }
}