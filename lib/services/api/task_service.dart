import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/utils/constants.dart';

class TaskApiService {
  final Dio _dio = Dio();

  TaskApiService() {
    _dio.options.baseUrl = Constants.baseUrl;
  }

  Future<Tasks> fetchTasks({int limit = 30, int skip = 0}) async {
    try {
      final response = await _dio.get('/todos', queryParameters: {
        'limit': limit,
        'skip': skip,
      });
      return tasksFromJson(json.encode(response.data));
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to fetch tasks');
    }
  }

  Future<Todo> addTask(String title) async {
    try {
      final response = await _dio.post('/todos/add', data: {
        'todo': title,
        'completed': false,
        'userId': 5,
      });
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to add task');
    }
  }

  Future<Todo> updateTask(int id, String title) async {
    try {
      final response = await _dio.put('/todos/$id', data: {
        'todo': title,
      });
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete('/todos/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete task');
    }
  }
}
