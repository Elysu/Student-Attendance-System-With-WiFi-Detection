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
      setState((){});
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Subjects from DB are $subjects");
    print(selectedItems.toString());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subjects"),
        centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: subjects.length,
        itemBuilder: (BuildContext context, int index) {
          return buildSingleCheckbox(subjects[index], index);
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