import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;


class AuthService {
  // Login
  Future<bool> login(String _email,String _password) async {
    var url = 'http://192.168.137.1:5000/login';

    var response = await http.post(url, body: {
      'email': _email,
      'password': _password
    });
    bool responseBool;
    //Conver the response to a bool
    if (response == 'success') {
      responseBool = true;
    }
    else {
      responseBool = false;
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