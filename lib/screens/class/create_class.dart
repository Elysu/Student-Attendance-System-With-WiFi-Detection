import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/database.dart';

class CreateClass extends StatefulWidget {
  const CreateClass({ Key? key }) : super(key: key);

  @override
  _CreateClassState createState() => _CreateClassState();
}

class _CreateClassState extends State<CreateClass> {
  final _formKey = GlobalKey<FormState>();
  DatabaseService dbService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Class Session"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // class name
                const SizedBox(height: 20),
                const Text("Class:"),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}