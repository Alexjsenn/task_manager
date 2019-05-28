import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class taskListState extends State<TaskList> {
  var taskList = <TaskInfo>[];
  final _fontSize = const TextStyle(fontSize: 18.0);
  var taskListKey = GlobalKey;

  Widget _buildList() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final index = i ~/ 2;
          if (index >= taskList.length)
            return null;
          else if (i.isOdd)
            return Divider();
          else
            return _buildRow(taskList[index]);
        });
  }

  Widget _buildRow(TaskInfo info) {
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
            if (finished) {
              info.finished = false;
            } else {
              info.finished = true;
            }
          });
        });
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
            body: taskForm()


           /* TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(20.0),
                  hintText: 'Task',
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                  ),
                  border: UnderlineInputBorder(),
                ),
                style: TextStyle(
                  height: 1.2,
                ),
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                scrollPadding: EdgeInsets.all(16.0),
                onFieldSubmitted: (String value) {
                  setState(() {
                    taskList.add(TaskInfo(value, ''));
                    Navigator.of(context).pop();
                  });
                })*/

            ,
          );
        },
      ),
    );
  }
}

class _taskFormState extends State<taskForm> {
  final formKey = GlobalKey<FormState>();

  TaskInfo newTask;
  String _taskTitle;
  String _taskDescription;
  DateTime _Date = DateTime.now();
  TimeOfDay _Time = TimeOfDay.now();

  saveNewTask() {

  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: new ListView(
        children: getFormWidget(),
      ));
  }

  List<Widget> getFormWidget(){
    List<Widget> formWidget = new List();

    formWidget.add(new TextFormField(
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(20.0),
          hintText: 'Task',
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
          border: UnderlineInputBorder(),
        ),
        style: TextStyle(
          height: 1.2,
        ),
        validator: (value) {
          if (value.isEmpty) {return 'Enter task';}
        },
        maxLines: null,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        scrollPadding: EdgeInsets.all(16.0),
        onSaved: (value) {
          setState(() {
            _taskTitle = value;
          });
        },
        )
    );

    formWidget.add(new TextFormField(
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(20.0),
        hintText: 'Description',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 18,
        ),
        border: UnderlineInputBorder(),
      ),
      style: TextStyle(
        height: 1.2,
      ),
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      scrollPadding: EdgeInsets.all(16.0),
      onSaved: (value) {
        setState(() {
          _taskDescription = value;
        });
      },

    ));


    Future _selectDate() async {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: _Date,
          firstDate: new DateTime.now(),
          lastDate: new DateTime(2022)
      );
      if(picked != null) setState(() => _Date = picked);
    }

    Future _selectTime() async {
      TimeOfDay picked = await showTimePicker(
          context: context,
          initialTime: _Time
      );
      if (picked != null) setState(() => _Time = picked);
    }

    formWidget.add(new ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.blueAccent[600],
          child: new Icon(Icons.calendar_today),
          onPressed: _selectDate,
        ),
        RaisedButton(
          color: Colors.blueAccent[600],
          child: new Icon(Icons.access_time),
          onPressed: _selectTime,
        ),],
    ));

    var formatter = new DateFormat("MMMMEEEEd");
    formWidget.add(new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Text(
          formatter.format(_Date) + " " + _Time.format(context)
      )
      ],
    )
    );

    formWidget.add(new ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          color: Colors.blue,
          textTheme: ButtonTextTheme.primary,
          child: new Icon(Icons.check),
          onPressed: () {
            if (formKey.currentState.validate()) {
              var task = TaskInfo(_taskTitle, _taskDescription, _Date, _Time);
              Navigator.of(context).pop();
            }
          }
          )
      ],
    ));


  return formWidget;
  }
}

class taskForm extends StatefulWidget {
  @override
  _taskFormState createState() => new _taskFormState();
}

class TaskList extends StatefulWidget {
  @override
  taskListState createState() => taskListState();
}

class TaskInfo {
  String _title;
  String _description;
  bool finished;
  DateTime Date;
  TimeOfDay Time;

  TaskInfo(String t, String descr, DateTime D, TimeOfDay T) {
    this._title = t;
    this._description = descr;
    this.finished = false;
    this.Date = D;
    this.Time = T;
  }

  String getTitle() {
    return this._title;
  }

  String getDescription() {
    return this._description;
  }
}
