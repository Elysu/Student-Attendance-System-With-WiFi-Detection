import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:student_attendance_fyp/screens/class/class_details.dart';
import 'package:student_attendance_fyp/screens/class/create_class.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AllClass extends StatefulWidget {
  const AllClass({ Key? key }) : super(key: key);

  @override
  _AllClassState createState() => _AllClassState();
}

class _AllClassState extends State<AllClass> {
  DatabaseService dbService = DatabaseService();
  TextEditingController _searchController = TextEditingController();
  Icon _searchIcon = const Icon(Icons.search);
  Widget _appBarTitle = const Text( 'All Class Sessions' );

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
    var ongoing = [];
    var notOngoing = [];

    if (_searchController.text != "") {
      // we have a search parameter
      for(int i=0; i<_allResults.length; i++) {
        DocumentSnapshot ds = _allResults[i];
        var subName = ds['c_sub-name'].toString().toLowerCase();
        var subCode = ds['c_sub-code'].toString().toLowerCase();

        if(subName.contains(_searchController.text.toLowerCase()) || subCode.contains(_searchController.text.toLowerCase())) {
          if (ds['c_ongoing']) {
            ongoing.add(_allResults[i]);
          } else {
            notOngoing.add(_allResults[i]);
          }
        }
      }

      // add ongoing
      for (int i=0; i<ongoing.length; i++) {
        showResults.add(ongoing[i]);
      }

      // add not ongoing
      for (int i=0; i<notOngoing.length; i++) {
        showResults.add(notOngoing[i]);
      }
    } else {
      for(int i=0; i<_allResults.length; i++) {
        DocumentSnapshot ds = _allResults[i];
        var subName = ds['c_sub-name'].toString().toLowerCase();
        var subCode = ds['c_sub-code'].toString().toLowerCase();

        if (ds['c_ongoing']) {
          ongoing.add(_allResults[i]);
        } else {
          notOngoing.add(_allResults[i]);
        }
      }

      // add ongoing
      for (int i=0; i<ongoing.length; i++) {
        showResults.add(ongoing[i]);
      }

      // add not ongoing
      for (int i=0; i<notOngoing.length; i++) {
        showResults.add(notOngoing[i]);
      }
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  // get all students documents first
  getSubjects() async {
    var data = await dbService.classCollection.orderBy("c_datetimeEnd", descending: true).get();
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
        _appBarTitle = const Text( 'All Class Sessions' );
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
      body: _allResults.isEmpty 
      ? const Center(child: Text("No class sessions at the moment."))
      : ListView.separated(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: _resultsList.length,
        itemBuilder: (BuildContext context, int index) {
          Timestamp tStart = _resultsList[index]["c_datetimeStart"];
          Timestamp tEnd = _resultsList[index]["c_datetimeEnd"];
          DateTime dStart = tStart.toDate();
          DateTime dEnd = tEnd.toDate();
          String classStatus = "";
          Color textColor;

          if (_resultsList[index]["c_ongoing"]) {
            classStatus = "ONGOING";
            textColor = Colors.green;
          } else {
            classStatus = "N/A";
            textColor = Colors.grey;
          }

          return ListTile(
            title: Text(_resultsList[index]["c_sub-name"]),
            subtitle: Text(DateFormat('d/M/y').format(dStart).toString() + ", " + DateFormat('jm').format(dStart).toString() + " - " + DateFormat('jm').format(dEnd).toString()),
            trailing: Text(classStatus, style: TextStyle(color: textColor)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ClassDetails(docID: _resultsList[index].id))
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateClass())
          ).then((value) {
            setState(() {
              didChangeDependencies();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
      resizeToAvoidBottomInset: false
    );
  }
}