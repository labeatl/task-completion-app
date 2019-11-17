import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
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
                  onPressed: () {},
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
