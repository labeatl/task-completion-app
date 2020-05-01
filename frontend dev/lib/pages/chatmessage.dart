import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class ChatMessage extends StatelessWidget {
  final String text;
  String name = "Anonymous";
// constructor to get text from textfield
  ChatMessage({
    this.text
  });

  Future<String> getName() async {
    http.Response response = await http.get(
      Uri.encodeFull("http://167.172.59.89:5000/getName"),
      headers: {"Accept": "application/json"},
    );
    name = json.decode(response.body);
    return name;
  }



  @override
  Widget build(BuildContext context) {
    getName();
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(
                backgroundImage: NetworkImage(
                  'http://167.172.59.89:5000/imageUpload',
                ),
              ),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(name, style: Theme.of(context).textTheme.subhead),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(text),

                )
              ],
            )
          ],
        )
    );
  }
}