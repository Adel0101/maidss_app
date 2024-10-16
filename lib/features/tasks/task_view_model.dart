import 'package:flutter/material.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/services/api/task_service.dart';
import 'package:task_manager_maidss/services/db_service.dart';

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
  final DbService _dbService = DbService();

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
          await _dbService.insertTodosBulk(_dataList);
          _totalPages = (tasks!.total / _limit).ceil();
          _currentPageNumber++;
        } catch (e) {
          print('error :: $e');
        }
      }
      notifyListeners();
    } catch (e) {
      _dataList = await _dbService.getAllTodos();
      _dataState = DataState.Error;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> addTask(String title) async {
    try {
      Todo task = await _taskApiService.addTask(title);
      _dataList.insert(0, task);
      await _dbService.insertTodo(task);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> updateTask(int id, bool status) async {
    try {
      Todo updatedTask = await _taskApiService.updateTask(id, status);
      int index = _dataList.indexWhere((task) => task.id == id);
      if (index != -1) {
        _dataList[index] = updatedTask;
        await _dbService.updateTodo(updatedTask);
        notifyListeners();
      }
    } catch (e) {
      // in case a new task is added, then changes will only happen locally
      int index = _dataList.indexWhere((task) => task.id == id);
      if (index != -1) {
        _dataList[index] = _dataList[index].copyWith(completed: status);
        await _dbService.updateTodo(_dataList[index]);
        notifyListeners();
      }
    }
  }

  Future<void> updateTaskText(int id, String title) async {
    try {
      /*Todo updatedTask = await _taskApiService.updateTask(id, status);*/ // simulate the update of a todo
      int index = _dataList.indexWhere((task) => task.id == id);
      if (index != -1) {
        _dataList[index] = _dataList[index].copyWith(todo: title);
        await _dbService.updateTodo(_dataList[index]);
        notifyListeners();
      }
    } catch (e) {
      // in case a new task is added, then changes will only happen locally
      int index = _dataList.indexWhere((task) => task.id == id);
      if (index != -1) {
        _dataList[index] = _dataList[index].copyWith(todo: title);
        await _dbService.updateTodo(_dataList[index]);
        notifyListeners();
      }
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      // await _taskApiService.deleteTask(id); simulate the update of a todo
      _dataList.removeWhere((task) => task.id == id);
      await _dbService.deleteTodo(id);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
