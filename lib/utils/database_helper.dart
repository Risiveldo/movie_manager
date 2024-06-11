import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:movie_manager/models/movie.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'movies.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE movies(id INTEGER PRIMARY KEY, imageUrl TEXT, title TEXT, genre TEXT, ageRating TEXT, duration INTEGER, rating REAL, description TEXT, year INTEGER)",
        );
      },
    );
  }

  Future<void> insertMovie(Map<String, dynamic> movie) async {
    final db = await database;
    await db.insert('movies', movie, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryAllMovies() async {
    final db = await database;
    return await db.query('movies');
  }

  Future<void> updateMovie(Map<String, dynamic> movie) async {
    final db = await database;
    await db.update('movies', movie, where: 'id = ?', whereArgs: [movie['id']]);
  }

  Future<void> deleteMovie(int id) async {
    final db = await database;
    await db.delete('movies', where: 'id = ?', whereArgs: [id]);
  }
}
