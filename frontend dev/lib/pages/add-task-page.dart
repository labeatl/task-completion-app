import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateTask extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CreateTaskState();
  }
}

class _CreateTaskState extends State<CreateTask> {
  String dropdownValue = "Choose a Category";

  Widget build(BuildContext context) {
    final priceController = TextEditingController();
    final timeController = TextEditingController();
    final jobDescriptionController = TextEditingController();
    final locationController = TextEditingController();
    final jobTitleController = TextEditingController();
    DateTime now = new DateTime.now();

    return new Scaffold(
      body: new SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            new Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: new Container(
                width: 250,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: new TextFormField(
                  decoration: InputDecoration(labelText: "Job Title"),
                  controller: jobTitleController,
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: new Container(
                width: 250,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: new TextFormField(
                  decoration: InputDecoration(labelText: "Job Description"),
                  controller: jobDescriptionController,
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: new Container(
                width: 250,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: new TextFormField(
                  decoration: InputDecoration(labelText: "Estimated Time"),
                  controller: timeController,
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: new Container(
                width: 250,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: new TextFormField(
                  decoration: InputDecoration(labelText: "Price"),
                  controller: priceController,
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: new Container(
                width: 250,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: new TextFormField(
                  decoration: InputDecoration(labelText: "Location"),
                  controller: locationController,
                ),
              ),
            ),
            Row(
              children: <Widget>[
                new Card(
                  margin: EdgeInsets.all(10),
                  child: new Container(
                    height: 58,
                    padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      elevation: 5,
                      style: TextStyle(color: Colors.blueGrey),
                      underline: Container(
                        color: Colors.blueGrey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>[
                        "Choose a Category",
                        "Gardening",
                        "Bike Repair",
                        "Deliveries"
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value, style: TextStyle(fontSize: 16)),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Container(
                  height: 56,
                  margin: EdgeInsets.all(10),
                  child: FlatButton(
                    color: Colors.blueGrey,
                    child: Text(
                      "Submit",
                      style: TextStyle(fontSize: 15),
                    ),
                    textColor: Colors.white,
                    onPressed: () {
                      var url = 'http://51.140.92.250:5000/addtask';
                      print( {
                        'title': jobTitleController.text,
                        'description': jobDescriptionController.text,
                        'category': dropdownValue,
                        'et': timeController.text,
                        'price': priceController.text,
                        'location': locationController.text,

                      });
                      http.put(url, body: {
                        'title': jobTitleController.text,
                        'description': jobDescriptionController.text,
                        'category': dropdownValue,
                        'et': timeController.text,
                        'price': priceController.text,
                        'location': locationController.text,

                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
