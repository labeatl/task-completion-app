import 'package:flutter/material.dart';
import '../main.dart';
import '../task.dart';

class TasksPage extends StatelessWidget {
  final List<Task> tasks = [
    Task(
        title: "Bike repair",
        description: "it is severly damaged",
        category: "physical repairments",
        et: 200,
        price: 100,
        location: "Oxford",
        date: DateTime.now()),
    Task(
        title: "Grocery sainsburys",
        description: "grocery for two weeks",
        category: "Grocery",
        et: 40,
        price: 150,
        location: "Oxford",
        date: DateTime.now()),
  ];

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
                      onPressed: () {
                        /*...*/
                      },
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
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
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
                                  icon: Icon(Icons.attach_money),
                                ),
                                Text(
                                  "price: £${task.price}",
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
                        margin: EdgeInsets.all(15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.location_on),
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
                                ),
                                Text(
                                  "${task.et} min.",
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
