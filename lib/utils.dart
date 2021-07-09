import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


Future<Map<String, dynamic>> getConnectionText() async {
  // return {
  //       "text": "Offline",
  //       "color": Colors.red.shade700
  //     };
    try {
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      // print(response);
      return {
        "text": "Online",
        "color": Colors.green.shade500
      };
    } catch (e) {
      return {
        "text": "Offline",
        "color": Colors.red.shade700
      };
    }
  }


Future<bool> getConnectionStatus() async {
  // return false;
    try {
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      // print(response);
      return true;
    } catch (e) {
      return false;
    }
  }


