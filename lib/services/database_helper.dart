import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quotation_app.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Item_Details (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            price REAL NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE Quotations (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            item_name TEXT NOT NULL,
            price REAL NOT NULL,
            quantity INTEGER NOT NULL,
            discount REAL NOT NULL,
            total REAL NOT NULL
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await database;
    return db.query('Item_Details');
  }

  Future<List<Map<String, dynamic>>> searchItems(String query) async {
    final db = await database;
    return db.query(
      'Item_Details',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
  }

  Future<int> insertItem(String name, double price) async {
    final db = await database;
    return db.insert(
      'Item_Details',
      {'name': name, 'price': price},
    );
  }

  Future<int> saveQuotation(Map<String, dynamic> quotation) async {
    final db = await database;
    return db.insert('Quotations', quotation);
  }

  /// New Method: Save Multiple Quotations
  Future<void> saveQuotations(List<Map<String, dynamic>> quotations) async {
    final db = await database;
    final batch = db.batch();

    for (final quotation in quotations) {
      batch.insert('Quotations', quotation);
    }

    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> fetchQuotations() async {
    final db = await database;
    return db.query('Quotations');
  }
}
