import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../main.dart';
import '../task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class TasksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TaskPageState();
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

class TaskPageState extends State<TasksPage> {

  Future<String> getData() async {
    http.Response response = await http.get(
      Uri.encodeFull("http://167.172.59.89:5000/tasks"),
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

  String _x = "Apply";

  @override
  void initState() {
    this.getData();
  }

  Widget build(BuildContext context) {
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
                                  height: 300,
                                  width: 350,
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
                                        RaisedButton(
                                          onPressed: () {
                                            setState(() {
                                              _x = "Applied";
                                            });
                                          },
                                          child: new Text(
                                            _x,
                                            style:
                                                TextStyle(color: Colors.blueAccent),
                                          ),
                                        )
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
                                    onPressed: () {},
                                    icon: Icon(Icons.title),
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
                                    onPressed: () {},
                                    icon: Icon(Icons.attach_money),
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
                                    icon: Icon(Icons.location_on),
                                    onPressed: () {},
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
                                    icon: Icon(Icons.access_time),
                                    onPressed: () {},
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
