import 'package:flutter/material.dart';
import 'package:flutter_app/pages/tasks-page.dart';
import "./pages/login-page.dart";
import "./pages/home-page.dart";
import "./services/auth.service.dart";


AuthService appAuth = new AuthService();

void main() async {
  // Set default home.
  Widget _defaultHome = new LoginPage();



  // Run app!
  runApp(new MaterialApp(
    title: 'App',
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      // Set routes for using the Navigator.
      '/home': (BuildContext context) => new HomePage(),
      '/login': (BuildContext context) => new LoginPage(),
      '/tasks': (BuildContext context) => new TasksPage(),
    },
  ));
}
