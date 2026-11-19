import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/task_model.dart';
import '../models/note_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'life_manager.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE categories(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      name TEXT, type TEXT, iconCode TEXT, colorCode INTEGER)''');

    await db.execute('''CREATE TABLE transactions(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      amount REAL, type TEXT, categoryId INTEGER, date TEXT, note TEXT,
      FOREIGN KEY (categoryId) REFERENCES categories (id) ON DELETE CASCADE)''');

    await db.execute('''CREATE TABLE tasks(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT, date TEXT, priority TEXT, isCompleted INTEGER)''');

    await db.execute('''CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT, 
      title TEXT, description TEXT, date TEXT, imagePath TEXT)''');

    await _insertDefaultCategories(db);
  }

  Future<void> _insertDefaultCategories(Database db) async {
    await db.insert('categories', {'name': 'Salary', 'type': 'Income', 'iconCode': '0xe148', 'colorCode': '0xFF42B72A'});
    await db.insert('categories', {'name': 'Business', 'type': 'Income', 'iconCode': '0xe1a4', 'colorCode': '0xFF1877F2'});
    await db.insert('categories', {'name': 'Food', 'type': 'Expense', 'iconCode': '0xe56c', 'colorCode': '0xFFFA383E'});
    await db.insert('categories', {'name': 'Transport', 'type': 'Expense', 'iconCode': '0xe530', 'colorCode': '0xFF65676B'});
  }

  // --- TRANSACTIONS ---
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert('transactions', transaction.toMap());
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT t.*, c.name as categoryName, c.iconCode as categoryIcon 
      FROM transactions t
      LEFT JOIN categories c ON t.categoryId = c.id
      ORDER BY t.id DESC
    ''');
    return List.generate(maps.length, (i) => TransactionModel.fromMap(maps[i]));
  }

  // --- TASKS ---
  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return await db.insert('tasks', task.toMap());
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tasks', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => TaskModel.fromMap(maps[i]));
  }

  Future<int> updateTaskStatus(int id, int isCompleted) async {
    final db = await database;
    return await db.update('tasks', {'isCompleted': isCompleted}, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }

  // --- NOTES ---
  Future<int> insertNote(NoteModel note) async {
    final db = await database;
    return await db.insert('notes', note.toMap());
  }

  Future<List<NoteModel>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('notes', orderBy: 'id DESC');
    return List.generate(maps.length, (i) => NoteModel.fromMap(maps[i]));
  }

  // --- CATEGORIES & STATS ---
  Future<List<CategoryModel>> getCategories(String type) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('categories', where: 'type = ?', whereArgs: [type], orderBy: 'id DESC');
    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  Future<int> insertCategory(CategoryModel category) async {
    final db = await database;
    return await db.insert('categories', category.toMap());
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    // ডিলিট করার সময় ট্রানজেকশনগুলোও ডিলিট হবে ON DELETE CASCADE এর কারণে
    return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getMonthlyCategorySummary(String type) async {
    final db = await database;
    final now = DateTime.now();
    final monthStr = now.month.toString().padLeft(2, '0');
    final yearStr = now.year.toString();
    final prefix = "$yearStr-$monthStr"; 

    return await db.rawQuery('''
      SELECT c.name as categoryName, SUM(t.amount) as totalAmount
      FROM transactions t
      JOIN categories c ON t.categoryId = c.id
      WHERE t.type = ? AND t.date LIKE ?
      GROUP BY c.name
    ''', [type, '$prefix%']);
  }
}
