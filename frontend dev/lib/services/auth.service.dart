import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class AuthService {
  // Login
  Future<bool> login(String _email,String _password) async {
    var url = 'http://167.172.59.89:5000/login';
    var storage = getStorage(); //get storage with getter from main class

    http.Response response = await http.post(url, body: {
      'email': _email,
      'password': _password
    });
    bool responseBool;
    var data = json.decode(response.body);
    //Conver the response to a belool
    //print(response.body.runtimeType);
    print(data["status"]);
    if (data["status"] == 0) {
      print("Sorage data");
      print(data["authToken"]);
      print('Successful login');
      responseBool = true;
      print(data["userToken"]);

      await storage.write(key: "token", value: data["userToken"]);
      await storage.write(key: "authToken", value: data["authToken"]);

    }
    else {
      responseBool = false;
      print('Unsuccessful login');
    }

    return responseBool;
  }

  // Logout
  Future<void> logout() async {
    // Simulate a future for response after 1 second.
    await storage.write(key: "token", value: "");

    return await new Future<void>.delayed(
        new Duration(
            seconds: 1
        )
    );
  }

}