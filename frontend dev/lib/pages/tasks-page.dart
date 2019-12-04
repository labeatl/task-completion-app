import 'package:flutter/material.dart';
import '../main.dart';
import '../task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TasksPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TaskPageState();
}

class TaskPageState extends State<TasksPage> {

  List<Task> tasks = [
    new Task(
        title: "Bike Repair",
        description: "severly damaged",
        category: "repairs",
        et: 100,
        price: 150,
        location: "Oxford",
        date: DateTime.now()),
    new Task(
        title: "Grocery sainsburys",
        description: "grocery for two weeks",
        category: "Grocery",
        et: 40,
        price: 150,
        location: "Oxford",
        date: DateTime.now()),
  ];


  Future<String> getData() async {
    http.Response response = await http.get(
      Uri.encodeFull("http://51.140.92.250:5000/tasks"),
      headers: {
        "Accept": "application/json"
      },
    );
    print(response.body);
    List data = json.decode(response.body);
    print(data[0]["et"]);
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(220, 220, 220, 100),
      body: Container(
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
                      onPressed: () {
                        /*...*/
                      },
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: getData,
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: tasks.map((task) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 0, 10),
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
                                      fontSize: 16,
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
                                      fontSize: 16,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 40, 20),
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
                                      fontSize: 17,
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
                                      fontSize: 16,
                                      color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
