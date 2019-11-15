import '../main.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _status = 'no-action';

  final _formKey = GlobalKey<FormState>();


  Widget build(BuildContext context) =>
      new Scaffold(
        body: new Container(
          height: 800,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Card(
                elevation: 5,
                child: new Container(
                  width: 50,
                  padding: EdgeInsets.all(10),
                  child: new TextField(
                    decoration: InputDecoration(labelText: "username"),
                  ),
                ),
              ),
              new Card(
                elevation: 5,
                child: new Container(
                  width: 100,
                  padding: EdgeInsets.all(10),
                  child: new TextField(
                    decoration: InputDecoration(labelText: "password"),
                  ),
                ),
              ),
              new Container(
                child: new Align(
                  alignment: Alignment.bottomRight,
                  child: new FlatButton(
                    textColor: Colors.deepPurpleAccent,
                    child: new Text("Forgotten password?"),
                    onPressed: () {},
                  ),
                ),
              ),
              new Container(
                  child: new FlatButton(
                    color: Colors.deepPurpleAccent,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.deepPurpleAccent,
                    child: new Text(
                      "LOG IN",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      setState(() => this._status = "loading");
                      appAuth.login().then((result) {
                        if (result) {
                          Navigator.of(context).pushReplacementNamed(
                              '/home');
                        } else {
                          setState(() => this._status = 'rejected');
                        }
                      });
                    },
                  )),
              new Container(
                child: new Align(
                  alignment: Alignment.bottomCenter,
                  child: new FlatButton(
                    textColor: Colors.deepPurpleAccent,
                    child: new Text(
                      "Create Account",
                      style: TextStyle(fontSize: 17),
                    ),
                    onPressed: () {
                      //The below strings store the form data entered.
                      String name, surName, email, password, confirmPassword;
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    TextFormField(
                                      decoration:
                                      InputDecoration(labelText: "name"),
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onSaved:(String val){
                                        name = val;
                                      },
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                            labelText: "surname"),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter some text';
                                          }

                                          return null;
                                        },
                                        onSaved:(String val){
                                          surName = val;
                                        },
                                      ),
                                    ),
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
                                        onSaved:(String val){
                                          email = val;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        obscureText: true,
                                        //Make this input hidden
                                        decoration: InputDecoration(
                                            labelText: "password"),
                                        validator: (value) {
                                          password = value;
                                          if (value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        onSaved:(String val){
                                          password = val;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: TextFormField(
                                        obscureText: true,
                                        //Make this input hidden

                                        decoration: InputDecoration(
                                            labelText: "Confirm Password"),
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          else if (value.compareTo(password) != 0) {
                                            return 'Passwords do not match';
                                          }
                                          return null;
                                        },
                                        onSaved:(String val){
                                          confirmPassword = val;
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: RaisedButton(
                                        child: Text("Submit"),
                                        onPressed: () {
                                          if (_formKey.currentState
                                              .validate()){
                                            _formKey.currentState.save();

                                            var jsonData = {
                                              'name':  name,
                                              'surName':  surName,
                                              'email':  email,
                                              'password': password

                                            };


                                          }

                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}

