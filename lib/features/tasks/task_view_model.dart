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
  Tasks? tasks;

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
    try {
      if (_didLastLoad) {
        _dataState = DataState.No_More_Data;
      } else {
        try {
          tasks = await _taskApiService.fetchTasks(
            limit: _limit,
            skip: _currentPageNumber * _limit,
          );
          _dataList += tasks!.todos;
          _dataState = DataState.Fetched;
          _totalPages = (tasks!.total / _limit).ceil();
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

  void addTask(String title) {
    // Create the Todo object locally
    Todo newTask = Todo(
      id: DateTime.now().millisecondsSinceEpoch,
      todo: title,
      completed: false,
      userId: 0,
    );

    _dataList.insert(0, newTask);
    print('Task added to _dataList. Total tasks: ${_dataList.length}');
    notifyListeners();
    print('Notified listeners after adding task');
  }

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
