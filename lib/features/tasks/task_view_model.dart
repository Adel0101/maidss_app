import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/models/user.dart';
import 'package:task_manager_maidss/services/api/task_service.dart';
import 'package:task_manager_maidss/services/db_service.dart';
import 'package:task_manager_maidss/utils/constants.dart';

enum DataState {
  Uninitialized,
  Refreshing,
  Initial_Fetching,
  More_Fetching,
  Fetched,
  Fetched_Local,
  No_More_Data,
  Error
}

class TaskViewModel extends ChangeNotifier {
  final TaskApiService _taskApiService;
  final DbService _dbService;

  TaskViewModel({TaskApiService? taskApiService, DbService? dbService})
      : _taskApiService = taskApiService ?? TaskApiService(),
        _dbService = dbService ?? DbService();

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

  Future<void> fetchData({bool isRefresh = false}) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final User user =
        userFromJson(_prefs.getString(Constants.sharedPrefsKey_user)!);
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
    if (_didLastLoad) {
      _dataState = DataState.No_More_Data;
    } else {
      try {
        tasks = await _taskApiService.fetchTasks(
          user.id,
          limit: _limit,
          skip: _currentPageNumber * _limit,
        );
        _dataList += tasks!.todos;
        _dataState = DataState.Fetched;
        await _dbService.insertTodosBulk(_dataList);
        _totalPages = (tasks!.total / _limit).ceil();
        _currentPageNumber++;
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print('No network fetched data locally');
        }
        _dataList = (await _dbService.getAllTodos()).reversed.toList();
        _dataState = DataState.Fetched_Local;
        notifyListeners();
      }
    }
  }

  Future<void> addTask(String title) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    final User user =
        userFromJson(_prefs.getString(Constants.sharedPrefsKey_user)!);
    try {
      Todo task = await _taskApiService.addTask(title, user.id);
      _dataList.insert(0, task);
      await _dbService.insertTodo(task);
      notifyListeners();
    } catch (e) {
      Todo todo = Todo(
          id: DateTime.now().microsecondsSinceEpoch,
          todo: title,
          completed: false,
          userId: user.id);
      _dataList.insert(0, todo);
      await _dbService.insertTodo(todo);
      notifyListeners();
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
      /*Todo updatedTask = await _taskApiService.updateTask(id, status);*/ // simulate the update of a todo, since the return object wont contain the changes
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
      // await _taskApiService.deleteTask(id); //simulate the update of a todo, since the return object wont contain the changes
      _dataList.removeWhere((task) => task.id == id);
      await _dbService.deleteTodo(id);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }
}
