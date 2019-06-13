import 'package:scoped_model/scoped_model.dart';
import '../models/taskInfo.dart';

class ScopedTaskList extends Model {
  var taskInfoList = new List<TaskInfo>();
  //add all related logic that is needed to manage the list

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

  void addNewTask(TaskInfo task){
    taskInfoList.add(task);
    notifyListeners();
  }

  void setFinishedAt(int i, bool fin){
    if ((i >= 0)&&(i < taskInfoList.length)){
      taskInfoList[i].setFinished(fin);
      notifyListeners();
    }
  }

}
