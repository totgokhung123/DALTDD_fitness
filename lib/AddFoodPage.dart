import 'package:flutter/material.dart';
import 'package:fitness/ApiService.dart'; // Đảm bảo import dịch vụ API
import 'dart:convert';
import 'package:http/http.dart' as http;
class AddFoodPage extends StatefulWidget {
  final String userId;
  // final String mealTypeId;
  final int mealTypeId;
  final DateTime ngay;

  const AddFoodPage({
    Key? key,
    required this.userId,
    required this.mealTypeId,
    required this.ngay,
  }) : super(key: key);

  @override
  _AddFoodPageState createState() => _AddFoodPageState();
}

class _AddFoodPageState extends State<AddFoodPage> {
  // int selectedFoodId;

  int quantity = 1;
  List<Map<String, dynamic>> foods = [];
  dynamic selectedFoodId;
  @override
  void initState() {
    super.initState();
    fetchFoods();
  }
  Future<void> fetchFoods() async {
    // Gọi API để lấy danh sách món ăn;
    final response = await http.get(Uri.parse('http://10.0.2.2/food.php'));
    if (response.statusCode == 200) {
      setState(() {
        foods = List<Map<String, dynamic>>.from(jsonDecode(response.body));
        // Ép kiểu id về int
        foods = foods.map((food) {
          food['id'] = int.parse(food['id'].toString());
          return food;
        }).toList();
      });
    } else {
      print('Failed to fetch foods');
    }
  }
  void addFood() async {
    if (selectedFoodId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a food')),
      );
      return;
    }

    String caloriesTotal = (foods.firstWhere((food) => food['id'] == selectedFoodId)['calories_per_unit'] * quantity).toString();
    try {

      print("selectedFoodId: "+ selectedFoodId.toString());
      await ApiService().addMealSchedule(
        user_id: widget.userId.toString(),
        type_meal_id: widget.mealTypeId.toString(),
        food_id: selectedFoodId!,
        quantity: quantity.toInt(),
        Ngay: widget.ngay,
        calories_total: caloriesTotal.toString(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Food added successfully')),
      );
      Navigator.pop(context); // Quay lại trang trước
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add food: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Food')),
      body: foods.isEmpty
          ? Center(child: CircularProgressIndicator())
          : Column(
        children: [
          DropdownButton<int>(
            value: selectedFoodId,
            hint: Text('Select Food'),
            items: foods.map((food) {
              return DropdownMenuItem<int>(
                value: food['id'],
                child: Text(food['name']),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedFoodId = value;
              });
            },
          ),
          Slider(
            value: quantity.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: quantity.toString(),
            onChanged: (value) {
              setState(() {
                quantity = value.toInt();
              });
            },
          ),
          ElevatedButton(
            onPressed: addFood,
            child: Text('Add Food'),
          ),
        ],
      ),
    );
  }
}
