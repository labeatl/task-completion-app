import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FilterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new FilterPageState();
}

String dropdownValue = "Choose the Category";
RangeValues priceRange = RangeValues(0, 100);
RangeValues et_Range = RangeValues(0, 100);
RangeLabels labels = RangeLabels("0", "100");
var location;

class FilterPageState extends State<FilterPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: new Text("Task Filtering"),
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/tasks');
          },
          child: Icon(
            Icons.keyboard_arrow_left, // add custom icons also
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Card(
              margin: EdgeInsets.fromLTRB(5, 15, 5, 0),
              child: new Container(
                height: 48,
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
                    "Choose the Category",
                    "Gardening",
                    "Bike Repair",
                    "Deliveries"
                  ].map<DropdownMenuItem<String>>((String val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val, style: TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: TextFormField(
                decoration: InputDecoration(labelText: "Location"),
                onFieldSubmitted: (var val) {
                  location = val;
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
              child: new Text("Estimated Time"),
            ),
            RangeSlider(
              values: et_Range,
              min: 0,
              max: 100,
              labels: labels,
              onChanged: (RangeValues newRange) {
                setState(() {
                  if (newRange.end - newRange.start >= 20) {
                    et_Range = newRange;
                  } else {
                    if (et_Range.start == newRange.start) {
                      et_Range = RangeValues(et_Range.start, et_Range.start + 20);
                    } else {
                      et_Range = RangeValues(et_Range.end - 20, et_Range.end);
                    }
                  }
                  labels = RangeLabels(newRange.start.toString(), newRange.end.toString());
                });
              },
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: new Text("Price"),
            ),
            RangeSlider(
              values: priceRange,
              min: 0,
              max: 100,
              labels: labels,
              onChanged: (RangeValues newRange) {
                setState(() {
                  if (newRange.end - newRange.start >= 20) {
                    priceRange = newRange;
                  } else {
                    if (priceRange.start == newRange.start) {
                      priceRange = RangeValues(priceRange.start, priceRange.start + 20);
                    } else {
                      priceRange = RangeValues(priceRange.end - 20, priceRange.end);
                    }
                  }
                  labels = RangeLabels(newRange.start.toString(), newRange.end.toString());
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: () {
                  var url = 'http://167.172.59.89:5000/filtering';
                  http.post(url, body: {
                    'Category': dropdownValue,
                    'et_min': et_Range.start.toString(),
                    'et_max': et_Range.end.toString(),
                    'min_price': priceRange.start.toString(),
                    'max_price': priceRange.end.toString(),
                    'Location': location,
                  });
                  Navigator.of(context).pushReplacementNamed('/tasks');
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
