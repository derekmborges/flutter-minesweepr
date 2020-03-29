import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableSelectedDifficulty = 'selectedDifficulty';
final String columnId = '_id';
final String columnName = 'name';
final String columnWidth = 'width';
final String columnHeight = 'height';
final String columnBombCount = 'bombCount';

List<DifficultyDB> dbDifficulties = <DifficultyDB>[
  DifficultyDB.easy(),
  DifficultyDB.medium(),
  DifficultyDB.hard()
];

class DifficultyDB {
  int id;
  String name;
  int width;
  int height;
  int bombCount;

  @override
  bool operator ==(other) => other is DifficultyDB && other.name == name;

  @override
  String toString() => name;

  DifficultyDB();

  DifficultyDB.easy() {
    name = "Easy";
    width = 6;
    height = 12;
    bombCount = 10;
  }

  DifficultyDB.medium() {
    name = "Medium";
    width = 8;
    height = 16;
    bombCount = 20;
  }

  DifficultyDB.hard() {
    name = "Hard";
    width = 10;
    height = 20;
    bombCount = 40;
  }

  DifficultyDB.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    name = map[columnName];
    width = map[columnWidth];
    height = map[columnHeight];
    bombCount = map[columnBombCount];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic> {
      columnName: name,
      columnWidth: width,
      columnHeight: height,
      columnBombCount: bombCount
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class SelectedDifficultyRepository {
  static final _databaseName = "minesweepr.db";
  static final _databaseVersion = 1;

  SelectedDifficultyRepository._privateConstructor();
  static final SelectedDifficultyRepository instance = SelectedDifficultyRepository._privateConstructor();

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
    await db.execute('''
      CREATE TABLE $tableSelectedDifficulty (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnWidth INTEGER NOT NULL,
        $columnHeight INTEGER NOT NULL,
        $columnBombCount INTEGER NOT NULL
      )
      ''');
  }

  Future<int> setSelectedDifficulty(DifficultyDB difficulty) async {
    Database db = await database;
    int id;

    if (await getSelectedDifficulty() != null) {
      id = await db.update(tableSelectedDifficulty, difficulty.toMap());
    } else {
      id = await db.insert(tableSelectedDifficulty, difficulty.toMap());
    }
    return id;
  }

  Future<DifficultyDB> getSelectedDifficulty() async {
    Database db = await database;
    int id = 1;
    List<Map> maps = await db.query(tableSelectedDifficulty,
        columns: [columnId, columnName, columnWidth, columnHeight, columnBombCount],
        where: '$columnId = ?',
        whereArgs: [id]);
    return maps.length > 0
        ? DifficultyDB.fromMap(maps.first)
        : null;
  }
}
