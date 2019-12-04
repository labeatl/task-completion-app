import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProfilePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
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

                                            var url = 'http://51.140.92.250:5000/deleteaccount';

                                            http.put(url, body: {
                                              'email': email,
                                            });
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
    );
  }
}
