// lib/database/db_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/stock_transaction.dart';

class DBHelper {
  static Database? _database;

  static const String _tableName = 'transactions';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB();
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'inventory.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  static Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        item TEXT,
        destination TEXT,
        quantity INTEGER,
        note TEXT,
        date TEXT
      )
    ''');
  }

  static Future<int> insertTransaction(StockTransaction tx) async {
    final db = await database;
    return await db.insert(_tableName, tx.toMap());
  }

  static Future<List<StockTransaction>> getTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return List.generate(maps.length, (i) => StockTransaction.fromMap(maps[i]));
  }
}
