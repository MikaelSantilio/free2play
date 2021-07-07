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
    final List<Map<String, dynamic>> maps = await db.query(tableName, where: 'id IN ?', whereArgs: ids);
    return maps.map<Game>((json) => Game.fromJson(json)).toList();
  }

  Future<GameDetail> gameDetailQuery(Game game, Database db, {String tableName = 'gamesDetail'}) async {
    final gameDetailMaps = await db.query(
        tableName,
        where: 'id = ?',
        whereArgs: [game.id],
      );
    if (gameDetailMaps != []) {
      return GameDetail.fromJson(gameDetailMaps.first);
    }
    throw("Detalhes do jogo não foram encontrados!"); 
  }

  Future<List<Map<String, Object?>>> rowQuery(String tableName, Database db) async {
    final maps = await db.query(tableName);
    return maps;
    // return List.generate(maps.length, (i) {
    //   return int.parse(String(maps[i]['id']));
    // })
    
  }

  Future<bool> exists(String tableName, dynamic object, Database db, {String field = 'id'}) async {
    final result = await db.query(
      tableName,
      where: '$field = ?',
      whereArgs: [object.id],
    );
    if (result != []) {
      return true;
    }
    return false;
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
