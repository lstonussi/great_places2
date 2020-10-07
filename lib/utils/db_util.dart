import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sqlite.Database> database() async {
    final dbPath = await sqlite.getDatabasesPath();

    return sqlite.openDatabase(path.join(dbPath, 'places.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE places (id TEXT PRIMARY KEY, title TEXT, image TEXT)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sqlite.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
