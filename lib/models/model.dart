import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:free2play/models/game_detail.dart';
import 'package:free2play/models/game.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Model {
  static Future<Database> database() async {
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
        'CREATE TABLE syncQueue(id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT, metho)',
      );
    },
    version: 1,
  );

  return database;
}
}