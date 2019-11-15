import 'package:flutter/material.dart';
import "./tasks-page.dart";

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
  }

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
    Text("So what we smoke weed"),
    TasksPage(),
  ];

  Widget build(BuildContext context) => new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurpleAccent,
          title: Text("Task App"),
        ),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text("Home")),
            BottomNavigationBarItem(
                icon: Icon(Icons.burst_mode), title: Text("tasks")),
            BottomNavigationBarItem(
                icon: Icon(Icons.control_point), title: Text("Add a task")),
            BottomNavigationBarItem(
                icon: Icon(Icons.import_contacts), title: Text("Training")),
            BottomNavigationBarItem(
                icon: Icon(Icons.sentiment_very_satisfied),
                title: Text("Profile")),
          ],
        ),
      );
}
