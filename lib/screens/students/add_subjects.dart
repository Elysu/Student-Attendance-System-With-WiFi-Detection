import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/checkbox_state.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AddSubjects extends StatefulWidget {
  const AddSubjects({ Key? key }) : super(key: key);

  @override
  _AddSubjectsState createState() => _AddSubjectsState();
}

class _AddSubjectsState extends State<AddSubjects> {
  DatabaseService dbService = DatabaseService();
  List docs = [];
  List subjects = [];
  List<CheckBoxState> selectedItems = [];
  bool loading = true;
  
  Future getSubjectDetailsAndSetIntoList() async {
    docs = await dbService.getSubjects();

    for (int i=0; i<docs.length; i++) {
      Map data = await dbService.getSubjectDetails(docs[i].toString());
      subjects.add(CheckBoxState(title: data['sub_name'], subCode: data['sub_code']));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubjectDetailsAndSetIntoList().whenComplete(() {
      setState((){
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(selectedItems.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subjects"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: subjects.length,
              itemBuilder: (BuildContext context, int index) {
                if (loading) {
                  return const Text("Loading");
                } else {
                  return buildSingleCheckbox(subjects[index], index);
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
              onPressed: selectedItems.isEmpty ? null
              :() {
                
              },
              icon: const Icon(Icons.check_outlined),
              label: Text("${selectedItems.length} subjects selected"),
            ),
          )
        ],
      )
    );
  }

  Widget buildSingleCheckbox(CheckBoxState checkbox, int index) {
    return CheckboxListTile(
      title: Text(checkbox.title!),
      subtitle: Text(checkbox.subCode),
      value: checkbox.value,
      onChanged: (value) {
        setState(() {
          checkbox.value = value!;
          if (value) {
            selectedItems.add(CheckBoxState(subCode: checkbox.subCode, value: value));
          } else {
            selectedItems.removeWhere((element) => element.subCode == checkbox.subCode);
          }
        });
      }
    );
  }
}