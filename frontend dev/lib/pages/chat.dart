import 'package:flutter/material.dart';
import './chatscreen.dart';


class ChatPage extends StatelessWidget {
  // This widget is the root of your application.
  @override

  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text("The Chat",),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.arrow_forward,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/home');
              // do something
            },
          )
        ],
      ),
        body: new ChatScreen()
    );
  }
