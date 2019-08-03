import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scopedModels/scoped_taskList.dart';
import '../models/taskInfo.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'newTaskView.dart';
import 'EditTaskView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
//import 'package:scheduled_notifications/scheduled_notifications.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';



enum MoreChoices { Edit, Remove }
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
class NotificationTry extends StatefulWidget{
  final TaskInfo _myNewTask;
  NotificationTry(this._myNewTask);

  @override
  _NotificationState createState() => _NotificationState(_myNewTask);
}
class _NotificationState extends State<NotificationTry>{
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final TaskInfo _myTask;
  _NotificationState(this._myTask);
  @override
  initState(){

    super.initState();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);

    print("inside stateful");

  }

  @override
  build(BuildContext context) {
    print("inside statful build");
    callNotification(context);


    return Container(width: 0,height: 0);


  }
  void callNotification(BuildContext context) async{
    await _showNotificationWithoutSound(_myTask);

    Navigator.pop(context);
    Navigator.pop(context);
  }


  Future<void> onSelectNotification(String payload) async{
    showDialog(context: context,
        builder: (_) => new AlertDialog(title: Text("Here is payload"),
          content: Text("Payload : $payload"),)
    );
  }
  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Ok'),
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SecondScreen(payload),
                ),
              );
            },
          )
        ],
      ),
    );
  }
  Future<void> _showNotificationWithoutSound(TaskInfo myTask) async {
    var scheduledNotificationDateTime = myTask.getDate().add(Duration(hours:
    -myTask.getDate().hour,minutes: -myTask.getDate().minute)).add(Duration(
      hours:myTask.getTime().hour,minutes: myTask.getTime().minute
    ));
//        .add(Duration(hours:
//      myTask.getTime().hour,minutes: myTask.getTime().minute));
    print(scheduledNotificationDateTime);
    print(myTask.getID());
    //DateTime.now().add(Duration(seconds: 10));
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your other channel id',
        'your other channel name',
        'your other channel description',
        //icon: 'secondary_icon',
        //sound: 'slow_spring_board',
        //largeIcon: 'sample_large_icon',
        //largeIconBitmapSource: BitmapSource.Drawable,
//      vibrationPattern: vibrationPattern,
//      enableLights: true,
//      color: const Color.fromARGB(255, 255, 0, 0),
//      ledColor: const Color.fromARGB(255, 255, 0, 0),
//      ledOnMs: 1000,
//      ledOffMs: 500);
        //playSound: true,
        //sound: ,
        //importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    );
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    print("before sched");

    await flutterLocalNotificationsPlugin.schedule(
        myTask.getID(),
        myTask.getTitle(),
        myTask.getDescription(),
        scheduledNotificationDateTime,
        platformChannelSpecifics

    );
    print("inside schedule");

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

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScopedTaskList>(
        builder: (context, child, model)
        => Scaffold(
          appBar: AppBar(
            title: Text('Task Manager'),
          ),
          body: _buildList(model),

          floatingActionButton:

            FloatingActionButton(
            onPressed: () {

              Navigator.push( context,
                MaterialPageRoute(builder: (context) => NewTaskPage(-1,model)),

            );



            },
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
        (info.getDescription() == null || info.getDescription() == " ") ? "" : info.getDescription() + '\n';
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

class SecondScreen extends StatefulWidget {
  final String payload;
  SecondScreen(this.payload);
  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen with payload: " + _payload),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
