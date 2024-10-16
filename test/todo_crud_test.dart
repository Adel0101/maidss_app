import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_maidss/features/tasks/task_model.dart';
import 'package:task_manager_maidss/features/tasks/task_view_model.dart';
import 'package:task_manager_maidss/utils/constants.dart';

import 'mocks/mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({
    Constants.sharedPrefsKey_user: json.encode({
      "id": 1,
      "username": "emilys",
      "email": "emily.johnson@x.dummyjson.com",
      "firstName": "Emily",
      "lastName": "Johnson",
      "gender": "female",
      "image": "https://dummyjson.com/icon/emilys/128",
      "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
      "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
    })
  });
  group('TaskViewModel CRUD Tests', () {
    late TaskViewModel taskViewModel;
    late MockTaskApiService mockTaskApiService;
    late MockDbService mockDbService;

    setUp(() {
      mockTaskApiService = MockTaskApiService();
      mockDbService = MockDbService();

      // Initialize TaskViewModel with mocked services
      taskViewModel = TaskViewModel(
        taskApiService: mockTaskApiService,
        dbService: mockDbService,
      );
    });

    test('addTask adds task via API when online', () async {
      // Arrange
      String title = 'New Task';
      Todo apiTask = Todo(
        id: 1,
        todo: title,
        completed: false,
        userId: 0,
      );
      when(mockTaskApiService.addTask(title)).thenAnswer((_) async => apiTask);
      when(mockDbService.insertTodo(apiTask)).thenAnswer((_) async => 1);
      await taskViewModel.addTask(title);
      expect(taskViewModel.dataList.contains(apiTask), true);
      verify(mockTaskApiService.addTask(title)).called(1);
      verify(mockDbService.insertTodo(apiTask)).called(1);
    });

    test('addTask adds task locally when offline', () async {
      String title = 'Offline Task';
      when(mockTaskApiService.addTask(title))
          .thenThrow(Exception('No Internet'));
      when(mockDbService.insertTodo(any)).thenAnswer((_) async => 1);
      await taskViewModel.addTask(title);

      // Assert
      expect(taskViewModel.dataList.length, 1);
      Todo addedTask = taskViewModel.dataList.first;
      expect(addedTask.todo, title);
      verify(mockTaskApiService.addTask(title)).called(1);
      verify(mockDbService.insertTodo(any)).called(1);
    });
  });
}
