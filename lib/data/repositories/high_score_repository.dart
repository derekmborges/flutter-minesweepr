import 'dart:io';
import 'package:minesweepr/data/models/high_score.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class HighScore {
  int id;
  String difficultyName;
  int bestTime;

  HighScore(this.difficultyName, this.bestTime);

  HighScore.fromMap(Map<String, dynamic> map) {
    id = map[highScoreId];
    difficultyName = map[highScoreDifficultyName];
    bestTime = map[highScoreBestTime];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      highScoreDifficultyName: difficultyName,
      highScoreBestTime: bestTime
    };
    if (id != null) {
      map[highScoreId] = id;
    }
    return map;
  }

  @override
  String toString() => "$difficultyName - $bestTime seconds";
}

class HighScoreRepository {
  static final _databaseName = "minesweepr.db";
  static final _databaseVersion = 1;

  HighScoreRepository._privateConstructor();
  static final HighScoreRepository instance = HighScoreRepository._privateConstructor();

  static Database _database;
  Future<Database> get database async {
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
    print("CREATING HIGH SCORE TABLE");
    await db.execute('''
      CREATE TABLE $tableHighScore (
        $highScoreId INTEGER PRIMARY KEY,
        $highScoreDifficultyName TEXT NOT NULL,
        $highScoreBestTime INTEGER NOT NULL
      )
    ''');
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