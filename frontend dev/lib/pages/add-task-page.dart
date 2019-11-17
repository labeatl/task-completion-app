import 'package:flutter/material.dart';

class CreateTask extends StatefulWidget {
  State<StatefulWidget> createState() {
    return CreateTaskState();
  }
}

class CreateTaskState extends State<CreateTask> {
  final _formKey = GlobalKey<FormState>();

  String dropdownValue = "Choose a category";

  Widget build(BuildContext context) {
    final priceController = TextEditingController();
    final timeController = TextEditingController();
    final jobDiscriptionController = TextEditingController();
    final locationController = TextEditingController();
    final jobTitleController = TextEditingController();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Post Your Task'),
        ),
        body: SingleChildScrollView(
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
                    controller: jobDiscriptionController,
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
                    style: TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      color: Colors.deepPurpleAccent,
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
                textColor: Colors.deepPurpleAccent,
                onPressed: () {
                print(dropdownValue);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
