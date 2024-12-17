import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  DatabaseHelper();
  DatabaseHelper.database();
  static final DatabaseHelper instance = DatabaseHelper._internal();
  Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'app_data.db'),
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age TEXT)",
        );
      },
    );
  }

  Future<void> insertUser(String name, String age) async {
    final db = await database;
    await db.insert(
      'user',
      {'name': name, 'age': age},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('user');
  }
}
