import 'package:flutter/material.dart';

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
    //trim removes leading and trailing whitespace
    this._title = t.trim();
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
