import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../main.dart';
import '../task.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Task> tasks = [];
  List data;
  Future<List> getTasks() async {
    tasks = [];
    http.Response response = await http.get(
      Uri.encodeFull("http://167.172.59.89:5000/postUserTasks"),
      headers: {"Accept": "application/json"},
    );
    data = json.decode(response.body);
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
          id: data[counter]["id"],
          date: DateTime.now(),
        ),
      );
      counter++;
      print(tasks.length);
    }
    return tasks;
  }
   _HistoryPageState() {

     getTasks().then((val) => setState(() {
       tasks = val;
     }));



   }
  Widget build(BuildContext context) {


    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Task History"),
      ),
      backgroundColor: Colors.white,

      body: Container(
        height: 300,
        width: (MediaQuery.of(context).size.width),
        child: SingleChildScrollView(
          child: Column(
            children: tasks.length != 0
                ? tasks.map((task) {

                    return RaisedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
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
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(0, 5, 20, 5),
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
                                            fontSize: 14,
                                            color: Colors.blueGrey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        onPressed: () {
                          final priceController = TextEditingController();
                          priceController.text = task.price.toString();
                          final timeController = TextEditingController();
                          timeController.text = task.et.toString();
                          final jobDescriptionController =
                              TextEditingController();
                          jobDescriptionController.text = task.description;
                          final locationController = TextEditingController();
                          locationController.text = task.location;
                          final jobTitleController = TextEditingController();
                          jobTitleController.text = task.title;
                          final dropdown = TextEditingController();
                          dropdown.text = task.category;
                          final Id = task.id;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              new Text("Category of the task:"),
                                              new DropdownButton<String>(
                                                value: dropdown.text,
                                                elevation: 5,
                                                style: TextStyle(
                                                    color: Colors.blueGrey),
                                                underline: Container(
                                                  color: Colors.blueGrey,
                                                ),
                                                onChanged: (String newValue) {
                                                  setState(() {
                                                    dropdown.text = newValue;
                                                  });
                                                },
                                                items: <String>[
                                                  "Gardening",
                                                  "Bike Repair",
                                                  "Deliveries"
                                                ].map<DropdownMenuItem<String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value,
                                                    child: Text(value,
                                                        style: TextStyle(
                                                            fontSize: 16)),
                                                  );
                                                }).toList(),
                                              ),
                                              new TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Job title"),
                                                controller: jobTitleController,
                                              ),
                                              new TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Job desc"),
                                                controller:
                                                    jobDescriptionController,
                                              ),
                                              new TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Time"),
                                                controller: timeController,
                                              ),
                                              new TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Price"),
                                                controller: priceController,
                                              ),
                                              new TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Location"),
                                                controller: locationController,
                                              ),
                                              RaisedButton(
                                                onPressed: () {
//                                        _upload();
//                                        String fileName = _storedImage.path.split("/").last;

                                                  var url =
                                                      'http://167.172.59.89:5000/tReplace';
                                                  http.put(url, body: {
                                                    'title':
                                                        jobTitleController.text,
                                                    'description':
                                                        jobDescriptionController
                                                            .text,
                                                    'category': dropdown.text,
                                                    'et': timeController.text,
                                                    'price':
                                                        priceController.text,
                                                    'location':
                                                        locationController.text,
//                                          'picture': fileName,
                                                    'id': Id.toString(),
                                                  });
                                                },
                                                child: Text('Submit'),
                                              ),
                                              RaisedButton(
                                                onPressed: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {

                                                        return AlertDialog(
                                                            content: SingleChildScrollView(
                                                            child: Container(
                                                            child: Column(
                                                              children: <Widget>[
                                                                new Text('Are you sure you wish to delete this task'),
                                                                new Row(
                                                                  children: <Widget>[
                                                                    new RaisedButton(onPressed: (){
                                                                      var url =
                                                                          'http://167.172.59.89:5000/tDelete';
                                                                      http.put(url, body: {
                                                                        'id': Id.toString(),
                                                                      });
                                                                    },
                                                                    child: Text('Yes'),
                                                                    ),
                                                                    new RaisedButton(onPressed: (){Navigator.pop(context);
                                                                    },
                                                                      child: Text('No'),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],

                                                            )))
                                                        );
                                                      });
                                                },
                                                child: Text('Delete'),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              });
                        },
                      );
                  }).toList()
                : <Widget>[
                    Text("No Task history currently"),
                    RaisedButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Text('Back'),
                    )
                  ],

          ),
        ),
      ),
    );
  }
}
