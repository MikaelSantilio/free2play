import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProjectColors {
  static const Color primary = Color(0xFF4834D4);
  static const Color background = Color(0xFF121212);
  static const Color foreground = Colors.white;
  static const Color gray = Colors.white70;
  static final Color danger = Colors.red.shade700;
  static final Color success = Colors.green.shade500;
}

class Utils {
  static Future<Map<String, dynamic>> getConnectionText() async {
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

  static Future<bool> getConnectionStatus() async {
  // return false;
    try {
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      return true;
    } catch (e) {
      return false;
    }
  }
}


Future<Map<String, dynamic>> getConnectionText() async {
  // return {
  //       "text": "Offline",
  //       "color": Colors.red.shade700
  //     };
    try {
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
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


