import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/auth.dart';
import 'package:student_attendance_fyp/shared/constants.dart';
import 'package:student_attendance_fyp/shared/loading.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? const Loading() : Scaffold(
      backgroundColor: const Color(0xffe0e0e0),
      appBar: AppBar(
        title: const Text("Login to Student Attendance System"),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
        child: Form(
          // validate form via _formKey (access validation techniques and state)
          key: _formKey,
          child: Column(
            children: <Widget>[
              // email field
              const SizedBox(height: 20),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'example@e.newera.edu.my'),
                // if isValid then value is null
                validator: (value) => value!.isEmpty ? "Enter an email." : null,
                onChanged: (value) {
                  setState(() => email = value);
                },
              ),
              // password field
              const SizedBox(height: 20),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password'),
                obscureText: true,
                // if isValid then value is null
                validator: (value) => value!.length < 12 ? "Password cannot be shorter than 12 characters." : null,
                onChanged: (value) {
                  setState(() => password = value);
                },
              ),
              //sign in button
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // if everything is valid
                  if (_formKey.currentState!.validate()) {
                    setState(() => loading = true);

                    dynamic result = await _auth.signInEmailPassword(email, password);

                    if (result == null) {
                      setState(() {
                        error = 'Invalid email or password.';
                        loading = false;
                      });
                    }
                  }
                },
                child: const Text("LOGIN"),
              ),
              const SizedBox(height: 20,),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14)
              )
            ],
          ),
        ),
      )
    );
  }
}
