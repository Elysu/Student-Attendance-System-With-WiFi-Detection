import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/screens/students/add_subjects.dart';

class AddStudent extends StatefulWidget {
  const AddStudent({ Key? key }) : super(key: key);

  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  // text field state
  String email = '';
  String password = '';
  String name = '';
  String id = '';
  String error = '';

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // email field
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'example@e.newera.edu.my',
                    icon: Icon(Icons.email),
                    labelText: "Email"
                  ),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter an email." : null,
                  onChanged: (value) {
                    setState(() => email = value);
                  },
                ),
      
                // password field
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.password),
                    labelText: "Password"
                  ),
                  obscureText: true,
                  // if isValid then value is null
                  validator: (value) => value!.length < 12 ? "Password cannot be shorter than 12 characters." : null,
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                ),
                
                // name field
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person),
                    labelText: "Name"
                  ),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter a name." : null,
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                ),
      
                // Student ID field
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'S12345',
                    icon: Icon(Icons.person_pin_rounded),
                    labelText: "Student ID"
                  ),
                  // if isValid then value is null
                  validator: (value) => value!.isEmpty ? "Enter a student ID." : null,
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                ),
      
                // add subjects
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text("Selected Subjects:"),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AddSubjects())
                        );
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
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black)
                  ),
                  child: const Center(child: Text("No subjects selected")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}