import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/model.dart';

class DBProvider {
  final String _dbName = 'app.db';
  final String _tableName = 'notes';

  // Create a singleton
  DBProvider._();

  static final DBProvider db = DBProvider._();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDB();
    return _database;
  }

  Future close() async {
    return _database.close();
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, _dbName);

    return await openDatabase(path, version: 1, onOpen: (db) async {},
        onCreate: (Database db, int version) async {
      // Create the note table
      await db.execute('''
                CREATE TABLE $_tableName(
                    id INTEGER PRIMARY KEY,
                    time INTEGER DEFAULT 0,
                    contents TEXT DEFAULT ''
                )
            ''');
    });
  }

  Future<int> insertNote(Model model) async {
    final db = await database;
    return await db.insert(_tableName, model.toJson());
  }

  Future<int> updateNote(Model model) async {
    final db = await database;
    return await db.update(_tableName, model.toJson(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<List<Model>> getAllNotes() async {
    final db = await database;
    var res = await db.query(_tableName, orderBy: 'time DESC');
    List<Model> notes = res.isNotEmpty
        ? res.map((_tableName) => Model.fromJson(_tableName)).toList()
        : [];
    return notes;
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getNoteCount() async {
    final db = await database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $_tableName'));
  }
}
