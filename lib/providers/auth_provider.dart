import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/database_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin == true;

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    setLoading(true);
    final userMap = await DatabaseService().login(username, password);
    setLoading(false);
    if (userMap != null) {
      _currentUser = User(
        id: userMap['id'].toString(),
        email: userMap['username'],
        name: userMap['username'],
        isAdmin: userMap['isAdmin'] == 1,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> register(String name, String email, String password) async {
    setLoading(true);
    // Đăng ký vào SQLite, username là email hoặc name (ở đây dùng email cho đồng bộ)
    final success = await DatabaseService().register(email, password);
    setLoading(false);
    if (success) {
      _currentUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
      );
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  void updateUser(User user) {
    _currentUser = user;
    notifyListeners();
  }
} 