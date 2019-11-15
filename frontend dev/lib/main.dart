import 'package:flutter/material.dart';
import "./login-page.dart";
import "./tasks-page.dart";

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  int _selectedPage = 0;
  final _pageOptions = [LoginPage(), TasksPage()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
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
      ),
    );
  }
}
