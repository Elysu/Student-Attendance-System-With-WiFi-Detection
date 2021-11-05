import 'package:flutter/material.dart';
import 'package:student_attendance_fyp/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () async {
                    dynamic result = await _auth.anonSignIn();

                    if (result == null) {
                      print("Error signing in");
                    } else {
                      print("Signed in");
                      print(result.uid);
                    }
                  },
                  child: Text("Sign In Anon")
              )
            ],
          ),
        ],
      ),
    );
  }
}
