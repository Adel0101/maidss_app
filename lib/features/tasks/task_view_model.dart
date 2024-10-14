import 'package:flutter/material.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/services/api/task_service.dart';

enum DataState {
  Uninitialized,
  Refreshing,
  Initial_Fetching,
  More_Fetching,
  Fetched,
  No_More_Data,
  Error
}

class TaskViewModel extends ChangeNotifier {
  final TaskApiService _taskApiService = TaskApiService();
  // final DbService _dbService = DbService();

  final int _limit = 10;

  int _currentPageNumber = 0; // Current Page to get Data from API
  int _totalPages = 1;
  DataState _dataState = DataState
      .Uninitialized; // Current State of Data. Initially it will be UnInitialized
  bool get _didLastLoad => _currentPageNumber >= _totalPages;
  DataState get dataState => _dataState;
  List<Todo> _dataList = [];
  List<Todo> get dataList => _dataList;

  fetchData({bool isRefresh = false}) async {
    if (!isRefresh) {
      _dataState = (_dataState == DataState.Uninitialized)
          ? DataState.Initial_Fetching
          : DataState.More_Fetching;
    } else {
      _dataList.clear();
      _currentPageNumber = 0;
      _dataState = DataState.Refreshing;
    }
    notifyListeners();
    try {
      if (_didLastLoad) {
        _dataState = DataState.No_More_Data;
      } else {
        try {
          Tasks tasks = await _taskApiService.fetchTasks(
            limit: _limit,
            skip: _currentPageNumber * _limit,
          );
          _dataList += tasks.todos;
          _dataState = DataState.Fetched;
          _totalPages = (tasks.total / _limit).ceil();
          _currentPageNumber++;
        } catch (e) {
          print('error :: $e');
        }
      }
      notifyListeners();
    } catch (e) {
      _dataState = DataState.Error;
      notifyListeners();
    }
  }

  // Future<void> addTask(String title) async {
  //   try {
  //     Task task = await _taskApiService.addTask(title);
  //     _tasks.add(task);
  //     // await _dbService.insertTask(task);
  //     notifyListeners();
  //   } catch (e) {
  //     throw e;
  //   }
  // }
  //
  // Future<void> updateTask(int id, String title) async {
  //   try {
  //     Task updatedTask = await _taskApiService.updateTask(id, title);
  //     int index = _tasks.indexWhere((task) => task.id == id);
  //     if (index != -1) {
  //       _tasks[index] = updatedTask;
  //       // await _dbService.updateTask(updatedTask);
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     throw e;
  //   }
  // }
  //
  // Future<void> deleteTask(int id) async {
  //   try {
  //     await _taskApiService.deleteTask(id);
  //     _tasks.removeWhere((task) => task.id == id);
  //     // await _dbService.deleteTask(id);
  //     notifyListeners();
  //   } catch (e) {
  //     throw e;
  //   }
  // }
}
