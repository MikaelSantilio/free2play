import 'package:flutter/material.dart';
import 'package:free2play/db_test.dart';
import 'package:http/http.dart' as http;

class API {
  static String herokuUrlBase = "https://free2play-api.herokuapp.com/api/";
  static String freeToGameUrlBase = "https://free2play-api.herokuapp.com/api/";
  static Map<String, String> getHeaders() {
    return {
      "Authorization": "Token 5848cbc484d7138d4f726e34c685f160e3fc868a"
    };
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
    Map<String, String> headers = API.getHeaders();
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


  // static Future<void> syncDatabases() async {
  //   Map<String, String> headers = {
  //     "Authorization": "Token 5848cbc484d7138d4f726e34c685f160e3fc868a"
  //   };
  //   final db = await getDatabase();
  //   const tableName = "syncQueue";
  //   final queue = await syncQueueQuery(db, tableName);
  //   queue.sort((a, b) => a.id.compareTo(b.id));

  //   final bool connectionStatus = await getConnectionStatus();
  //   http.Response response;
  //   if (connectionStatus) {
  //     for (var item in queue) {
  //       if (item.method.toUpperCase() == "PUT") {
  //         response = await http.put(Uri.parse(item.url), headers: headers);
  //       } else {
  //         response = await http.delete(Uri.parse(item.url), headers: headers);
  //       }
  //       if (response.statusCode == 204) {
  //         await deleteRow(tableName, item.id, db);
  //       }
  //     }
  //   }
  // }

