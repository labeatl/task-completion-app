import 'package:flutter/material.dart';
import 'package:flutter_app/pages/passwordReset-page.dart';
import 'package:flutter_app/pages/tasks-page.dart';
import "./pages/login-page.dart";
import "./pages/home-page.dart";
import "./pages/filters.dart";
import "./services/auth.service.dart";
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



AuthService appAuth = new AuthService();
final storage = new FlutterSecureStorage();

FlutterSecureStorage  getStorage() {
  return storage;
}
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
      '/passwordReset': (BuildContext context) => new PasswordReset(),
      '/filters': (BuildContext context) => new FilterPage(),
    },
  ));
}
