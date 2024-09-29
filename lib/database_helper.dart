import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      String path = join(await getDatabasesPath(), 'reading_list.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute(
            'CREATE TABLE books(id TEXT PRIMARY KEY, title TEXT, authors TEXT, thumbnail TEXT)',
          );
        },
      );
    } catch (e) {
      throw Exception('Erro ao iniciar banco de dados: $e');
    }
  }

  Future<void> addBook(Map<String, dynamic> book) async {
    try {
      final db = await database;
      await db.insert(
        'books',
        book,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      throw Exception('Erro ao adicionar livro: $e');
    }
  }

  Future<void> removeBook(String id) async {
    try {
      final db = await database;
      await db.delete(
        'books',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      throw Exception('Erro ao remover livro: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBooks() async {
    try {
      final db = await database;
      return await db.query('books');
    } catch (e) {
      throw Exception('Erro ao recuperar livros: $e');
    }
  }
}
