import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum MoreChoices { Edit, Remove }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of the application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData.light(),
      home: new TaskList(),
    );
  }
}

//main state, which contains the list view as well as the list variable
class taskListState extends State<TaskList> {
  var _taskInfoList = new List<TaskInfo>();
  final _fontSize = const TextStyle(fontSize: 18.0);
  void updateList(TaskInfo newTask) {
    setState(() {
      _taskInfoList.add(newTask);
    });
  }

  //creates the list view
  Widget _buildList() {
    return ListView.builder(
      itemCount: _taskInfoList.length,
      itemBuilder: (context, index) {
        final task = _taskInfoList[index];
        //allows swipe to delete by wrapping each row in a "dismissible"
        return Dismissible(
          key: Key(task.getTitle()),
          onDismissed: (endToStart) {
            setState(() {
              _taskInfoList.removeAt(index);
            });
            //show that its been removed in snackbar
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Task removed"),
              duration: const Duration(seconds: 2),
            ));
          },
          background: Container(
            color: Colors.red,
          ),
          child: buildRow(index),
        );
      },
    );
  }

  //builds each row, and implements all the button functionality
  Widget buildRow(int index) {
    TaskInfo info = _taskInfoList[index];
    final finished = info.getFinished();
    var formatter = new DateFormat("EEEE");
    var subs =
        (info.getDescription() == null) ? "" : info.getDescription() + '\n';
    TimeOfDay time = info.getTime();
    subs =
        subs + time.format(context) + " on " + formatter.format(info.getDate());
    return ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 6.0, horizontal: 15),
        title: Text(
          info.getTitle(),
          style: _fontSize,
        ),
        subtitle: Text(
          subs,
        ),
        leading: Icon(
          finished ? Icons.check_box : Icons.check_box_outline_blank,
          color: finished ? Colors.green : null,
        ),
        //implementation of the popup three-dot button on the right of each task
        trailing: new PopupMenuButton<MoreChoices>(
          icon: Icon(Icons.more_vert),
          onSelected: (MoreChoices selected) {
            if (selected == MoreChoices.Remove){
              setState(() {
                _taskInfoList.removeAt(index);
              });
              //show that its been removed in snackbar
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Task removed"),
                duration: const Duration(seconds: 2),
              ));
            }
            if (selected == MoreChoices.Edit){
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Cannot edit right now"),
                duration: const Duration(seconds: 2),
              ));
            }
          },
          itemBuilder: (context) => <PopupMenuEntry<MoreChoices>>[
                const PopupMenuItem<MoreChoices>(
                  value: MoreChoices.Edit,
                  child: Text("Edit"),
                ),
                const PopupMenuItem<MoreChoices>(
                  value: MoreChoices.Remove,
                  child: Text("Delete"),
                ),
              ],
        ),
        onTap: () {
          setState(() {
            if (finished) {
              info.setFinished(false);
            } else {
              info.setFinished(true);
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

  void _createTask() async {
    TaskInfo newTask = await Navigator.push(
      context,
      MaterialPageRoute<TaskInfo>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('New Task'),
            ),
            body: taskForm(),
          );
        },
      ),
    );
    if (newTask == null) return;
    setState(() {
      _taskInfoList.add(newTask);
    });
  }
}

class _taskFormState extends State<taskForm> {
  final formKey = GlobalKey<FormState>();

  String _taskTitle;
  String _taskDescription;
  DateTime _Date = DateTime.now();
  TimeOfDay _Time = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: new ListView(
          children: getFormWidget(),
        ));
  }

  List<Widget> getFormWidget() {
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
        if (value.isEmpty) {
          return 'Enter task';
        }
        _taskTitle = value;
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
    ));

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
      validator: (value) {
        if (value != null) {
          setState(() {
            _taskDescription = value;
          });
        }
      },
    ));

    Future _selectDate() async {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: _Date,
          firstDate: _Date,
          lastDate: new DateTime(2022));
      if (picked != null) setState(() => _Date = picked);
    }

    Future _selectTime() async {
      TimeOfDay picked =
          await showTimePicker(context: context, initialTime: _Time);
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
        ),
      ],
    ));

    var formatter = new DateFormat("MMMMEEEEd");
    formWidget.add(new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          formatter.format(_Date) + " " + _Time.format(context),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        )
      ],
    ));

    formWidget.add(new ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
            color: Colors.blue,
            textTheme: ButtonTextTheme.primary,
            child: new Icon(Icons.check),
            onPressed: () {
              if (formKey.currentState.validate()) {
                Navigator.of(context).pop(
                    new TaskInfo(_taskTitle, _taskDescription, _Date, _Time));
              }
            })
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
  TaskList({Key TaskListKey}) : super(key: TaskListKey);
  State createState() => taskListState();
}

//this contains all the information pertaining to a single task
class TaskInfo {
  //variables and methods that begin with an underscore indicate
  // they are private to the class!!! (just how the syntax works)
  String _title;
  String _description;
  bool _finished;
  DateTime _Date;
  TimeOfDay _Time;

  //constructor
  TaskInfo(String t, String descr, DateTime D, TimeOfDay T) {
    this._title = t.trim();
    //print(t);
    if (descr != null) this._description = descr.trim();
    this._finished = false;
    this._Date = D;
    this._Time = T;
  }

  //accessors
  String getTitle() => this._title;

  String getDescription() => this._description;

  bool getFinished() => this._finished;

  DateTime getDate() => this._Date;

  TimeOfDay getTime() => this._Time;

  void setFinished(bool f) {
    _finished = f;
  }
}
