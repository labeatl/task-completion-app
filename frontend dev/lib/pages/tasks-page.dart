import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/filters.dart' as prefix0;
import '../task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './filters.dart';

class TasksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TaskPageState();
}

//TODO REPORT HERE
var url =
    'http://167.172.59.89:5000/reporttask';
String reason = "Default Reason";

Future<void> reportTask() async {

  http.post(
    Uri.encodeFull("http://167.172.59.89:5000/reporttask"),
      body: {
        'task_id': '1',
        'reason': reason,
      }
  );

}


List data;
List<Task> tasks = [];

void updateTasks(String category) {
  var index = 0;
  while (index < tasks.length) {
    if (tasks[index].category != category) {
      tasks.remove(tasks[index]);
    } else {
      index++;
    }
  }
}

GoogleMapController mapController;

final LatLng _center = const LatLng(51.7520, -1.2577);

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

class TaskPageState extends State<TasksPage> {
  String _x;
  String authToken;
   TaskPageState() {
     _x = "Apply";

     getToken().then((val) => setState(() {
       authToken = val;
     }));
     print(authToken);
}

  Future<String> getToken() async {
     log("get token Worked");
    String test = await storage.read(key: "authToken");
    String bearer = 'Bearer ';
    test = '$bearer$test';
    print(test);
    print("GOTTOKEN");
    return test;

  }
  Future<String> getData() async {
    log('your message here');

    log('your message here' + authToken);

    http.Response response = await http.get(
      Uri.encodeFull("http://167.172.59.89:5000/tasks"),
      headers: {"Authorization": authToken, "Accept": "application/json"},
    );
    tasks = [];
    this.setState(() {
      data = json.decode(response.body);
    });
    var counter = 0;
    while (counter < data.length) {
      tasks.add(
        new Task(
          title: data[counter]["title"],
          description: data[counter]["description"],
          category: data[counter]["category"],
          et: data[counter]["et"],
          price: data[counter]["price"],
          location: data[counter]["location"],
          date: DateTime.now(),
        ),
      );
      counter++;
    }
  }




  Future<String> getFilteringTasks() async {
    http.Response response = await http.get(
      Uri.encodeFull("http://167.172.59.89:5000/filtering"),
      headers: {"Accept": "application/json"},
    );
    tasks = [];
    this.setState(() {
      data = json.decode(response.body);
    });
    var counter = 0;
    while (counter < data.length) {
      tasks.add(
        new Task(
          title: data[counter]["title"],
          description: data[counter]["description"],
          category: data[counter]["category"],
          et: data[counter]["et"],
          price: data[counter]["price"],
          location: data[counter]["location"],
          date: DateTime.now(),
        ),
      );
      counter++;
    }
  }

  Widget build(BuildContext context) {

    setState(() {
      getData();
    });

    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 220, 220, 100),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        onPressed: () {
                          getFilteringTasks();
                          Navigator.of(context)
                              .pushReplacementNamed('/filters');
                        },
                        icon: Icon(Icons.graphic_eq),
                        /*...*/
                      ),
                    ),
                  ),
                  Container(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            showSearch(
                                context: context, delegate: searchEngine());
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              getData();
                            });
                          }),
                    ),
                  ),
                ],
              ),
              Column(
                children: tasks.map((task) {
                  EdgeInsets.only(left: 20.0, right: 20.0);
                  return RaisedButton(
                    onPressed: () {
                      print(task.description);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              return AlertDialog(
                                content: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: 400,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        Text('Job Title:'),
                                        Text(task.title),
                                        Text(''),
                                        Text('Job Description:'),
                                        Text(task.description),
                                        Text(''),
                                        Text('Job Price:'),
                                        Text(task.price.toString()),
                                        Text(''),
                                        Text('Job Location:'),
                                        Text(task.location),
                                        Text(''),
                                        Text('Estimated Time (in minutes):'),
                                        Text(task.et.toString()),

                                        Image.network(
                                          'http://167.172.59.89:5000/imageUploadTask',
                                        ),
                                        Text(''),
                                        Container(
                                          height: 300,
                                          width: 350,
                                          child: GoogleMap(
                                            onMapCreated: _onMapCreated,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: _center,
                                              zoom: 13.0,
                                            ),
                                          ),
                                        ),
                                        FlatButton(
                                            onPressed: () {
                                                reportTask();
                                            },
                                            child: new Text("Report")),
                                        RaisedButton(
                                          onPressed: () {
                                            reportTask();
                                            setState(() {
                                               _x = "Applied";
                                            });
                                          },
                                          child: new Text(
                                            _x,
                                            style: TextStyle(
                                                color: Colors.blueAccent),
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: null,
                                    icon:
                                        Icon(Icons.title, color: Colors.black),
                                  ),
                                  Text(
                                    "${task.title}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    onPressed: null,
                                    icon: Icon(Icons.attach_money,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    "£${task.price}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 5, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.location_on,
                                        color: Colors.black),
                                    onPressed: null,
                                  ),
                                  Text(
                                    "${task.location}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.access_time,
                                      color: Colors.black,
                                    ),
                                    onPressed: null,
                                  ),
                                  Text(
                                    "${task.et} min",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Colors.blueGrey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                          child: Image.network(
                            'http://167.172.59.89:5000/imageUploadTask',
                          ),
//                          child: _selectedPicture != null
//                              ? Image.file(_selectedPicture)
//                              : Text("No Image Taken", textAlign: TextAlign.center),
//                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class searchEngine extends SearchDelegate<String> {
  List<String> reTasks = [
    "Bike Repair",
    "Gardening",
    "Tech repairs",
  ];

  List<String> allTasks = [
    "Bike Repairs",
    "Gardening",
    "Tech repairs",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {}

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? reTasks
        : allTasks.where((p) => p.startsWith(query)).toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          updateTasks(reTasks[index]);
          close(context, null);
        },
        title: Text(suggestionList[index]),
      ),
      itemCount: suggestionList.length,
    );
  }
}
