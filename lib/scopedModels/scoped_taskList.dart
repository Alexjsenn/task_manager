import 'package:scoped_model/scoped_model.dart';
import '../models/taskInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';



class ScopedTaskList extends Model {
  var taskInfoList = new List<TaskInfo>();
  //add all related logic that is needed to manage the list
  void getMemoryTasks() async{

    final DateTime _currentDate=new DateTime.now();
    TimeOfDay _time = new TimeOfDay.now();
    String test=_time.toString();
    print(test);
    final prefs = await SharedPreferences.getInstance();
    
    final List<String> myList = prefs.getStringList('titleList') ?? [];
    for(int i=0;i<myList.length;i++){
      TaskInfo taskInfo=TaskInfo(myList[i], "", _currentDate, _time);
      taskInfoList.add(taskInfo);
      print(myList[i]);

    }notifyListeners();
  }

  void delayed(){

    Future.delayed(Duration(seconds: 10000));
    return;
  }
  ScopedTaskList(){
    print("inside scoped constructor");
    getMemoryTasks();



    for(int i=0 ;i<taskInfoList.length;++i){
      print(taskInfoList[i].getTitle());
    }



    print("exiting constructor");

  }
  List<String> getAllTasks(){
    var newList=new List<String>();
    for(int i=0 ; i<taskInfoList.length;i++){
      newList.add(taskInfoList[i].getTitle());
    }
    for(int i=0 ; i<newList.length;i++){
      print(newList[i]);
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
  void removeTaskAt(int i){
    if ((i >= 0)&&(i < taskInfoList.length)){
      taskInfoList.removeAt(i);
      notifyListeners();
    }
  }

  void addNewTask(TaskInfo task) async{
    taskInfoList.add(task);
    List<String> newList= getAllTasks();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('titleList', newList);
    notifyListeners();
  }

  void setFinishedAt(int i, bool fin){
    if ((i >= 0)&&(i < taskInfoList.length)){
      taskInfoList[i].setFinished(fin);
      notifyListeners();
    }
  }

}
