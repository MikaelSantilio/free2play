import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

mixin ConnectionView {
  Future<Map<String, dynamic>> getConnectionText() async {
    try {
      final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
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
}


