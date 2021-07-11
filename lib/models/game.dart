import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:free2play/utils.dart';
import 'package:free2play/db_test.dart';
import 'dart:typed_data';

class Game {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String genre;
  final String platform;
  static String tableName = "games";

  Game({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.genre,
    required this.platform,
  });
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'genre': genre,
      'platform': platform,
    };
  }

  @override
  String toString() {
    return 'Game{id: $id, name: $title, age: $platform}';
  }

  static Future<List<Game>> fetchData(String url, String tableName) async {
    Map<String, String> headers = await API.getHeaders();
    final bool connectionStatus = await getConnectionStatus();
    final db = await getDatabase();

    if (connectionStatus) {
      final response = await http.get(Uri.parse(url), headers: headers);
      final parsedGames = jsonParse(response.bodyBytes);
      await deleteAllRows(tableName, db);

      for (var game in parsedGames) {
        await updateOrCreate("games", game, db);
        await updateOrCreate(tableName, RowQuery(id: game.id), db);
      }
      final ids = await rowQuery(tableName, db);
      return gamesQuery(ids, db);
    }
    final ids = await rowQuery(tableName, db);
    return gamesQuery(ids, db);
  }

  static List<Game> jsonParse(Uint8List bodyBytes) {
    final parsed = API.jsonUtf8Decode(bodyBytes).cast<Map<String, dynamic>>();
    return parsed.map<Game>((json) => Game.fromJson(json)).toList();
  }
}
