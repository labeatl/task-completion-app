import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 20),
              //We can remove left and right just leaving in case we need them to save time
              child: Text("Small yrofile summary fjgdgfkgdhf "
                  "fgofdgoif fgoihdofg"),
            ),
            Container(
              height: 200,
              child: GridView.count(
                shrinkWrap: true,
                // Create a grid with 2 columns. If you change the scrollDirection to
                // horizontal, this produces 2 rows.
                crossAxisCount: 2,
                // Generate 100 widgets that display their index in the List.
                children: List.generate(6, (index) {
                  print(index);
                  return Center(
                    child: Text(
                      'Skill $index',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  );
                }),
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
