import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();

  factory DBHelper() {
    return _instance;
  }

  DBHelper._internal();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'workouts.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE workouts(id INTEGER PRIMARY KEY, exercise TEXT, weight INTEGER, reps INTEGER, date TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertWorkout(Map<String, dynamic> workoutData) async {
    final db = await database;
    await db!.insert(
      'workouts', // Table name
      workoutData, // Data to insert
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getWorkouts() async {
    final db = await database;
    return db!.query('workouts', orderBy: 'date DESC');
  }

  Future<List<Map<String, dynamic>>> getWorkoutDetails(String date) async {
    final db = await database;
    return db!.query('workouts', where: 'date = ?', whereArgs: [date]);
  }
}
