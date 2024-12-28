import 'package:applicationenglish/fitur/sqflite/dictionaryClass.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('user_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE users(
      uid TEXT PRIMARY KEY,
      username TEXT NOT NULL,
      email TEXT NOT NULL UNIQUE,
      password TEXT NOT NULL
    )
  ''');

    // Tabel dictionary
    await db.execute('''
    CREATE TABLE dictionary (
      id INTEGER PRIMARY KEY,
      word TEXT NOT NULL,
      translate TEXT NOT NULL,
      tabs_bar TEXT
    )
  ''');

    // Tabel beginner
    await db.execute('''
    CREATE TABLE beginner (
      id INTEGER PRIMARY KEY,
      kalimat TEXT NOT NULL,
      type_ans TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE beginner_words (
      id INTEGER PRIMARY KEY,
      sentence_id INTEGER NOT NULL,
      word TEXT NOT NULL,
      cursor BOOLEAN DEFAULT 0,
      FOREIGN KEY(sentence_id) REFERENCES beginner(id)
    )
  ''');

    // Tabel intermediate
    await db.execute('''
    CREATE TABLE intermediate (
      id INTEGER PRIMARY KEY,
      kalimat TEXT NOT NULL,
      type_ans TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE intermediate_words (
      id INTEGER PRIMARY KEY,
      sentence_id INTEGER NOT NULL,
      word TEXT NOT NULL,
      cursor BOOLEAN DEFAULT 0,
      FOREIGN KEY(sentence_id) REFERENCES intermediate(id)
    )
  ''');

    // Tabel advanced
    await db.execute('''
    CREATE TABLE advanced (
      id INTEGER PRIMARY KEY,
      kalimat TEXT NOT NULL,
      type_ans TEXT NOT NULL
    )
  ''');

    await db.execute('''
    CREATE TABLE advanced_words (
      id INTEGER PRIMARY KEY,
      sentence_id INTEGER NOT NULL,
      word TEXT NOT NULL,
      cursor BOOLEAN DEFAULT 0,
      FOREIGN KEY(sentence_id) REFERENCES advanced(id)
    )
  ''');
  }

  // dictionary Helper
  Future<bool?> isDictionaryTableEmpty() async {
    try {
      final db = await database;
      final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM dictionary'));
      print("hasil adalah ${count == 0}");
      return count == 0; 
    } catch (err) {
      print("There is error -> $err");
      return null;
    }
  }

  Future<void> insertDictionaryEntry(UserDictionary entry) async {
    final db = await database;
    await db.insert(
      'dictionary',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  Future<List<Map<String, dynamic>>> fetchDictionaryData() async {
    final db = await database;
    final List<Map<String, dynamic>> dictionaries = await db.query('dictionary');
    List<Map<String, dynamic>> result = [];

    for (var entry in dictionaries) {
      // Buat model sesuai format
      result.add({
        "id": entry['id'].toString(),
        "word": entry['word'],
        "translate": entry['translate'].split(','),
        "TabsBar": entry['tabs_bar'],
      });
    }
    return result;
  }

  Future<List<UserDictionary>> fetchAllDictionaryEntries() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('dictionary');

    return List.generate(maps.length, (i) {
      return UserDictionary.fromMap(maps[i]);
    });
  }

  // Fungsi untuk menambahkan user ke database
  Future<void> saveUserOffline(UserDefine user) async {
    final db = await database;
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }


  // Fungsi untuk validasi login offline berdasarkan email dan password
  Future<UserDefine?> validateUserOffline(String email, String password) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if (maps.isNotEmpty) {
      return UserDefine.fromMap(maps.first);
    }
    return null;
  }

  Future<List<UserDefine>> getAllUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');

    return List.generate(maps.length, (i) {
      return UserDefine.fromMap(maps[i]);
    });
  }
}
