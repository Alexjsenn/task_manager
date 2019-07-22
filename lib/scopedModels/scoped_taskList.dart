import 'package:scoped_model/scoped_model.dart';
import '../models/taskInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
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


    for(int i=0;i<dateList.length;++i){

      _currentDate.add(DateTime(int.parse(dateList[i].split("-")[0]),int.parse(dateList[i].split("-")[1]),
          int.parse(dateList[i].split("-")[2].split(" ")[0]),int.parse(dateList[i].split(" ")[1].split(":")[0]),
          int.parse(dateList[i].split(":")[1]),0,0,0));

      _time.add(TimeOfDay(hour: int.parse(timeList[i].split("(")[1].split(":")[0]), minute: int.parse(timeList[i].split("(")[1].split(":")[1].split(")")[0])));
      TaskInfo taskInfo=TaskInfo(titleList[i], descList[i], _currentDate[i], _time[i]);
      taskInfoList.add(taskInfo);

    }


    if(defaultTargetPlatform==TargetPlatform.android)
      setNotifications();
    notifyListeners();
  }
  void setNotifications() async{
    final idList=new List<int>();
    for(int i=0 ; i<taskInfoList.length;++i){

      DateTime combinedDateTime=await  DateTime(taskInfoList[i].getDate().year,taskInfoList[i].getDate().month
      ,taskInfoList[i].getDate().day,taskInfoList[i].getTime().hour,taskInfoList[i].getTime().minute);
      print(combinedDateTime);
      int milliSec=combinedDateTime.difference(DateTime.now()).inMilliseconds;
      Timer(combinedDateTime.difference(DateTime.now()),(){
        print("the trigger worked");
      });
//      int _ID=await ScheduledNotifications.scheduleNotification(
//          5000,
//          "Ticker text",
//          "Content title",
//          "Content");
//      print(DateTime.now().add(Duration(seconds: 5)).millisecondsSinceEpoch);
//      idList.add(_ID);
    }
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
  List<String> getAllTaskDesc(){
    var newList=new List<String>();
    print("inside desc");
    for(int i=0 ; i<taskInfoList.length;i++){
      newList.add(taskInfoList[i].getDescription());

      print(taskInfoList[i].getDescription());
    }
    print("inside desc");

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
      taskInfoList.removeAt(i);
      asyncUpdateTheMemory();
    }
  }
  void asyncUpdateTheMemory() async{


    List<String> titleList= getAllTaskTitles();
    List<String> dateList= getAllTaskDates();
    List<String> timeList=getAllTaskTimes();
    List<String> descList=getAllTaskDesc();
    //print(descList.length);
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('titleList', titleList);
    prefs.setStringList('dateList', dateList);
    prefs.setStringList('timeList', timeList);
    prefs.setStringList('descList', descList);
    print(titleList.length);
    print(dateList.length);
    print(timeList.length);
    print(descList.length);
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
