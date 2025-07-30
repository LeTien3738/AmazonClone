import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';
import 'dart:convert';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cloneamazon.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE,
        password TEXT,
        isAdmin INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        price REAL,
        description TEXT,
        image TEXT
      )
    ''');
    // Thêm bảng orders
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER,
        total REAL,
        createdAt TEXT
      )
    ''');
    // Thêm bảng order_items
    await db.execute('''
      CREATE TABLE order_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        orderId INTEGER,
        productId INTEGER,
        quantity INTEGER,
        price REAL
      )
    ''');
    // Thêm tài khoản admin mặc định
    await db.insert('users', {
      'username': 'admin',
      'password': '7777777',
      'isAdmin': 1,
    });
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  // Thêm các hàm CRUD cho user và product nếu cần

  Future<bool> register(String username, String password) async {
    final db = await database;
    try {
      await db.insert('users', {
        'username': username,
        'password': password,
        'isAdmin': 0,
      });
      return true;
    } catch (e) {
      // Nếu username đã tồn tại sẽ bị lỗi UNIQUE
      return false;
    }
  }

  // Quản lý doanh thu
  Future<double> getTotalRevenue() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(total) as revenue FROM orders');
    final revenue = result.first['revenue'];
    if (revenue == null) return 0.0;
    if (revenue is int) return revenue.toDouble();
    return revenue as double;
  }

  // Quản lý tài khoản
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<void> deleteUser(int id) async {
    final db = await database;
    await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> ensureAdminAccount() async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: ['admin'],
    );
    if (result.isEmpty) {
      await db.insert('users', {
        'username': 'admin',
        'password': '7777777',
        'isAdmin': 1,
      });
    }
  }

  static const String orderHistoryKey = 'order_history';

  Future<void> saveOrder(Order order) async {
    final prefs = await SharedPreferences.getInstance();
    final orders = await getOrders();
    orders.insert(0, order); // Thêm đơn mới lên đầu
    final jsonList = orders.map((e) => e.toJson()).toList();
    await prefs.setString(orderHistoryKey, jsonEncode(jsonList));
  }

  Future<List<Order>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(orderHistoryKey);
    if (jsonString == null) return [];
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => Order.fromJson(e)).toList();
  }

  Future<void> clearOrders() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(orderHistoryKey);
  }
} 