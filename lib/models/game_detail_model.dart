import 'dart:async';
import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:free2play/models/nested_models.dart';

Future<GameDetail> fetchGameDetailData(int gameId) async {
  String url = "https://free2play-api.herokuapp.com/api/games/${gameId}/";
  Map<String, String> headers = {
		"Authorization": "Token 5848cbc484d7138d4f726e34c685f160e3fc868a"
  };
  final response = await http.get(Uri.parse(url), headers: headers);

  return parseGameDetail(response.body);
}

GameDetail parseGameDetail(String responseBody) {
  final parsedJson = jsonDecode(responseBody);
  return GameDetail.fromJson(parsedJson);
}

class GameDetail {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String thumbnailBase64;
  final String genre;
  final String platform;
  final String description;
  final SystemRequirements minimumSystemRequirements;

  GameDetail({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.thumbnailBase64,
    required this.genre,
    required this.platform,
    required this.minimumSystemRequirements,
    required this.description,
  });
  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail'] as String,
      thumbnailBase64: json['thumbnail_base64'] as String,
      description: json['description'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
      minimumSystemRequirements: SystemRequirements.fromJson(json['minimum_system_requirements']),
    );
  }
}