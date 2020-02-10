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

  String summary;
  bool chosen = true;
  List<Widget> skills = [];
  bool ranThis = false;
    Widget build(BuildContext context) {

      Future<List> getSkills() async {
          http.Response response = await http.get(
          Uri.encodeFull("http://167.172.59.89:5000/getuserskill"),
          headers: {"Accept": "application/json"},
        );

        List data = json.decode(response
            .body); //only works when first changing type????
        var counter = 0;
        print(response.body);
            while (counter < data.length) {
          int skillId = data[counter]["skill_id"];
          int skilllevel = data[counter]["skilllevel"];
          var containerSkill = new Container(child: Text("Programming" + skilllevel.toString()));
          skills.add(containerSkill);

          //eCtrl.clear();     // Clear the Text area
          counter++;
        }





          return skills;
      }
      Future<String> getSummary() async {
        http.Response response = await http.get(
          Uri.encodeFull("http://167.172.59.89:5000/getSummary"),
          headers: {"Accept": "application/json"},
        );
        summary = json.decode(response.body);
        return summary;
      }

    getSkills();


     if(chosen == true) {
       setState(() {});
       chosen = false;
       print('chosen');

     }


      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Image_pick(),
              SizedBox(height: 25,),
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
                        getSummary();
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
                                                labelText: summary),
                                            controller: sum,
                                            minLines: 1,
                                            maxLines: 8,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: RaisedButton(
                                            child: Text('Submit'),
                                            onPressed: () {
                                              var url =
                                                  'http://167.172.59.89:5000/summary';   //Change URL
                                              print({
                                                'New Summary': sum.text,
                                              });
                                              http.post(url, body: {
                                                'Summary': sum.text,
                                              });
                                            },
                                          ),
                                        ),

                                      ]
                                  ),
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
                height: 200,
                child: GridView.count(
                  shrinkWrap: true,
                  // Create a grid with 2 columns. If you change the scrollDirection to
                  // horizontal, this produces 2 rows.
                  crossAxisCount: 2,
                  // Generate 100 widgets that display their index in the List.


                  children: skills,

                ),
              ),
              Container(
                child: FlatButton.icon(
                  color: Colors.blueGrey,
                  icon: Icon(Icons.edit), //`Icon` to display
                  label: Text('Edit Skills'), //`Text` to display

                  onPressed: () {
                    List<Widget> skillsList = [];
                    Future<String> getData() async {
                      http.Response response = await http.get(
                        Uri.encodeFull("http://167.172.59.89:5000/postskills"),
                        headers: {"Accept": "application/json"},
                      );

                      List data = json.decode(response
                          .body); //only works when first changing type????
                      var counter = 0;
                      print(response.body);
                      while (counter < data.length) {
                        int id = data[counter]["id"];
                        String name = data[counter]["name"];
                        String description = data[counter]["description"];


                        var aButton = new FlatButton(
                            onPressed: () {
                              print("dfgdshriohghiuhgiu");


                              var url = 'http://167.172.59.89:5000/adduserskill';


                              http.put(url, body: {
                                'usrid': 1.toString(), //Change this
                                'skill_id': 1.toString(),
                                'skillLevel': 10.toString(),
                              });
                              print("WORKS");
                              //Conver the response to a bool
                            },

                            child: Text(
                                name)); //TODO: Add send message to backend to add skill on click
                        setState(() {
                          skillsList.add
                            (aButton);
                        });
                          counter++;

                      }
                    }
                    setState(() {
                      getData();
                    });

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
              Container(
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
                child: Card(
                  margin: EdgeInsets.fromLTRB(7, 0, 7, 10),
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
        ),
      );
    }
  }