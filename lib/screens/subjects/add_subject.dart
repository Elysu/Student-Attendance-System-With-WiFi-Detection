import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/screens/subjects/change_teacher.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AddSubject extends StatefulWidget {
  const AddSubject({ Key? key }) : super(key: key);

  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbService = DatabaseService();

  // TextEditingController to get text value from TextFormField
  TextEditingController subNameController = TextEditingController();
  TextEditingController subCodeController = TextEditingController();

  // text fields
  String subName = '';
  String subCode = '';
  String error = '';
  Map subjectTeacher = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Subject"),
        centerTitle: true,
      ),
      body: SingleChildScrollView( // make contents scrollable when keyboard appears
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
                    ElevatedButton.icon(
                      onPressed: () {
                        _navigateSelectTeacher(context);
                      },
                      icon: const Icon(Icons.loop),
                      label: const Text('Change')
                    )
                  ],
                ),

                // display selected subjects
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: subjectTeacher.isEmpty ? const EdgeInsets.all(20) : const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                  ),
                  child: subjectTeacher.isEmpty
                  ? const Center(child: Text("No teacher selected"))
                  : ListTile(
                    title: Text(subjectTeacher["t_name"].toString()),
                    subtitle: Text(subjectTeacher["t_id"].toString()),
                  )
                ),

                // submit button
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // if everything is valid
                      if (_formKey.currentState!.validate() && subjectTeacher.isNotEmpty) {
                        error = '';
                        bool isExist = await dbService.checkSubjectExist(subCodeController.text);

                        if (isExist) {
                          setState(() {
                            error = 'A subject with this subject code has already exist in the system';
                          });
                        } else {
                          bool result = await dbService.addSubject(subCodeController.text, subNameController.text, subjectTeacher);

                          if (result) {
                            List subject = [{"sub_code": subCodeController.text, "sub_name": subNameController.text}];
                            bool insertStatus = await dbService.updateUserTeacherSubject(subjectTeacher["t_uid"].toString(), subject);

                            if (insertStatus) {
                              Navigator.pop(context, true);
                            } else {
                              setState(() {
                                error = "Subject added but doesn't appear under the selected teacher";
                              });
                            }
                          } else {
                            setState(() {
                              error = 'Failed to add subject.';
                            });
                          }
                        }
                      } else {
                        setState(() {
                          error = '';
                          
                          if (subjectTeacher.isEmpty) {
                            error = 'Select a teacher for this subject';
                          }
                        });
                      }
                    },
                    child: const Text("Add Subject"),
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
        print(subjectTeacher);
      });
    }
  }
}