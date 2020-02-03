import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class AuthService {
  // Login
  Future<bool> login(String _email,String _password) async {
    var url = 'http://167.172.59.89:5000/login';

    var response = await http.post(url, body: {
      'email': _email,
      'password': _password
    });
    bool responseBool;
    //Conver the response to a bool
    print(response.body.runtimeType);
    if (int.parse(response.body) == 0) {
      print('Successful login');
      responseBool = true;
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