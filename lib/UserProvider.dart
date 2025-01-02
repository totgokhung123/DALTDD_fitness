import 'package:flutter/material.dart';
import 'ApiService.dart';

class UserProvider with ChangeNotifier {
  List<Map<String, dynamic>> _users = [];

  List<Map<String, dynamic>> get users => _users;

  Future<void> fetchUsers() async {
    try {
      final newUsers = await ApiService.getUsers();
      _users = newUsers;
      notifyListeners(); // Thông báo để giao diện cập nhật
    } catch (e) {
      print("Error fetching users: $e");
    }
  }
}
