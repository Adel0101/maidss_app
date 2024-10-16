import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/utils/constants.dart';

class TaskApiService {
  final Dio _dio = Dio();

  TaskApiService() {
    _dio.options.baseUrl = Constants.baseUrl;
  }

  ///fetch all the tasks
  Future<Tasks> fetchTasks(int userId, {int limit = 30, int skip = 0}) async {
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

  ///add a task, require the text and user id
  Future<Todo> addTask(String title, int userId) async {
    try {
      final response = await _dio.post('/todos/add', data: {
        'todo': title,
        'completed': false,
        'userId': userId,
      });
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to add task');
    }
  }

  ///update a task, require task id and the value
  Future<Todo> updateTask(int id, bool status) async {
    try {
      final response = await _dio.put('/todos/$id', data: {
        'completed': status,
      });
      return Todo.fromJson(response.data);
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to update task');
    }
  }

  ///delete a task, require task id
  Future<void> deleteTask(int id) async {
    try {
      await _dio.delete('/todos/$id');
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? 'Failed to delete task');
    }
  }
}
