import 'dart:async';
import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:free2play/utils.dart';
import 'package:free2play/db_test.dart';

Future<List<Game>> fetchGamesData(String url) async {
  Map<String, String> headers = {
		"Authorization": "Token 5848cbc484d7138d4f726e34c685f160e3fc868a"
  };
  final response = await http.get(Uri.parse(url), headers: headers);
  final parsedGames = await compute(parseGames, response.body);
  final db = await getDatabase();
  for (var game in parsedGames) {
    updateOrCreate("games", game, db);
  }

  return parsedGames;
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