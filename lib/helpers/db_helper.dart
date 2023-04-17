import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE user_places(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, image TEXT, loc_lat REAL, loc_lng REAL, address TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getLastEntry() async {
    final db = await DBHelper.database();
    // return db.rawQuery("SELECT * FROM user_places ORDER BY id DESC LIMIT 1");

    // if not...test this
    // final lastEntry = db.rawQuery("SELECT * FROM user_places ORDER BY id DESC LIMIT 1");
    return db.query(
      'user_places',
      orderBy: 'id DESC',
      limit: 1,
    );
  }
}
