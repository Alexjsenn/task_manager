import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/screens/mainListView.dart';



void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData.light(),
      home: new MainListView(),
    );
  }
}
