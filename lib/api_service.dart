import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:5000';

  static Future<List<dynamic>> getTasks() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/tasks'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Error fetching tasks: $e');
    }
    return [];
  }

  static Future<void> addTask(String title) async {
    try {
      await http.post(
        Uri.parse('$baseUrl/tasks'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'is_completed': false}),
      );
    } catch (e) {
      print('Error adding task: $e');
    }
  }

  static Future<void> updateTask(int id, String title, bool isCompleted) async {
    try {
      await http.put(
        Uri.parse('$baseUrl/tasks/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'title': title, 'is_completed': isCompleted}),
      );
    } catch (e) {
      print('Error updating task: $e');
    }
  }

  static Future<void> deleteTask(int id) async {
    try {
      await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    } catch (e) {
      print('Error deleting task: $e');
    }
  }
}
