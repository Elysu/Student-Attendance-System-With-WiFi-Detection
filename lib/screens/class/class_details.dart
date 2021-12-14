import 'package:flutter/material.dart';

class ClassDetails extends StatefulWidget {
  const ClassDetails({ Key? key, required this.docID }) : super(key: key);

  final docID;

  @override
  _ClassDetailsState createState() => _ClassDetailsState();
}

class _ClassDetailsState extends State<ClassDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Class Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // class name
              const SizedBox(height: 20),
              const Text("Class:"),
              const SizedBox(height: 5),
              Text(
                "Human Computer Interaction",
                style: TextStyle(fontSize: 20),
              ),
      
              // class subject code
              const SizedBox(height: 30),
              const Text("Subject Code:"),
              const SizedBox(height: 5),
              Text(
                "BIBGE-123",
                style: TextStyle(fontSize: 20),
              ),
      
              // class datetime
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // date
                        const SizedBox(height: 30),
                        const Text("Date:"),
                        const SizedBox(height: 5),
                        Text(
                          "24/11/2021",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // time
                        const SizedBox(height: 30),
                        const Text("Time:"),
                        const SizedBox(height: 5),
                        Text(
                          "4:00 PM - 7:00 PM",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // class status and classroom
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // classroom
                        const SizedBox(height: 30),
                        const Text("Classroom:"),
                        const SizedBox(height: 5),
                        Text(
                          "B3",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // class status
                        const SizedBox(height: 30),
                        const Text("Class Status:"),
                        const SizedBox(height: 5),
                        Text(
                          "Ongoing",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              // class teacher
              const SizedBox(height: 30),
              const Text("Lecturer:"),
              const SizedBox(height: 5),
              Text(
                "Ng Si Liang",
                style: TextStyle(fontSize: 20),
              ),

              // my attendance
              const SizedBox(height: 30),
              const Text("Your attendance:"),
              const SizedBox(height: 5),
              Text(
                "PRESENT",
                style: TextStyle(fontSize: 20),
              ),
            ]
          ),
        ),
      ),
    );
  }
}