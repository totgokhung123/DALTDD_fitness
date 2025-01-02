import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl = 'http://10.0.2.2/api.php';

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/get_users.php'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load users');
    }
  }

  static Future<bool> addUser(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse('$apiUrl/add_user.php'),
      body: json.encode(user),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteUser(int id) async {
    final response = await http.post(
      Uri.parse('$apiUrl/delete_user.php'),
      body: json.encode({'id': id}),
      headers: {'Content-Type': 'application/json'},
    );
    return response.statusCode == 200;
  }
}
