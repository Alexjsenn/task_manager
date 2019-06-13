import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModels/scoped_taskList.dart';
import '../models/taskInfo.dart';


class NewTaskPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('New Task'),
        ),
        body: NewTaskView(),
    );
  }
}



class NewTaskView extends StatefulWidget {
  @override
  _newTaskViewState createState() => new _newTaskViewState();
}



class _newTaskViewState extends State<NewTaskView>{

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
        ScopedModelDescendant<ScopedTaskList>(
          builder: (context, child, model)
          => RaisedButton(
              color: Colors.blue,
              textTheme: ButtonTextTheme.primary,
              child: new Icon(Icons.check),
              onPressed: () {
                if (formKey.currentState.validate()) {
                  model.addNewTask(new TaskInfo(_taskTitle, _taskDescription, _Date, _Time));
                  Navigator.of(context).pop();
                }
              }))
        ]
      )
    );

    return formWidget;
  }
}







 /* newest but incompete code





Widget FormView(BuildContext context) {
  return Form(
      key: formKey,
      child: new ListView(
        children: getFormWidget(),
      ));
}


*/




