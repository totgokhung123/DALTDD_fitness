import 'package:flutter/material.dart';
import 'ApiService.dart';

class UserProvider with ChangeNotifier {
  List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get users => _users;

  Future<void> fetchUsers() async {
    // Gọi API để lấy danh sách người dùng
    try {
      final newUsers = await ApiService.getUsers();
      _users = newUsers;
      notifyListeners(); // Thông báo giao diện cập nhật
    } catch (e) {
      print("Error fetching users: $e");
    }
  }

  Future<void> addUser(Map<String, dynamic> user) async {
    // Gọi API thêm người dùng
    try {
      final success = await ApiService.addUser(user);
      if (success) {
        _users.add(user);
        notifyListeners();
      }
    } catch (e) {
      print("Error adding user: $e");
    }
  }

  Future<void> deleteUser(int id) async {
    // Gọi API xóa người dùng
    try {
      final success = await ApiService.deleteUser(id);
      if (success) {
        _users.removeWhere((user) => user['id'] == id);
        notifyListeners();
      }
    } catch (e) {
      print("Error deleting user: $e");
    }
  }
}
