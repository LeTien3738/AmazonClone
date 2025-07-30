import 'package:flutter/material.dart';
import '../services/database_service.dart';

class AdminUserManager extends StatefulWidget {
  const AdminUserManager({Key? key}) : super(key: key);

  @override
  State<AdminUserManager> createState() => _AdminUserManagerState();
}

class _AdminUserManagerState extends State<AdminUserManager> {
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => _isLoading = true);
    final users = await DatabaseService().getAllUsers();
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  void _deleteUser(int id, String username) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận'),
        content: Text('Bạn có chắc muốn xóa tài khoản "$username"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseService().deleteUser(id);
      await _fetchUsers();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _users.isEmpty
            ? const Center(child: Text('Chưa có tài khoản nào.'))
            : ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    leading: Icon(user['isAdmin'] == 1 ? Icons.admin_panel_settings : Icons.person),
                    title: Text(user['username'] ?? ''),
                    subtitle: Text(user['isAdmin'] == 1 ? 'Admin' : 'Khách hàng'),
                    trailing: user['isAdmin'] == 1
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user['id'], user['username']),
                          ),
                  );
                },
              );
  }
} 