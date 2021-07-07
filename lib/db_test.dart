import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:free2play/models/game_detail_model.dart';
import 'package:free2play/models/game_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future<Database> getDatabase() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'free2play.db'),
    onCreate: (db, version) {
      db.execute(
        'CREATE TABLE games(id INTEGER PRIMARY KEY, title TEXT, thumbnailUrl TEXT, thumbnailBase64 TEXT, genre TEXT, platform TEXT)',
      );
      db.execute(
        'CREATE TABLE gamesDetail(id INTEGER PRIMARY KEY, title TEXT, thumbnailUrl TEXT, thumbnailBase64 TEXT, genre TEXT, platform TEXT, description TEXT)',
      );
      db.execute(
        'CREATE TABLE favorites(id INTEGER PRIMARY KEY)',
      );
      db.execute(
        'CREATE TABLE gamesRow01(id INTEGER PRIMARY KEY)',
      );
      db.execute(
        'CREATE TABLE syncQueue(id INTEGER PRIMARY KEY, url TEXT, bodyJson TEXT)',
      );
    },
    version: 1,
  );

  return database;
}

  Future<List<Game>> gamesQuery(List<int> ids, Database db, {String tableName = 'games'}) async {
    // print('id IN (${ids.join(', ')})');
    final List<Map<String, dynamic>> maps = await db.query(tableName, where: 'id IN (${ids.join(', ')})');

    return List.generate(maps.length, (i) {
      return Game(
        id: maps[i]['id'],
        title: maps[i]['title'],
        thumbnailUrl: maps[i]['thumbnailUrl'],
        thumbnailBase64: maps[i]['thumbnailBase64'],
        genre: maps[i]['genre'],
        platform: maps[i]['platform'],
      );
    });
    // final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $tableName where id in ')
    // return maps.map<Game>((json) => Game.fromMap(json)).toList();
  }

  Future<GameDetail> gameDetailQuery(dynamic game, Database db, {String tableName = 'gamesDetail'}) async {
    final gameDetailMaps = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [game.id],
      );
    GameDetail gameDetail;
    if (gameDetailMaps.isNotEmpty) {
       gameDetail = GameDetail (
        id: gameDetailMaps.first['id'] as int,
        title: gameDetailMaps.first['title'] as String,
        thumbnailUrl: gameDetailMaps.first['thumbnailUrl'] as String,
        thumbnailBase64: gameDetailMaps.first['thumbnailBase64'] as String,
        genre: gameDetailMaps.first['genre'] as String,
        platform: gameDetailMaps.first['platform'] as String,
        description: gameDetailMaps.first['description'] as String,
      );
       if (await exists("favorites", RowQuery(id: game.id), db)) {
          gameDetail.favorite = true;
          return gameDetail;
       }
       return gameDetail;
    }
    throw("Detalhes do jogo não foram encontrados!"); 
  }

  Future<List<int>> rowQuery(String tableName, Database db) async {
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    final rowsQuery = maps.map<RowQuery>((json) => RowQuery.fromMap(json)).toList();
    return rowsQuery.map<int>((row) => row.id).toList();
  }

  Future<bool> exists(String tableName, dynamic object, Database db, {String field = 'id'}) async {
    final result = await db.query(
      tableName,
      where: '$field = ?',
      whereArgs: [object.id],
    );
    if (result.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> deleteAllRows(String tableName, Database db) async {
    await db.delete(tableName);
  }

  Future<void> updateOrCreate(String tableName, dynamic object, Database db) async {

    if (await exists(tableName, object, db)) {
      await db.update(
      tableName,
      object.toMap(),
      where: 'id = ?',
      whereArgs: [object.id],
    );
    // ignore: avoid_print
    print("$tableName ${object.id} updated");
    } else {
      await db.insert(
      tableName,
      object.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    // ignore: avoid_print
    print("$tableName ${object.id} created");
    }
  }



class RowQuery {
  final int id;

  RowQuery({
    required this.id,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }
  factory RowQuery.fromMap(Map<String, dynamic> json) {
    return RowQuery(
      id: json['id'] as int,
    );
  }
  @override
  String toString() {
    return 'RowQuery{id: $id}';
  }
}