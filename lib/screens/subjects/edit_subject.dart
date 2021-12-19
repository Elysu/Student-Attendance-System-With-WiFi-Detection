import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'package:student_attendance_fyp/screens/subjects/change_teacher.dart';
import 'package:student_attendance_fyp/services/database.dart';
import 'package:student_attendance_fyp/shared/delete.dart';

class EditSubject extends StatefulWidget {
  const EditSubject({ Key? key, required this.docID}) : super(key: key);

  final docID;

  @override
  _EditSubjectState createState() => _EditSubjectState();
}

class _EditSubjectState extends State<EditSubject> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbService = DatabaseService();

  // TextEditingController to get text value from TextFormField
  TextEditingController subNameController = TextEditingController();
  TextEditingController subCodeController = TextEditingController();

  // text field state
  String subjectName = '';
  String subjectCode = '';
  Map subjectTeacher = {};
  String error = '';
  bool isReadOnly = true;
  bool visibility = false;
  Icon editIcon = const Icon(Icons.edit);
  Map? subjectData;
  bool loading = true;
  bool isAdmin = UserModel().getTeacher == false ? false : true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubjectData().whenComplete(() {
      setState((){
        loading = false;
        subNameController = TextEditingController(text: subjectData!['sub_name'].toString());
        subCodeController = TextEditingController(text: subjectData!['sub_code'].toString());
        subjectTeacher = subjectData!['sub_teacher'];
      });
    });
  }

  Future getSubjectData() async {
    subjectData = await dbService.getSubjectDetails(widget.docID);
  }

  @override
  Widget build(BuildContext context) {
    Visibility editButton = Visibility(
      visible: isAdmin,
      child: FloatingActionButton(
        onPressed: () {
          setState(() {
            isReadOnly = false;
            visibility = true;
          });
        },
        child: const Icon(Icons.edit),
      ),
    );

    Visibility cancelButton = Visibility(
      visible: isAdmin,
      child: FloatingActionButton(
        onPressed: () {
          getSubjectData().whenComplete(() {
            setState((){
              isReadOnly = true;
              visibility = false;
              subNameController = TextEditingController(text: subjectData!['sub_name'].toString());
              subCodeController = TextEditingController(text: subjectData!['sub_code'].toString());
              subjectTeacher.clear();
              subjectTeacher = subjectData!['sub_teacher'];
            });
          });
        },
        child: const Icon(Icons.cancel_outlined),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Subject"),
        centerTitle: true,
        actions: [
          Visibility(
            visible: isAdmin,
            child: IconButton(
              onPressed: () async {
                await deleteDialog(context, widget.docID, 2, subjectData!['sub_code'].toString(), subjectData!['sub_name'].toString());
              },
              icon: const Icon(Icons.delete),
            ),
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
                // subject name field
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: isReadOnly,
                  decoration: const InputDecoration(
                    hintText: 'Networking',
                    icon: Icon(Icons.menu_book),
                    labelText: "Subject Title"
                  ),
                  controller: subNameController,
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter a subject title." : null,
                ),
      
                // subject code field
                const SizedBox(height: 20),
                TextFormField(
                  readOnly: isReadOnly,
                  controller: subCodeController,
                  decoration: const InputDecoration(
                    hintText: 'NWK-123',
                    icon: Icon(Icons.book),
                    labelText: "Subject Code"
                  ),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter a subject code." : null,
                ),
      
                // subject teacher field
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Subject Teacher:"),
                    Visibility(
                      visible: visibility,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _navigateSelectTeacher(context);
                        },
                        icon: const Icon(Icons.loop),
                        label: const Text('Change')
                      ),
                    )
                  ],
                ),

                // display selected subjects
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                  ),
                  child: ListTile(
                    title: Text(subjectTeacher["t_name"].toString()),
                    subtitle: Text(subjectTeacher["t_id"].toString()),
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
                        // if everything is valid
                        if (_formKey.currentState!.validate()) {
                          String newSubCode = subCodeController.text;
                          String newSubName = subNameController.text;

                          bool updateSubject = await dbService.updateSubject(widget.docID, newSubCode, newSubName, subjectTeacher);

                          if (updateSubject) {
                            bool updateTeacherSubject = await dbService.updateTeacherSubject(widget.docID, subjectData!['sub_code'], subjectData!['sub_name'], newSubCode, newSubName, subjectData!["sub_teacher"], subjectTeacher);

                            if (updateTeacherSubject) {
                              getSubjectData().whenComplete(() {
                                setState((){
                                  isReadOnly = true;
                                  visibility = false;
                                  subNameController = TextEditingController(text: subjectData!['sub_name'].toString());
                                  subCodeController = TextEditingController(text: subjectData!['sub_code'].toString());
                                  subjectTeacher = subjectData!['sub_teacher'];
                                });
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Subject successfully updated."),
                                )
                              );
                            }
                          } else {
                            setState(() {
                              error = 'Subject update failed.';
                            });
                          }
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  error,
                  style: const TextStyle(color: Colors.red, fontSize: 14)
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: isReadOnly ? editButton : cancelButton
    );
  }

  void _navigateSelectTeacher(BuildContext context) async {
    dynamic result;

    if (subjectTeacher.isEmpty) {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ChangeTeacher(currentTeacher: {}))
      );
    } else {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangeTeacher(currentTeacher: {"t_name": subjectTeacher["t_name"], "t_id": subjectTeacher["t_id"]}))
      );
    }

    if (result != null) {
      setState(() {
        subjectTeacher = result;
      });
    }
  }
}