import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:free2play/utils.dart';
import 'package:free2play/models/nested_models.dart';
import 'package:free2play/db_test.dart';
import 'dart:typed_data';

class GameDetail {
  final int id;
  final String title;
  final String thumbnailUrl;
  final String genre;
  final String platform;
  final String description;
  bool favorite = false;
  final SystemRequirements minimumSystemRequirements;
  final List<Screenshot> screenshots;
  static String tableName = "gamesDetail";

  GameDetail({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.genre,
    required this.platform,
    required this.minimumSystemRequirements,
    required this.description,
    required this.screenshots,
    // required this.favorite,
  });
  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      id: json['id'] as int,
      title: json['title'] as String,
      thumbnailUrl: json['thumbnail'] as String,
      description: json['description'] as String,
      genre: json['genre'] as String,
      platform: json['platform'] as String,
      minimumSystemRequirements: SystemRequirements.fromJson(json['minimum_system_requirements']),
      screenshots: json['screenshots'].map<Screenshot>((json) => Screenshot.fromJson(json)).toList(),
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'genre': genre,
      'platform': platform,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'GameDetail{id: $id, name: $title, age: $platform}';
  }

  static Future<GameDetail> fetchData(int gameId) async {
    String url = "https://free2play-api.herokuapp.com/api/games/$gameId/";
    Map<String, String> headers = await API.getHeaders();
    final db = await getDatabase();
    final bool connectionStatus = await getConnectionStatus();

    if (connectionStatus) {
      final response = await http.get(Uri.parse(url), headers: headers);
      final parsedGameDetail = jsonParse(response.bodyBytes);
      await updateOrCreateGameDetail(parsedGameDetail, db);
      return gameDetailQuery(parsedGameDetail, db);
    }
    return gameDetailQuery(RowQuery(id: gameId), db);
  }

  static GameDetail jsonParse(Uint8List bodyBytes) {
    final parsedJson = API.jsonUtf8Decode(bodyBytes);
    return GameDetail.fromJson(parsedJson);
  }
}
