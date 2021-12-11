import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/subjects/edit_subject.dart';
import 'package:student_attendance_fyp/services/database.dart';

class SelectedSubjects extends StatefulWidget {
  const SelectedSubjects({ Key? key }) : super(key: key);

  @override
  _SelectedSubjectsState createState() => _SelectedSubjectsState();
}

class _SelectedSubjectsState extends State<SelectedSubjects> {
  DatabaseService dbService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text( 'Class Subjects' );

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
    resultsLoaded = getSubjects();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];

    if (_searchController.text != "") {
      // we have a search parameter
      for(int i=0; i<_allResults.length; i++) {
        DocumentSnapshot ds = _allResults[i];
        var subName = ds['sub_name'].toString().toLowerCase();
        var subCode = ds['sub_code'].toString().toLowerCase();

        if(subName.contains(_searchController.text.toLowerCase()) || subCode.contains(_searchController.text.toLowerCase())) {
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
  getSubjects() async {
    List subjects = UserModel().getSubjects;
    List subjectCode = [];

    for (int i=0; i<subjects.length; i++) {
      subjectCode.add(subjects[i]['sub_code']);
    }

    var data = await dbService.subjectCollection.where('sub_code', whereIn: subjectCode).get();
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
        _appBarTitle = const Text( 'Class Subjects' );
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
            title: Text(_resultsList[index]["sub_name"]),
            subtitle: Text(_resultsList[index]["sub_code"]),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditSubject(docID: _resultsList[index].id))
              ).then((value) {
                didChangeDependencies();
                setState(() {});
              });
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
      resizeToAvoidBottomInset: false
    );
  }
}