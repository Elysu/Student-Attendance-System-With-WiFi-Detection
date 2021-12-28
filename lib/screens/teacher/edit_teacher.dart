import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/checkbox_state.dart';
import 'package:student_attendance_fyp/screens/students/add_subjects.dart';
import 'package:student_attendance_fyp/services/database.dart';
import 'package:student_attendance_fyp/shared/delete.dart';

class EditTeacher extends StatefulWidget {
  const EditTeacher({ Key? key, required this.docID }) : super(key: key);

  final docID;

  @override
  _EditTeacherState createState() => _EditTeacherState();
}

class _EditTeacherState extends State<EditTeacher> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbService = DatabaseService();

  // TextEditingController to get text value from TextFormField
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();

  // text field state
  String name = '';
  String id = '';
  List<CheckBoxState> selectedItems = [];
  List subjectList = [], subjectDocID = [];
  bool isReadOnly = true;
  bool visibility = false;
  Icon editIcon = const Icon(Icons.edit);
  dynamic teacherData;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData().whenComplete(() {
      setState((){
        loading = false;
        nameController = TextEditingController(text: teacherData['name'].toString());
        idController = TextEditingController(text: teacherData['id'].toString());
      });
      
      List subjects = teacherData["subjects"];

      for (int i=0; i<subjects.length; i++) {
        selectedItems.add(CheckBoxState(subCode: subjects[i]['sub_code'], title: subjects[i]['sub_name'], value: true));
      }
    });
  }

  Future getUserData() async {
    teacherData = await dbService.getUserDetails(widget.docID);
  }

  @override
  Widget build(BuildContext context) {
    FloatingActionButton editButton = FloatingActionButton(
      onPressed: () {
        setState(() {
          isReadOnly = false;
          visibility = true;
        });
      },
      child: const Icon(Icons.edit),
    );

    FloatingActionButton cancelButton = FloatingActionButton(
      onPressed: () {
        getUserData().whenComplete((){
          setState(() {
            isReadOnly = true;
            visibility = false;
            nameController = TextEditingController(text: teacherData['name'].toString());
            idController = TextEditingController(text: teacherData['id'].toString());

            if (selectedItems.isNotEmpty) {
              selectedItems = List.empty(growable: true);
            }
            
            List subjects = teacherData["subjects"];
            for (int i=0; i<subjects.length; i++) {
              selectedItems.add(CheckBoxState(subCode: subjects[i]['sub_code'], title: subjects[i]['sub_name'], value: true));
            }
          });
        });
      },
      child: const Icon(Icons.cancel_outlined),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Lecturer"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              // delete for teacher
              deleteDialog(context: context, docID: widget.docID, type: 4, email: teacherData["email"].toString(), id: teacherData['id'], name: teacherData['name']);
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: loading ? const Center(child: Text("Loading")) 
      : SingleChildScrollView( // make contents scrollable when keyboard appears
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Form(
            // validate form via _formKey (access validation techniques and state)
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // email field
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: 'example@e.newera.edu.my',
                    icon: Icon(Icons.email),
                    labelText: "Email"
                  ),
                  controller: TextEditingController(text: teacherData['email'].toString()),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter an email." : null,
                ),
      
                // name field
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: isReadOnly,
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Name"
                  ),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter a name." : null,
                ),
      
                // Student ID field
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: isReadOnly,
                  controller: idController,
                  decoration: const InputDecoration(
                    hintText: 'T123',
                    icon: Icon(Icons.badge),
                    labelText: "Lecturer ID"
                  ),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter a lecturer ID." : null,
                ),
      
                // add subjects
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Selected Subjects:"),
                    Visibility(
                      visible: visibility,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _navigateAddSubjects(context, widget.docID, teacherData['id'], teacherData['name']);
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Subjects')
                      ),
                    )
                  ],
                ),
      
                // display selected subjects
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: selectedItems.isEmpty ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                  ),
                  child: selectedItems.isEmpty
                  ? const Center(child: Text("No subject selected"))
                  : ListView.separated(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: selectedItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(selectedItems[index].title),
                        subtitle: Text(selectedItems[index].subCode),
                        trailing: Visibility(
                          visible: visibility,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedItems.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.remove_circle),
                            color: Colors.red,
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return const Divider(
                        height: 0,
                        color: Colors.black38,
                      );
                    }
                  )
                ),

                // submit button
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: Visibility(
                    visible: visibility,
                    child: ElevatedButton(
                      onPressed: () async {
                        subjectList.clear();
                  
                        for (int i=0; i<selectedItems.length; i++) {
                          subjectList.add({"sub_code": selectedItems[i].subCode, "sub_name": selectedItems[i].title});
                        }

                        // if everything is valid
                        if (_formKey.currentState!.validate()) {
                          bool checkID = await dbService.checkIDExist(idController.text, teacherData['id'].toString());

                          // true = exist, false = not exist
                          if (!checkID) {
                            bool result = await dbService.updateUserData(widget.docID, nameController.text, idController.text, subjectList);

                            if (result) {
                              bool resetSubjectTeacher = await dbService.changeTeacherUnderSubject(teacherData["subjects"], subjectList, teacherData["id"], teacherData["name"], widget.docID);

                              if (resetSubjectTeacher) {
                                setState(() {
                                  isReadOnly = true;
                                  visibility = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text("Lecturer details successfully updated", style: TextStyle(color: Colors.green)),
                                  )
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    duration: Duration(seconds: 5),
                                    content: Text("Lecturer details successfully updated but failed to reset lecturer under some subjects.", style: TextStyle(color: Colors.red)),
                                  )
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(seconds: 5),
                                  content: Text("Failed to save, please try again.", style: TextStyle(color: Colors.red)),
                                )
                              );
                            }
                          } else { // if exists
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                duration: Duration(seconds: 5),
                                content: Text("A user with this ID has already exist in the system.", style: TextStyle(color: Colors.red)),
                              )
                            );
                          }
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isReadOnly ? editButton : cancelButton
    );
  }

  void _navigateAddSubjects(BuildContext context, String docID, String id, String name) async {
    final List<CheckBoxState>? result;

    if (selectedItems.isEmpty) {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddSubjects(selectedList: [], teacherScreen: true, docID: docID, id: id, name: name))
      );
    } else {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddSubjects(selectedList: selectedItems, teacherScreen: true, docID: docID, id: id, name: name))
      );
    }

    if (result != null) {
      setState(() {
        selectedItems = result!;
      });
    }
  }
}