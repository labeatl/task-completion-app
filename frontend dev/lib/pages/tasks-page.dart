import 'package:flutter/material.dart';
import '../main.dart';

class TasksPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: Icon(Icons.graphic_eq),
                      onPressed: () {
                        /*...*/
                      },
                    ),
                  ),
                ),
                Container(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        /*...*/
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/login');},
                  child: new Text('Logout'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
