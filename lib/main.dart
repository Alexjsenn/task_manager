import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData.light(),
      home: TaskList(),
    );
  }
}

class taskListState extends State<TaskList>{
  var taskList = <TaskInfo>[];
  final _fontSize = const TextStyle(fontSize: 18.0);

  Widget _buildList(){
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final index = i ~/ 2;
          if (index >= taskList.length) return null;
          else if (i.isOdd) return Divider();
          else return _buildRow(taskList[index]);
        }
      );
  }

  Widget _buildRow (TaskInfo info){
    final finished = info.finished;
    return ListTile(
      title: Text(
        info.getTitle(),
        style: _fontSize,
      ),
      leading: Icon(
        finished ? Icons.check_box : Icons.check_box_outline_blank,
        color: finished ? Colors.green : null,
      ),
      onTap: () {
        setState(() {
          if (finished){
            info.finished = false;
          } else {
            info.finished = true;
          }
        });
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
      ),
      body: _buildList(),
      floatingActionButton: FloatingActionButton(
          onPressed: _createTask,
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
      ),
    );
  }

  void _createTask() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('New Task'),
            ),
            body: TextFormField(
              decoration: const InputDecoration(
                contentPadding: const EdgeInsets.all(16.0),
                hintText: 'Task',
              ),
              onFieldSubmitted: (String value) {
                setState(() {
                  taskList.add(TaskInfo(value, ''));
                  Navigator.of(context).pop();
                });
              }
            ),
          );
        },
      ),
    );
  }


}

class TaskList extends StatefulWidget{
  @override
  taskListState createState() => taskListState();
}


class TaskInfo {
  String _title;
  String _description;
  bool finished;

  TaskInfo(String t, String descr){
    this._title = t;
    this._description = descr;
    this.finished = false;
  }

  String getTitle() {return this._title;}
  String getDescription() {return this._description;}
}