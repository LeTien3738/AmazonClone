import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/database_service.dart';

class OrderProvider extends ChangeNotifier {
  final DatabaseService _dbService = DatabaseService();
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> loadOrders() async {
    _isLoading = true;
    notifyListeners();
    _orders = await _dbService.getOrders();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addOrder(Order order) async {
    await _dbService.saveOrder(order);
    await loadOrders();
  }

  Future<void> clearOrders() async {
    await _dbService.clearOrders();
    await loadOrders();
  }
} 