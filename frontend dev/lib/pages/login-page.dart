import 'package:flutter_app/pages/tasks-page.dart';
import '../main.dart';
//import '../terms.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AuthFormType { reset }

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _status = 'no-action';
  bool password_show = true;
  final username = TextEditingController();
  final password = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  _LoginPageState() {
   getToken();
}

  Future<void> getToken() async {
    String token =  await storage.read(key: "token");
    setState(() => this._status = "loading");
    appAuth
        .login(token, "")
        .then((result) {
      print(token);
      if (result) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
      else {
        print("Failed");
      }
    });
  }



  Widget build(BuildContext context) => new Scaffold(
        body: SingleChildScrollView(
          child: new Container(
            height: 800,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 65,
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                  child: new Card(
                    elevation: 5,
                    child: new Container(
                      padding: EdgeInsets.all(10),
                      child: new TextField(
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'email',
                          filled: true,
                        ),
                        controller: username,
                      ),
                    ),
                  ),
                ),
                new Stack(
                    alignment: const Alignment(1.0, 1.0),
                    children: <Widget>[
                      Container(
                        height: 65,
                        margin: EdgeInsets.fromLTRB(8, 4, 8, 10),
                        child: new Card(
                          elevation: 5,
                          child: new Container(
                            padding: EdgeInsets.all(10),
                            child: new TextField(
                              controller: password,
                              obscureText: password_show,
                              decoration: InputDecoration(
                                hintText: 'password',
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                      new Positioned(
                        top: 13,
                        right: 14,

                        child: IconButton(
                            icon: Icon(
                              password_show
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              semanticLabel: password_show
                                  ? 'hide password'
                                  : 'show password',
                            ),
                            onPressed: () {
                              setState(() {
                                password_show ^= true;
                                //print("Icon button pressed! state: $_passwordVisible"); //Confirmed that the _passwordVisible is toggled each time the button is pressed.
                              });
                            }),
                      ),
                    ]),
                new Container(
                  child: new Align(
                    alignment: Alignment.bottomRight,
                    child: new FlatButton(
                      textColor: Colors.blueGrey,
                      child: new Text("Forgotten password?"),
                      onPressed: () {
                        Navigator.of(context)
                            .pushReplacementNamed('/passwordReset');
                      },
                    ),
                  ),
                ),
                new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: Colors.blueGrey,
                  ),
                  margin: EdgeInsets.fromLTRB(8, 4, 8, 130),
                  child: new FlatButton(
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.black,
                    padding: EdgeInsets.all(8.0),
                    splashColor: Colors.blueGrey,
                    child: new Text(
                      "LOG IN",
                      style: TextStyle(fontSize: 20.0),
                    ),
                    onPressed: () {
                      setState(() => this._status = "loading");
                      //Replace the two stringsi nlogin() with email and password
                      appAuth
                          .login(username.text, password.text)
                          .then((result) {
                        print(username.text);
                        if (result) {
                          Navigator.of(context).pushReplacementNamed('/home');
                        } else {
                          setState(() => this._status = 'rejected');
                        }
                      });
                    },
                  ),
                ),
                new Container(
                  child: new Align(
                    alignment: Alignment.bottomCenter,
                    child: new FlatButton(
                      textColor: Colors.blueGrey,
                      child: new Text(
                        "Create Account",
                        style: TextStyle(fontSize: 17),
                      ),
                      onPressed: () {
                        //The below strings store the form data entered.
                        String name, surName, email, password, confirmPassword;
                        bool _isChecked = false;

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (context, setState) {
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
                                                    labelText: "First Name"),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter some text';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String val) {
                                                  name = val;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Surname"),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter some text';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String val) {
                                                  surName = val;
                                                },
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: "Email Address"),
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
                                              padding: EdgeInsets.all(10.0),
                                              child: TextFormField(
                                                obscureText: true,
                                                //Make this input hidden
                                                decoration: InputDecoration(
                                                    labelText: "Password"),
                                                validator: (value) {
                                                  password = value;
                                                  if (value.isEmpty) {
                                                    return 'Please enter some text';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String val) {
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
                                                    labelText:
                                                        "Confirm Password"),
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Please enter some text';
                                                  } else if (value.compareTo(
                                                          password) !=
                                                      0) {
                                                    return 'Passwords do not match';
                                                  }
                                                  return null;
                                                },
                                                onSaved: (String val) {
                                                  confirmPassword = val;
                                                },
                                              ),
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: new InkWell(
                                                    child: Text(
                                                        "Terms and Conditions"),
                                                    onTap: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              content:
                                                                  Container(
                                                                width: 300,
                                                                height: 600,
                                                                child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: <
                                                                        Widget>[
                                                                      Padding(
                                                                        padding:
                                                                            EdgeInsets.only(top: 10.0),
                                                                        child:
                                                                            new Text(
                                                                          "The follwing is the terms and conditions",
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                  ),
                                                ),
                                                new Checkbox(
                                                    value: _isChecked,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        _isChecked =
                                                            !_isChecked;
                                                      });
                                                    }),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: RaisedButton(
                                                child: Text("Submit"),
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _formKey.currentState
                                                        .save();

                                                    var url =
                                                        'http://167.172.59.89:5000/signup';
                                                    print({
                                                      'name': name,
                                                      'surName': surName,
                                                      'email': email,
                                                      'password': password
                                                    });
                                                    http.put(url, body: {
                                                      'name': name,
                                                      'surName': surName,
                                                      'email': email,
                                                      'password': password
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
                                },
                              );
                            });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
