import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/pages/tasks-page.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../task.dart';

class HomeContent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new HomeContentState();
}

GoogleMapController mapController;

final LatLng _center = const LatLng(51.7520, -1.2577);

void _onMapCreated(GoogleMapController controller) {
  mapController = controller;
}

class HomeContentState extends State<HomeContent> {
  List data;
  List<Task> tasks = [];
  String authToken;

    HomeContentState() {
      getToken().then((val) => setState(() {
        authToken = val;
      }));
    }


  Future<String> getToken() async {
    log("get token Worked");
    String test = await storage.read(key: 'authToken');
    String bearer = 'Bearer ';
    test = '$bearer$test';
    print(test);
    print("GOTTOKEN");
    return test;

  }

  Future<String> getData() async {
    http.Response response = await http.get(
      Uri.encodeFull("http://167.172.59.89:5000/tasks"),
      headers: {"Authorization": authToken, HttpHeaders.contentTypeHeader: "application/json"},
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

  @override
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
                children: <Widget>[
                  SizedBox(height: 50),
                  Container(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text("Welcome back!",
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 50),
              Row(children: <Widget>[
                Container(
                  child: Align(
                    child: Text("My tasks in progress",
                      style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                    ),

                  ),
                ),
              ]),
              SizedBox(height: 15),
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
              Row(
                children: <Widget>[
                  SizedBox(height: 70),
                  Container(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text("In My Area",
                        style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),
                      ),
                    ),
                  ),

                ],
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
