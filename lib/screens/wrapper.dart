import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:student_attendance_fyp/models/user_model.dart';
import 'authenticate/authenticate.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    print(user);
    //return either Home or Authenticate widget based on user's sign in status
    return Authenticate();
  }
}
