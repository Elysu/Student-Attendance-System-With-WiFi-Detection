import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/checkbox_state.dart';
import 'package:student_attendance_fyp/screens/students/add_subjects.dart';
import 'package:student_attendance_fyp/services/auth.dart';
import 'package:student_attendance_fyp/services/database.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({ Key? key }) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbService = DatabaseService();

  // TextEditingController to get text value from TextFormField
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();

  // text field state
  String email = '';
  String password = '';
  String name = '';
  String id = '';
  String error = '';
  List<CheckBoxState> selectedItems = [];
  List subjectList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Student"),
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
                // email field
                const SizedBox(height: 20),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: 'example@e.newera.edu.my',
                    icon: Icon(Icons.email),
                    labelText: "Email"
                  ),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter an email." : null,
                ),
      
                // password field
                const SizedBox(height: 20),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    labelText: "Password"
                  ),
                  obscureText: true,
                  // if isValid then value is null
                  validator: (value) => value!.length < 12 ? "Password cannot be shorter than 12 characters." : null,
                ),
                
                // name field
                const SizedBox(height: 20),
                TextFormField(
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
                  controller: idController,
                  decoration: const InputDecoration(
                    hintText: 'S12345',
                    icon: Icon(Icons.person_pin_rounded),
                    labelText: "Student ID"
                  ),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter a student ID." : null,
                ),
      
                // add subjects
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Selected Subjects:"),
                    ElevatedButton.icon(
                      onPressed: () {
                        _navigateAddSubjects(context);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add Subjects')
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
                    shrinkWrap: true,
                    itemCount: selectedItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(selectedItems[index].title),
                        subtitle: Text(selectedItems[index].subCode),
                        trailing: IconButton(
                          onPressed: (){
                            setState(() {
                              selectedItems.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.remove_circle),
                          color: Colors.red,
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
                  child: ElevatedButton(
                    onPressed: () async {
                      subjectList.clear();

                      for (int i=0; i<selectedItems.length; i++) {
                        subjectList.add({"sub_code": selectedItems[i].subCode, "sub_name": selectedItems[i].title});
                      }

                      print(subjectList);

                      // if everything is valid
                      if (_formKey.currentState!.validate()) {
                        bool checkID = await dbService.checkIDExist(idController.text);

                        // true = exist, false = not exist
                        if (!checkID) {
                          dynamic result = await _auth.registerStudent(emailController.text, passwordController.text, nameController.text, idController.text, subjectList);

                          switch (result) {
                            case 'email-already-in-use':
                              setState(() {
                                error = 'This email is already in-use.';
                                print(error);
                              });
                              break;
                            case 'invalid-email':
                              setState(() {
                                error = 'Invalid email.';
                                print(error);
                              });
                              break;
                            case 'weak-password':
                              setState(() {
                                error = 'Weak password, try using a stronger password.';
                                print(error);
                              });
                              break;
                            case false:
                              error = 'Failed to add student.';
                              print('Failed');
                              break;
                            case true:
                              Navigator.pop(context, true);
                              break;
                          }

                          if (result != true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(seconds: 5),
                                content: Text(error, style: const TextStyle(color: Colors.red)),
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
                    child: const Text("Add Student"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateAddSubjects(BuildContext context) async {
    final List<CheckBoxState>? result;

    if (selectedItems.isEmpty) {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddSubjects(selectedList: []))
      );
    } else {
      result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddSubjects(selectedList: selectedItems))
      );
    }

    if (result != null) {
      setState(() {
        selectedItems = result!;
      });
    }
  }
}