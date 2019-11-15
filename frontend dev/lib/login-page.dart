import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: 800,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Card(
                  elevation: 5,
                  child: Container(
                    width: 50,
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(labelText: "username"),
                    ),
                  ),
                ),
                Card(
                  elevation: 5,
                  child: Container(
                    width: 100,
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      decoration: InputDecoration(labelText: "password"),
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                      textColor: Colors.deepPurpleAccent,
                      child: Text("Forgotten password?"),
                      onPressed: () {},
                    ),
                  ),
                ),
                Container(
                    child: FlatButton(
                      color: Colors.deepPurpleAccent,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.deepPurpleAccent,
                      onPressed: () {
                        /*...*/
                      },
                      child: Text(
                        "SIGN IN",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    )),
                Container(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FlatButton(
                      textColor: Colors.deepPurpleAccent,
                      child: Text(
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
                                            if (password != value) {
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
            )));
  }
}
