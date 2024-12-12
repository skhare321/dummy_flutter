// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class DatabaseHelper {
//   static final DatabaseHelper _instance = DatabaseHelper._internal();
//   factory DatabaseHelper() => _instance;
//   static Database? _database;
//
//   DatabaseHelper._internal();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     String path = join(await getDatabasesPath(), 'your_database.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) {
//         return db.execute(
//           'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, age INTEGER)',
//         );
//       },
//     );
//   }
//
//   Future<void> insertUser(Map<String, dynamic> user) async {
//     final db = await database;
//     await db.insert(
//       'users',
//       user,
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
//
// // Add more database helper methods as needed
// }
