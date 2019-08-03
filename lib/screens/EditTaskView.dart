import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModels/scoped_taskList.dart';
import '../models/taskInfo.dart';
import 'mainListView.dart';
class EditTaskPage extends StatelessWidget {
  final int index;
  EditTaskPage(this.index);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedTaskList>(
        builder: (context, child, model)
        => Scaffold(
          appBar: AppBar(
            title: Text('Edit Task'),
          ),
          body: EditTaskView(index: index, model: model),
        )
    );
  }
}

class EditTaskView extends StatefulWidget {
  int index;
  ScopedTaskList model;
  String taskTitle;
  String taskDescription;
  final DateTime currentDate = new DateTime.now();
  DateTime Date = new DateTime.now();
  TimeOfDay Time = new TimeOfDay.now();

  EditTaskView({@required this.index, @required this.model}) {
    if (this.model != null) {
      taskTitle = model.getTaskAt(index).getTitle();
      taskDescription = model.getTaskAt(index).getDescription();
      Date = model.getTaskAt(index).getDate();
      if (currentDate.isAfter(Date)) Date = currentDate;
      Time = model.getTaskAt(index).getTime();
    }
  }

  @override
  _editTaskViewState createState() => new _editTaskViewState();
}

class _editTaskViewState extends State<EditTaskView> {
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: new ListView(
          children: getFormWidget(),
        ));
  }

  List<Widget> getFormWidget() {
    List<Widget> formWidget = new List();

    formWidget.add(TextFormField(
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
      initialValue: widget.taskTitle,
      validator: (value) {
        if (value.isEmpty) {
          return 'Enter task';
        }
        widget.taskTitle = value;
      },
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      scrollPadding: EdgeInsets.all(16.0),
      onSaved: (value) {
        setState(() {
          widget.taskTitle = value;
        });
      },
    ));

    formWidget.add(TextFormField(
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
      initialValue: widget.taskDescription,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textCapitalization: TextCapitalization.sentences,
      scrollPadding: EdgeInsets.all(16.0),
      onSaved: (value) {
        setState(() {
          widget.taskDescription = value;
        });
      },
      validator: (value) {
        if (value != null) {
          setState(() {
            widget.taskDescription = value;
          });
        }
      },
    ));

    Future _selectDate() async {
      DateTime picked = await showDatePicker(
          context: context,
          initialDate: widget.Date,
          firstDate: widget.currentDate,
          lastDate: new DateTime(2022));
      if (picked != null) setState(() => widget.Date = picked);
    }

    Future _selectTime() async {
      TimeOfDay picked =
          await showTimePicker(context: context, initialTime: widget.Time);
      if (picked != null) setState(() => widget.Time = picked);
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

    formWidget.add(Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          formatter.format(widget.Date) + " " + widget.Time.format(context),
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        )
      ],
    ));

    formWidget.add(
        new ButtonBar(alignment: MainAxisAlignment.center, children: <Widget>[
      ScopedModelDescendant<ScopedTaskList>(
          builder: (context, child, model) => RaisedButton(
              color: Colors.blue,
              textTheme: ButtonTextTheme.primary,
              child: new Icon(Icons.check),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  if (widget.index >= 0) {
                    List<String> previousPostpones=model.getTaskAt(widget.index).getPostponeDates();
                    model.removeTaskAt(widget.index);

                    TaskInfo myNewTask=new TaskInfo.withoutID(widget.taskTitle,
                        widget.taskDescription, widget.Date, widget.Time,previousPostpones);
                    Navigator.push( context,
                        MaterialPageRoute(builder: (context) => NotificationTry(myNewTask)));
                    model.addNewTask(myNewTask);
                  }
                  else{
                    TaskInfo myNewTask=new TaskInfo(widget.taskTitle,
                        widget.taskDescription, widget.Date, widget.Time);
                    myNewTask.setPostpone(widget.Date.add(Duration(hours:
                    -widget.Date.hour,minutes: -widget.Date.minute)).add(Duration(
                        hours:widget.Time.hour,minutes: widget.Time.minute)
                    ).toString());
                    Navigator.push( context,
                        MaterialPageRoute(builder: (context) => NotificationTry(myNewTask)));
                    model.addNewTask(myNewTask);
                  }
                  //previous task is being destroyed and new one is created
                  // , find a way to maintain postpone list state from previous
                  //task







                }
              }))
    ]));

    return formWidget;
  }
}
