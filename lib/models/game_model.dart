import 'dart:async';
import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:free2play/utils.dart';
import 'package:free2play/db_test.dart';

Future<List<Game>> fetchGamesData(String url, String tableName) async {
  Map<String, String> headers = {
		"Authorization": "Token 5848cbc484d7138d4f726e34c685f160e3fc868a"
  };
  final response = await http.get(Uri.parse(url), headers: headers);
  final parsedGames = await compute(parseGames, response.body);
  final db = await getDatabase();
  final bool connectionStatus = await getConnectionStatus();
  if (connectionStatus) {
    
    // await deleteAllRows(tableName, db);
    for (var game in parsedGames) {
      await updateOrCreate("games", game, db);
      await updateOrCreate(tableName, RowQuery(id: game.id), db);
    }
    final ids = await rowQuery(tableName, db);
    // print("---");
    // print(ids.length);
    // print("+");
    // final len = await gamesQuery(ids, db);
    // print("=== ${len.first.keys} ");
    // print("=== ${len.first['genre']} ");
    // print("=== ${len.first['platform']} ");
    // print((await parsedGames).length);
    return gamesQuery(ids, db);
    // return parsedGames;
  }
  // final ids = await rowQuery(tableName, db);
  final ids = await rowQuery(tableName, db);
  return gamesQuery(ids, db);
}

List<Game> parseGames(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<Game>((json) => Game.fromJson(json)).toList();
}

class Game {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String thumbnailBase64;
  final String genre;
  final String platform;

  Game({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.thumbnailBase64,
    required this.genre,
    required this.platform,
  });
  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail'] as String,
      thumbnailBase64: json['thumbnail_base64'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
    );
  }
  factory Game.fromMap(Map<String, dynamic> map) {
    return Game(
      id: map['id'] != "" ? map['id'] as int : 1,
      title: map['title'] != "" ? map['title'] as String : "Empty",
      thumbnailUrl: map['thumbnailUrl'] != "" ? map['thumbnail'] as String : "Empty",
      thumbnailBase64: map['thumbnailBase64'] != "" ? map['thumbnail_base64'] as String : "Empty",
      genre: map['genre'] != "" ? map['genre'] as String : "Empty",
      platform: map['platform'] != "" ? map['platform'] as String : "Empty",
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'thumbnailBase64': thumbnailBase64,
      'genre': genre,
      'platform': platform,
    };
  }
  @override
  String toString() {
    return 'Game{id: $id, name: $title, age: $platform}';
  }
}