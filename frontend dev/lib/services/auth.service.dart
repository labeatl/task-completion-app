import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class AuthService {
  // Login
  Future<bool> login(String _email,String _password) async {
    var url = 'http://167.172.59.89:5000/login';

    http.Response response = await http.post(url, body: {
      'email': _email,
      'password': _password
    });
    bool responseBool;
    var data = json.decode(response.body);
    //Conver the response to a bool
    //print(response.body.runtimeType);
    print(response.body);
    print(data[0]);
    if (data[0] == 0) {
      print('Successful login');
      responseBool = true;
      print(data[1]);
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
    return await new Future<void>.delayed(
        new Duration(
            seconds: 1
        )
    );
  }
}