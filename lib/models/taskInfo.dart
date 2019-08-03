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
  int _TaskIDWithEpoch;
  List<String> _PostponeRecords=[];//just for testing for now
  //constructor
  TaskInfo(String t, String descr, DateTime D, TimeOfDay T) {
    //trim removes leading and trailing whitespace
    this._title = t.trim();
    if (descr != null) this._description = descr.trim();
    else this._description=" ";
    this._finished = false;
    this._Date = D.add(Duration(hours:
    -D.hour,minutes: -D.minute)).add(Duration(
        hours:T.hour,minutes: T.minute
    ));
    this._Time = T;
    this._TaskIDWithEpoch=((DateTime.now().millisecondsSinceEpoch-1564253125789)/1000).round();

  }
  TaskInfo.withoutID(String t, String descr, DateTime D, TimeOfDay T, List<String> Postpone) {
    //trim removes leading and trailing whitespace
    this._title = t.trim();
    if (descr != null) this._description = descr.trim();
    else this._description=" ";
    this._finished = false;
    this._Date = D.add(Duration(hours:
    -D.hour,minutes: -D.minute)).add(Duration(
        hours:T.hour,minutes: T.minute
    ));
    this._Time = T;
    this._PostponeRecords=Postpone;
    this._PostponeRecords.add(this._Date.toString());
    this._TaskIDWithEpoch=((DateTime.now().millisecondsSinceEpoch-1564253125789)/1000).round();
  }
  TaskInfo.withPostpone(String t, String descr, DateTime D, TimeOfDay T, int ID,List<String> Postpone){

    this._title = t.trim();
    if (descr != null) this._description = descr.trim();
    else this._description=" ";
    this._finished = false;
    this._Date = D.add(Duration(hours:
    -D.hour,minutes: -D.minute)).add(Duration(
        hours:T.hour,minutes: T.minute
    ));
    this._Time = T;
    this._TaskIDWithEpoch=ID;
    this._PostponeRecords=Postpone;
    //DateTime TimeandDateUnion=this._Date.add(Duration(hours:T.hour,minutes: T.minute)-Duration(hours:D.));
    //this._PostponeRecords.add(this._Date.toString());
    //print(this._Date);
  }
  //accessors
  String getTitle() => this._title;
  List<String> getPostponeDates() => this._PostponeRecords;
  void setPostpone(String postpone){
    this._PostponeRecords.add(postpone);
  }
  String getDescription() => this._description;

  bool getFinished() => this._finished;

  DateTime getDate() => this._Date;

  TimeOfDay getTime() => this._Time;

  int getID() => this._TaskIDWithEpoch;

  void setFinished(bool f) {
    _finished = f;
  }
}
