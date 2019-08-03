import 'package:scoped_model/scoped_model.dart';
import '../models/taskInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:scheduled_notifications/scheduled_notifications.dart';
//import 'package:scheduled_notifications_example/time_picker.dart';


class ScopedTaskList extends Model {
  var taskInfoList = new List<TaskInfo>();
  //add all related logic that is needed to manage the list
  void getMemoryTasks() async{

    final _currentDate=new List<DateTime>();
    final _time = new List<TimeOfDay>();

    final prefs = await SharedPreferences.getInstance();
    
    final List<String> titleList = prefs.getStringList('titleList') ?? [];
    final List<String> dateList= prefs.getStringList('dateList') ?? [];
    final List<String> timeList= prefs.getStringList('timeList') ?? [];
    final List<String> descList=prefs.getStringList('descList') ?? [];
    final List<String> IDList=prefs.getStringList('IDList') ?? [];

    for(int i=0;i<dateList.length;++i){
      final List<String> _postpones=prefs.getStringList(IDList[i]) ?? [];
      print(_postpones);
      _currentDate.add(DateTime(int.parse(dateList[i].split("-")[0]),int.parse(dateList[i].split("-")[1]),
          int.parse(dateList[i].split("-")[2].split(" ")[0]),int.parse(dateList[i].split(" ")[1].split(":")[0]),
          int.parse(dateList[i].split(":")[1]),0,0,0));

      _time.add(TimeOfDay(hour: int.parse(timeList[i].split("(")[1].split(":")[0]), minute: int.parse(timeList[i].split("(")[1].split(":")[1].split(")")[0])));
      TaskInfo taskInfo=TaskInfo.withPostpone(titleList[i], descList[i], _currentDate[i], _time[i], int.parse(IDList[i]),_postpones);

      taskInfoList.add(taskInfo);

    }


    notifyListeners();
  }
  ScopedTaskList(){
    print("inside scoped constructor");
    getMemoryTasks();


    print("exiting constructor");

  }
  List<String> getAllTaskTitles(){
    var newList=new List<String>();
    for(int i=0 ; i<taskInfoList.length;i++){
      newList.add(taskInfoList[i].getTitle());
    }


    return newList;
  }
  List<String> getAllTaskDates(){
    var newList=new List<String>();
    for(int i=0 ; i<taskInfoList.length;i++){
      newList.add(taskInfoList[i].getDate().toString());
    }


    return newList;
  }
  List<String> getAllTaskTimes(){
    var newList=new List<String>();
    for(int i=0 ; i<taskInfoList.length;i++){
      newList.add(taskInfoList[i].getTime().toString());
    }


    return newList;
  }
  List<String> getAllTaskIDs(){
    var newList=new List<String>();
    for(int i=0 ; i<taskInfoList.length;i++){
      newList.add(taskInfoList[i].getID().toString());
    }


    return newList;
  }
  List<String> getAllTaskDesc(){
    var newList=new List<String>();

    for(int i=0 ; i<taskInfoList.length;i++){
      newList.add(taskInfoList[i].getDescription());

      print(taskInfoList[i].getDescription());
    }


    return newList;
  }
  //accessors
  int getSize() => taskInfoList.length;

  TaskInfo getTaskAt(int i){
    if ((i < 0)||(i > taskInfoList.length - 1)) return null;
    else return taskInfoList[i];
  }


  //modifiers
  void removeTaskAt(int i) {
    if ((i >= 0)&&(i < taskInfoList.length)){
      asyncCancelNotification(i);
      taskInfoList.removeAt(i);
      asyncUpdateTheMemory();


    }
  }
  void asyncCancelNotification(int i) async{
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.cancel(taskInfoList[i].getID());
  }
  void asyncUpdateTheMemory() async{
  //problem with date and time storing
    //will look at

    List<String> titleList= getAllTaskTitles();
    List<String> dateList= getAllTaskDates();
    List<String> timeList=getAllTaskTimes();
    List<String> descList=getAllTaskDesc();
    List<String> IDList=getAllTaskIDs();
    List<String> _postponeID;
    //print(descList.length);
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('titleList', titleList);
    prefs.setStringList('dateList', dateList);
    prefs.setStringList('timeList', timeList);
    prefs.setStringList('descList', descList);
    prefs.setStringList('IDList', IDList);
    for(int i=0;i<taskInfoList.length;i++){
      _postponeID=taskInfoList[i].getPostponeDates();
      //print(_postponeID);
      prefs.setStringList(taskInfoList[i].getID().toString(), _postponeID);
    }


    notifyListeners();
}
  void addNewTask(TaskInfo task) {
    taskInfoList.add(task);
    asyncUpdateTheMemory();

  }

  void setFinishedAt(int i, bool fin){
    if ((i >= 0)&&(i < taskInfoList.length)){
      taskInfoList[i].setFinished(fin);
      notifyListeners();
    }
  }

}
