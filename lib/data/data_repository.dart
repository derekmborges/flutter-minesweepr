import 'dart:io';
import 'package:minesweepr/data/models/difficulty.dart';
import 'package:minesweepr/data/models/high_score.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataRepository {
  static final _databaseName = "minesweepr.db";
  static final _databaseVersion = 1;

  DataRepository._privateConstructor();
  static final DataRepository instance = DataRepository._privateConstructor();

  static Database _database;
  Future<Database> get database async {
//    Directory documentsDirectory = await getApplicationDocumentsDirectory();
//    String path = join(documentsDirectory.path, _databaseName);
//    if (_database != null) deleteDatabase(path);

    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
     Directory documentsDirectory = await getApplicationDocumentsDirectory();
     String path = join(documentsDirectory.path, _databaseName);
     return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    print("CREATING TABLES");
    await db.execute('''
      CREATE TABLE $tableSelectedDifficulty (
        $difficultyId INTEGER PRIMARY KEY,
        $difficultyName TEXT NOT NULL,
        $difficultyWidth INTEGER NOT NULL,
        $difficultyHeight INTEGER NOT NULL,
        $difficultyBombCount INTEGER NOT NULL
      )
      ''');
    print("$tableSelectedDifficulty created");
    await db.execute('''
      CREATE TABLE $tableHighScore (
        $highScoreId INTEGER PRIMARY KEY,
        $highScoreDifficultyName TEXT NOT NULL,
        $highScoreBestTime INTEGER NOT NULL
      )
    ''');
    print("$tableHighScore created");
  }

  Future<int> setSelectedDifficulty(Difficulty difficulty) async {
    Database db = await database;
    int id;

    if (await getSelectedDifficulty() != null) {
      id = await db.update(tableSelectedDifficulty, difficulty.toMap());
    } else {
      id = await db.insert(tableSelectedDifficulty, difficulty.toMap());
    }
    return id;
  }

  Future<Difficulty> getSelectedDifficulty() async {
    Database db = await database;
    int id = 1;
    List<Map> maps = await db.query(tableSelectedDifficulty,
        columns: [difficultyId, difficultyName, difficultyWidth, difficultyHeight, difficultyBombCount],
        where: '$difficultyId = ?',
        whereArgs: [id]);
    return maps.length > 0
        ? Difficulty.fromMap(maps.first)
        : null;
  }

  Future<HighScore> getHighScore(String difficultyName) async {
    Database db = await database;
    List<Map> maps = await db.query(tableHighScore,
        columns: [highScoreId, highScoreDifficultyName, highScoreBestTime],
        where: '$highScoreDifficultyName = ?',
        whereArgs: [difficultyName]);
    return maps.length > 0
        ? HighScore.fromMap(maps.first)
        : null;
  }

  Future<int> setHighScore(String difficultyName, int bestTime) async {
    Database db = await database;
    int id;
    HighScore existingHighScore = await getHighScore(difficultyName);

    if (existingHighScore != null) {
      existingHighScore.bestTime = bestTime;
      id = await db.update(tableHighScore, existingHighScore.toMap());
    } else {
      HighScore highScore = HighScore(difficultyName, bestTime);
      id = await db.insert(tableHighScore, highScore.toMap());
    }

    return id;
  }
}
