import 'package:flutter/material.dart';
import "../task.dart";
import "./tasks-page.dart";

class CreateTask extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CreateTaskState();
  }
}

class _CreateTaskState extends State<CreateTask> {
  String dropdownValue = "Choose a category";

  Widget build(BuildContext context) {
    final priceController = TextEditingController();
    final timeController = TextEditingController();
    final jobDescriptionController = TextEditingController();
    final locationController = TextEditingController();
    final jobTitleController = TextEditingController();

    return new Scaffold(
        body: new SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              new Card(
                elevation: 5,
                child: new Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  child: new TextFormField(
                    decoration: InputDecoration(labelText: "Job Title"),
                    controller: jobTitleController,
                  ),
                ),
              ),
              new Card(
                elevation: 5,
                child: new Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  child: new TextFormField(
                    decoration: InputDecoration(labelText: "Job Discription"),
                    controller: jobDescriptionController,
                  ),
                ),
              ),
              new Card(
                elevation: 5,
                child: new Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  child: new TextFormField(
                    decoration: InputDecoration(labelText: "Estimated Time"),
                    controller: timeController,
                  ),
                ),
              ),
              new Card(
                elevation: 5,
                child: new Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  child: new TextFormField(
                    decoration: InputDecoration(labelText: "Price"),
                    controller: priceController,
                  ),
                ),
              ),
              new Card(
                elevation: 5,
                child: new Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
                  child: new TextFormField(
                    decoration: InputDecoration(labelText: "Location"),
                    controller: locationController,
                  ),
                ),
              ),
              new Card(
                elevation: 5,
                child: new Container(
                  width: 250,
                  padding: EdgeInsets.all(10),
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
                      "Choose a category",
                      "Gardening",
                      "Bike Repair",
                      "Deliveries"
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
              FlatButton(
                child: Text("Submit"),
                textColor: Colors.blueGrey,
                onPressed: () {},
              ),
            ],
          ),
        ),
    );
  }
}
