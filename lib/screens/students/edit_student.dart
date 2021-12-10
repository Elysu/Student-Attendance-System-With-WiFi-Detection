import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/models/checkbox_state.dart';
import 'package:student_attendance_fyp/screens/students/add_subjects.dart';
import 'package:student_attendance_fyp/services/database.dart';

class EditStudent extends StatefulWidget {
  const EditStudent({ Key? key, required this.docID }) : super(key: key);

  final docID;

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbService = DatabaseService();

  // TextEditingController to get text value from TextFormField
  TextEditingController nameController = TextEditingController();
  TextEditingController idController = TextEditingController();

  // text field state
  String name = '';
  String id = '';
  String error = '';
  List<CheckBoxState> selectedItems = [];
  List subjectList = [];
  bool isReadOnly = true;
  bool visibility = false;
  Icon editIcon = const Icon(Icons.edit);
  dynamic studentData;
  bool loading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudentData().whenComplete(() {
      setState((){
        loading = false;
        nameController = TextEditingController(text: studentData['name'].toString());
        idController = TextEditingController(text: studentData['id'].toString());
      });
      
      List subjects = studentData["subjects"];

      for (int i=0; i<subjects.length; i++) {
        selectedItems.add(CheckBoxState(subCode: subjects[i]['sub_code'], title: subjects[i]['sub_name'], value: true));
      }
    });
  }

  Future getStudentData() async {
    studentData = await dbService.getStudentDetails(widget.docID);
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
        setState(() {
          isReadOnly = true;
          visibility = false;
        });
      },
      child: const Icon(Icons.cancel_outlined),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Student"),
        centerTitle: true,
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
                  controller: TextEditingController(text: studentData['email'].toString()),
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
                    Visibility(
                      visible: visibility,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _navigateAddSubjects(context);
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
                    shrinkWrap: true,
                    itemCount: selectedItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(selectedItems[index].title),
                        subtitle: Text(selectedItems[index].subCode),
                        trailing: Visibility(
                          visible: visibility,
                          child: IconButton(
                            onPressed: (){
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
                  
                        print(subjectList);
                  
                        // if everything is valid
                        if (_formKey.currentState!.validate()) {
                          
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