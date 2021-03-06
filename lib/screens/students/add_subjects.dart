import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/checkbox_state.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AddSubjects extends StatefulWidget {
  const AddSubjects({ Key? key, required this.selectedList, required this.teacherScreen, this.docID, this.name, this.id }) : super(key: key);

  final List<CheckBoxState> selectedList;
  final bool teacherScreen;
  final docID, name, id;

  @override
  _AddSubjectsState createState() => _AddSubjectsState();
}

class _AddSubjectsState extends State<AddSubjects> {
  DatabaseService dbService = DatabaseService();
  List docs = [];
  List<CheckBoxState> subjects = [];
  List<CheckBoxState> selectedItems = [];
  bool loading = true;
  
  Future getSubjectDetailsAndSetIntoList() async {
    if (widget.teacherScreen == true) {
      if (widget.id != null) {
        docs = await dbService.getSubjectsWithSameAndNoTeacher(widget.id, widget.name, widget.docID);
      } else {
        docs = await dbService.getSubjectsWithNoTeacher();
      }
    } else {
      docs = await dbService.getSubjects();
    }

    if (docs.isNotEmpty) {
      for (int i=0; i<docs.length; i++) {
        Map data = await dbService.getSubjectDetails(docs[i].toString());
        bool value = widget.selectedList.map((e) => e.subCode).contains(data['sub_code']);
        subjects.add(CheckBoxState(title: data['sub_name'], subCode: data['sub_code'], value: value));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(var i in widget.selectedList) {
      selectedItems.add(i);
    }

    getSubjectDetailsAndSetIntoList().whenComplete(() {
      setState((){
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subjects"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: loading ? const Text("Loading") : ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                if (subjects.isNotEmpty) {
                  return buildSingleCheckbox(subjects[index], index);
                } else {
                  return const Text("No available subjects.");
                }
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 0,
                  color: Colors.black38,
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(width: 1, color: Colors.black))
            ),
            child: ElevatedButton.icon(
              onPressed: selectedItems.isEmpty ? 
              () {
                Navigator.pop(context, List<CheckBoxState>.empty(growable: true));
              } :
              () {
                Navigator.pop(context, selectedItems);
              },
              icon: selectedItems.isEmpty ? const Icon(Icons.arrow_back) : const Icon(Icons.check_outlined),
              label: selectedItems.isEmpty ? const Text("Back") : Text("${selectedItems.length} subjects selected"),
            ),
          )
        ],
      )
    );
  }

  Widget buildSingleCheckbox(CheckBoxState checkbox, int index) {
    return CheckboxListTile(
      title: Text(checkbox.title),
      subtitle: Text(checkbox.subCode),
      value: checkbox.value,
      onChanged: (value) {
        setState(() {
          checkbox.value = value!;
          if (value) {
            selectedItems.add(checkbox);
          } else {
            selectedItems.removeWhere((element) => element.subCode == checkbox.subCode);
          }
        });
      }
    );
  }
}