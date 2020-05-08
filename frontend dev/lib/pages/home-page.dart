import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home-content.dart';
import "./tasks-page.dart";
import "./profile-page.dart";
import "./add-task-page.dart";


class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedPage = 0;
  final _pageOptions = [
    HomeContent(),
    TasksPage(),
    CreateTask(),
    new Align(
      alignment: Alignment.center,
      child: Text(
        "This is the Training Page",
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 25,
        ),
      ),
    ),
    ProfilePage(),
  ];

  Widget build(BuildContext context) => new Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text("LEN Task Completion"),
        ),
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.blueGrey,
          currentIndex: _selectedPage,
          onTap: (int index) {
            setState(() {
              _selectedPage = index;
            });
          },

          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: Text(
                "Home",
                style: TextStyle(color: Colors.white),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.burst_mode,
                  color: Colors.white,
                ),
                title: Text(
                  "Tasks",
                  style: TextStyle(color: Colors.white),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.control_point,
                  color: Colors.white,
                ),
                title: Text(
                  "Add a task",
                  style: TextStyle(color: Colors.white),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.import_contacts,
                  color: Colors.white,
                ),
                title: Text(
                  "Training",
                  style: TextStyle(color: Colors.white),
                )),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.white,
                ),
                title: Text(
                  "Profile",
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      );
}
