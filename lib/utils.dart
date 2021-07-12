import 'package:flutter/material.dart';
import 'package:free2play/db_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';

class API {
  static String herokuUrlBase = "https://free2play-api.herokuapp.com/api/";
  static String freeToGameUrlBase = "https://free2play-api.herokuapp.com/api/";
  static Future<Map<String, String>> getHeaders() async {
    final String token = await getToken();
    return {
      "Authorization": "Token $token"
    };
  }

  static Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  static Future<Map<String, dynamic>> loginRequest(String username, String password) async {
    String url = "https://free2play-api.herokuapp.com/auth-token/";
    final bool connectionStatus = await getConnectionStatus();
    Map<String, dynamic> result = {
      "status": false,
      "detail": "Não foi encontrada conexão.",
    };

    if (connectionStatus) {
      final body = {"username": username, "password": password};
      final response = await http.post(Uri.parse(url), body: body);
      final parsedJson = jsonUtf8Decode(response.bodyBytes);
      if (response.statusCode == 200) {
        result["status"] = true;
        result["detail"] = parsedJson["token"];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', parsedJson["token"]);
      } else {
        result["status"] = false;
        result["detail"] = parsedJson["non_field_errors"][0];
      }
      return result;
    }
    return result;
  }

  static dynamic jsonUtf8Decode(Uint8List bodyBytes, {Object? Function(Object?, Object?)? reviver}) {
    String sourceUtf8 = const Utf8Decoder().convert(bodyBytes);
    return jsonDecode(sourceUtf8, reviver: reviver);
  }
}

class ProjectColors {
  static const Color primary = Color(0xFF4834D4);
  static const Color background = Color(0xFF121212);
  static const Color foreground = Colors.white;
  static const Color gray = Colors.white70;
  static final Color danger = Colors.red.shade700;
  static final Color success = Colors.green.shade500;
  static Color getWhiteRGBO({double opacity = 0.45}) {
    return Color.fromRGBO(255, 255, 255, opacity);
  }
}

class Utils {

  static Future<Map<String, dynamic>> getConnectionText() async {
    final status = await getConnectionStatus();
    if (status) {
      return {"text": "Online", "color": ProjectColors.success};
    }
    return {"text": "Offline", "color": ProjectColors.danger};
  }

  static Future<bool> getConnectionStatus() async {
    // return false;
    try {
      await http.get(Uri.parse("https://jsonplaceholder.typicode.com/users"));
      await syncDatabases();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> syncDatabases() async {
    Map<String, String> headers = await API.getHeaders();
    final db = await getDatabase();
    const tableName = "syncQueue";
    final queue = await syncQueueQuery(db, tableName);
    queue.sort((a, b) => a.id.compareTo(b.id));

    http.Response response;
    for (var item in queue) {
      if (item.method.toUpperCase() == "PUT") {
        response = await http.put(Uri.parse(item.url), headers: headers);
      } else {
        response = await http.delete(Uri.parse(item.url), headers: headers);
      }
      if (response.statusCode == 204) {
        await deleteRow(tableName, item.id, db);
      }
    }
  }
}

Future<Map<String, dynamic>> getConnectionText() async {
  return await Utils.getConnectionText();
}

Future<bool> getConnectionStatus() async {
  return await Utils.getConnectionStatus();
}


