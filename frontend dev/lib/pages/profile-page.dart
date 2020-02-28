import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:http/http.dart' as http;
import "../widgets/image_picker.dart";
import 'dart:io';

class ProfilePage extends StatefulWidget {
  State<StatefulWidget> createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _status = 'none';
  final _formKey = GlobalKey<FormState>();
  final sum = TextEditingController();
  List<Widget> skills = [];

  _ProfilePageState() {
    getSkills().then((val) => setState(() {
          skills = val;
        }));
  }

  String summary = "";
  bool chosen = true;
  bool ranThis = false;

  Widget build(BuildContext context) {
    Future<String> getSummary() async {
      http.Response response = await http.get(
        Uri.encodeFull("http://167.172.59.89:5000/getSummary"),
        headers: {"Accept": "application/json"},
      );
      String _summary = json.decode(response.body);
      summary = _summary.toString();
//        setState(() {
//
//        });
    }

    getSummary();

    getSkills();
    sum.text = summary;

    List<Widget> skillsList = [];
    Future<String> getData() async {
      http.Response response = await http.get(
        Uri.encodeFull("http://167.172.59.89:5000/postskills"),
        headers: {"Accept": "application/json"},
      );

      List data =
          json.decode(response.body); //only works when first changing type????
      var counter = 0;
      print(response.body);
      while (counter < data.length) {
        int id = data[counter]["id"];
        String name = data[counter]["name"];
        String description = data[counter]["description"];

        var aButton = new FlatButton(
            onPressed: () {
              var url = 'http://167.172.59.89:5000/adduserskill';

              http.put(url, body: {
                'userid': 1.toString(), //Change this
                'skill_id': id.toString(),
                'skillLevel': 10.toString(),
              });
              print("WORKS");
              //Conver the response to a bool
            },
            child: Text(
                name)); //TODO: Add send message to backend to add skill on click

        skillsList.add(aButton);

        counter++;
      }
    }

    getData();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Image_pick(),
            SizedBox(
              height: 25,
            ),
            Container(
              margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 20),
              //We can remove left and right just leaving in case we need them to save time
              child: Card(
                margin: EdgeInsets.fromLTRB(7, 4, 7, 4),
                color: Colors.blueGrey,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Container(
                                width: 300,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(top: 10.0),
                                        child: TextFormField(
                                          keyboardType: TextInputType.multiline,
                                          decoration: InputDecoration(
                                              hintText:
                                                  'Tell us something about yourself'),
                                          controller: sum,
                                          minLines: 1,
                                          maxLines: 8,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(10),
                                        child: RaisedButton(
                                          child: Text('Submit'),
                                          onPressed: () {
                                            var url =
                                                'http://167.172.59.89:5000/summary'; //Change URL
                                            print({
                                              'New Summary': sum.text,
                                            });
                                            http.post(url, body: {
                                              'Summary': sum.text,
                                            });
                                          },
                                        ),
                                      ),
                                    ]),
                              ),
                            );
                          });
                    },
                    child: new Text(
                      'User Summary',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 210,
              child: GridView.count(
                shrinkWrap: true,
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.

                children: skills,
              ),
            ),
            Row(

              children: <Widget>[
                Container(
                  width: 206,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(7, 4, 7, 0),
                    color: Colors.blueGrey,
                    child: FlatButton.icon(
                      color: Colors.blueGrey,
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                      ),
                      //`Icon` to display
                      label: Text(
                        'Edit Skills',
                        style: TextStyle(color: Colors.white),
                      ),
                      //`Text` to display

                      onPressed: () {
                        setState(() {});

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                //Put list of skill buttons here
                                title: Text("Add skills"),
                                content: Column(
                                  children:
                                      skillsList, //Can probably remove the method and directly put the list done jsut for testing
                                ),
                              );
                            });
                      }, //***********************************************
                    ),
                  ),
                ),
                Container(
                  width: 205,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(0, 4, 7, 0),
                    color: Colors.blueGrey,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        onPressed: () {},
                        child: new Text(
                          'Show task history',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 206,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(7, 4, 7, 4),
                    color: Colors.blueGrey,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/login');
                        },
                        child: new Text(
                          'Logout',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 205,
                  child: Card(
                    margin: EdgeInsets.fromLTRB(0, 4, 7, 4),
                    color: Colors.blueGrey,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: FlatButton(
                        onPressed: () {
                          String email, password;

                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Form(
                                    key: _formKey,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  labelText: "email address"),
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Please enter some text';
                                                }
                                                return null;
                                              },
                                              onSaved: (String val) {
                                                email = val;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: RaisedButton(
                                              child: Text("Submit"),
                                              onPressed: () {
                                                if (_formKey.currentState
                                                    .validate()) {
                                                  _formKey.currentState.save();

                                                  var url =
                                                      'http://167.172.59.89:5000/deleteaccount';

                                                  http.put(url, body: {
                                                    'email': email,
                                                  });
                                                  Navigator.of(context)
                                                      .pushReplacementNamed(
                                                          '/login');
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                        child: new Text(
                          'Delete the account',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List> getSkills() async {
    List<Widget> tempSkills = [];
    http.Response response = await http.get(
      Uri.encodeFull("http://167.172.59.89:5000/getuserskill"),
      headers: {"Accept": "application/json"},
    );

    List data =
        json.decode(response.body); //only works when first changing type????
    print(response.body);
    var counter = 0;
    while (counter < data.length) {
      var skillId = data[counter]["skill_id"];

      //print("Should make widget" + skillId.toString());
      //var containerSkill = new Container(padding: EdgeInsets.all(8), child: Text(skillId), color: Colors.teal[100]);
      var containerSkill = new Text(skillId);

      tempSkills.add(containerSkill);

      //eCtrl.clear();     // Clear the Text area
      counter++;
    }

    print("Skills : ");
    print(skills);

    return tempSkills;
  }
}
