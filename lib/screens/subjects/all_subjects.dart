import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/subjects/add_subject.dart';
import 'package:student_attendance_fyp/screens/subjects/edit_subject.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AllSubjects extends StatefulWidget {
  const AllSubjects({ Key? key }) : super(key: key);

  @override
  _AllSubjectsState createState() => _AllSubjectsState();
}

class _AllSubjectsState extends State<AllSubjects> {
  DatabaseService dbService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text( 'All Subjects' );

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
    var data = await dbService.subjectCollection.get();
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
        _appBarTitle = const Text( 'All Subjects' );
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
      body: SingleChildScrollView(
        child: ListView.separated(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
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
                  setState(() {
                    didChangeDependencies();
                  });
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSubject())
          ).then((value) {
            if (value != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Subject successfully added.", style: TextStyle(color: Colors.green)),
                )
              );
            }
            setState(() {
              didChangeDependencies();
            });
          });
        },
        child: const Icon(Icons.post_add),
      ),
      resizeToAvoidBottomInset: false
    );
  }
}