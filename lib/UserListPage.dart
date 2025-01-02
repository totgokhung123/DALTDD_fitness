import 'package:flutter/material.dart';
import 'ApiService.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  late Future<List<dynamic>> _users;

  @override
  void initState() {
    super.initState();
    fetchData(); // Tải dữ liệu khi ứng dụng khởi động
  }

// Gọi fetchData() từ một nút hoặc hành động khác để tải lại
  void fetchData() async {
    final data = await ApiService.getData();
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Danh sách người dùng")),
      body: FutureBuilder<List<dynamic>>(
        future: _users,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          }

          final users = snapshot.data ?? [];
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(users[index]['name']),
                subtitle: Text(users[index]['email']),
              );
            },
          );
        },
      ),
    );
  }
}
