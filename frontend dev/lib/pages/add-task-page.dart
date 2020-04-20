import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as syspath;
import 'package:path/path.dart' as path;
import "./profile-page.dart";

class CreateTask extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _CreateTaskState();
  }
}

class _CreateTaskState extends State<CreateTask> {
  String dropdownValue = "Choose a Category";
  File _pickedImage;

  File _storedImage;

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: FlatButton.icon(
                      icon: Icon(Icons.image),
                      label: Text(" Gallery"),
                    ),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8),
                  ),
                  GestureDetector(
                    child: FlatButton.icon(
                        icon: Icon(Icons.camera), label: Text(" Camera")),
                    onTap: () {
                      _takePicture(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _openGallery(BuildContext context) async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = imageFile;
    });
    Navigator.of(context).pop();
  }

  Future<void> _takePicture(BuildContext context) async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxWidth: 600,
    );
    setState(() {
      _storedImage = imageFile;
    });
    Navigator.of(context).pop();
    final appDir = await syspath.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final savedImage = await imageFile.copy("${appDir.path}/${fileName}");
  }

  void _upload() {
    if (_storedImage == null) return;
    String base64Image = base64Encode(_storedImage.readAsBytesSync());
    String fileName = _storedImage.path.split("/").last;
    var url = 'http://167.172.59.89:5000/imageUploadTask';
    http.post(url, body: {
      "image": base64Image,
      "name": fileName,
    }).then((res) {
      print(res.statusCode);
    }).catchError((err) {
      print(err);
    });
  }

  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

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
            Row(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                  ),
                  margin: EdgeInsets.fromLTRB(20, 15, 35, 5),
                  child: _storedImage != null
                      ? Image.file(_storedImage)
                      : Text(
                          "No Image Taken",
                          textAlign: TextAlign.center,
                        ),
                  alignment: Alignment.center,
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FlatButton.icon(
                    icon: Icon(Icons.camera),
                    label: Text("Take Picture"),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      _showChoiceDialog(context);
                    },
                  ),
                ),
              ],
            ),
            new Card(
              margin: EdgeInsets.fromLTRB(10, 25, 10, 10),
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
            new Card(
              margin: EdgeInsets.fromLTRB(10, 7.5, 10, 7.5),
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
              margin: EdgeInsets.fromLTRB(10, 7.5, 10, 7.5),
              elevation: 5,
              child: new Container(
                width: 250,
                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                child: new TextFormField(
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(labelText: "Job Description"),
                  controller: jobDescriptionController,
                  minLines: 1,
                  maxLines: 2,
                ),
              ),
            ),
            new Card(
              margin: EdgeInsets.fromLTRB(10, 7.5, 10, 7.5),
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
              margin: EdgeInsets.fromLTRB(10, 7.5, 10, 7.5),
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
              margin: EdgeInsets.fromLTRB(10, 7.5, 10, 7.5),
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
            Container(
              height: 56,
              margin: EdgeInsets.fromLTRB(10, 7.5, 10, 7.5),
              child: FlatButton(
                color: Colors.blueGrey,
                child: Text(
                  "Submit",
                  style: TextStyle(fontSize: 15),
                ),
                textColor: Colors.white,
                onPressed: () {
                  _upload();
                  String fileName = _storedImage.path.split("/").last;
                  var url = 'http://167.172.59.89:5000/addtask';
                  http.put(url, body: {
                    'title': jobTitleController.text,
                    'description': jobDescriptionController.text,
                    'category': dropdownValue,
                    'et': timeController.text,
                    'price': priceController.text,
                    'location': locationController.text,
                    'picture': fileName,
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
