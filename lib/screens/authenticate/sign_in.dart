import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login to Student Attendance System"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: Form(
          child: Column(
            children: <Widget>[
              // email field
              SizedBox(height: 20),
              TextFormField(
                onChanged: (value) {
                  setState(() => email = value);
                },
              ),
              // password field
              SizedBox(height: 20),
              TextFormField(
                obscureText: true,
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              //sign in button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  print(email);
                  print(password);
                },
                child: Text("LOGIN"),
              )
            ],
          ),
        ),
      )
    );
  }
}
