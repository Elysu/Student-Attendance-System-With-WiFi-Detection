import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffe0e0e0),
      child: Center(
        child: SpinKitRing(
          color: Colors.blue,
          size: 50.0,
        ),
      ),
    );
  }
}