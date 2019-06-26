import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModels/scoped_taskList.dart';
import '../models/taskInfo.dart';
import 'newTaskView.dart';
import 'EditTaskView.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum MoreChoices { Edit, Remove }

class MainListView extends StatelessWidget {
  final ScopedTaskList scopedList = ScopedTaskList();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ScopedTaskList>(
      model: scopedList,
      child: MaterialApp(
        title: 'Task Manager',
        theme: ThemeData.light(),
        home: new listView(),
      ),
    );
  }
}

class listView extends StatelessWidget {
  void printMemory() async{
    final prefs = await SharedPreferences.getInstance();
    print("inside print mem");
    final List<String> myList = prefs.getStringList('titleList') ?? [];
    for(int i=0; i<myList.length;++i){
      print(myList[i]);
    }
    print("exiting print mem");
  }


  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedTaskList>(
        builder: (context, child, model)
        => Scaffold(
          appBar: AppBar(
            title: Text('Task Manager'),
          ),
          body: _buildList(model),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              printMemory();
              Navigator.push( context,
                MaterialPageRoute(builder: (context) => NewTaskPage(-1,model)),
            );},
            child: Icon(Icons.add),
            backgroundColor: Colors.blue,
          ),
        ));
  }



  //creates the list view
  Widget _buildList(ScopedTaskList list) {
    return ListView.builder(
      itemCount: list.getSize(),
      itemBuilder: (context, index) {
        final task = list.getTaskAt(index);
        //allows swipe to delete by wrapping each row in a "dismissible"
        return Dismissible(
          key: Key(task.getTitle()),
          onDismissed: (endToStart) {
            list.removeTaskAt(index);
            //show that its been removed in snackbar
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Task removed"),
              duration: const Duration(seconds: 2),
            ));
          },
          background: Container(
            color: Colors.red,
          ),
          child: _buildRow(index, list, context),
        );
      },
    );
  }


  //builds each row, and implements all the button functionality
  Widget _buildRow(int index, ScopedTaskList list, BuildContext context) {
    TaskInfo info = list.getTaskAt(index);
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
          style: const TextStyle(fontSize: 18.0),
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
            if (selected == MoreChoices.Remove) {
              list.removeTaskAt(index);
              //show that its been removed in snackbar
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Task removed"),
                duration: const Duration(seconds: 2),
              ));
            }
            if (selected == MoreChoices.Edit) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditTaskPage(index)));
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
          if (finished) {
            list.setFinishedAt(index, false);
          } else {
            list.setFinishedAt(index, true);
          }
        });
  }

} //end listview

