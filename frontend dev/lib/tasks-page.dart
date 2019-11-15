import 'package:flutter/material.dart';

class TasksPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //asdasdasd
        child: Row(
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
      ),
    );
  }
}
