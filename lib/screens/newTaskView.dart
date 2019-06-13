import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModels/scoped_taskList.dart';
import '../models/taskInfo.dart';
import 'EditTaskView.dart';


class NewTaskPage extends StatelessWidget {
  final int index;
  NewTaskPage(this.index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: EditTaskView(index: index),
    );
  }
}
