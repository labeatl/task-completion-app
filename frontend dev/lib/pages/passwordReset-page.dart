import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';

enum AuthFormType { reset }

class PasswordReset extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _passwordResetState();
}

class _passwordResetState extends State<PasswordReset> {
  String _status = 'no-action';
  String _warning = "blla blla";
  double opac = 0.0;
  final email = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) => new Scaffold(
        body: new Container(
          height: 1800,
          child: SafeArea(
            child: SingleChildScrollView(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  new Opacity(
                    opacity: opac,
                    child: Container(
                      color: Colors.amberAccent,
                      width: double.infinity,
                      padding: EdgeInsets.all(8.0),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 180),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(Icons.error_outline),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              _warning,
                              maxLines: 3,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  opac = 0.0;
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 65,
                    margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: new Card(
                      elevation: 5,
                      child: new Container(
                        padding: EdgeInsets.all(10),
                        child: new TextField(
                          autofocus: true,
                          decoration: InputDecoration(labelText: "email"),
                          controller: email,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 2, 10, 0),
                    child: RaisedButton(
                        child: Text("Submit"),
                        onPressed: () {
                          print("Password reset email sent");
                          _warning = "A password reset link has been sent to " +
                              email.text;
                          setState(() {
                            opac = 1.0;
                          });
                        }),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 200),
                    child: new Align(
                      alignment: Alignment.center,
                      child: FlatButton(
                          child: Text(
                            "Return to Sign In",
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.grey),
                          ),
                          onPressed: () {
                            Navigator.of(context)
                                .pushReplacementNamed('/login');
                          }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
