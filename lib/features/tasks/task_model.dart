// To parse this JSON data, do
//
//     final tasks = tasksFromJson(jsonString);

import 'dart:convert';

Tasks tasksFromJson(String str) => Tasks.fromJson(json.decode(str));

String tasksToJson(Tasks data) => json.encode(data.toJson());

class Tasks {
  final List<Todo> todos;
  final int total;
  final int skip;
  final int limit;

  Tasks({
    required this.todos,
    required this.total,
    required this.skip,
    required this.limit,
  });

  Tasks copyWith({
    List<Todo>? todos,
    int? total,
    int? skip,
    int? limit,
  }) =>
      Tasks(
        todos: todos ?? this.todos,
        total: total ?? this.total,
        skip: skip ?? this.skip,
        limit: limit ?? this.limit,
      );

  factory Tasks.fromJson(Map<String, dynamic> json) => Tasks(
        todos: List<Todo>.from(json["todos"].map((x) => Todo.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "todos": List<dynamic>.from(todos.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
      };
}

class Todo {
  final int id;
  final String todo;
  final bool completed;
  final int userId;
  bool synced;

  Todo(
      {required this.id,
      required this.todo,
      required this.completed,
      required this.userId,
      this.synced = true});

  Todo copyWith({
    int? id,
    String? todo,
    bool? completed,
    int? userId,
    bool? synced,
  }) =>
      Todo(
        id: id ?? this.id,
        todo: todo ?? this.todo,
        completed: completed ?? this.completed,
        userId: userId ?? this.userId,
        synced: synced ?? this.synced,
      );

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      todo: json['todo'],
      completed: json['completed'], // From API: boolean
      userId: json['userId'],
      synced: true, // Assuming data from API is synced
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed,
      'userId': userId,
    };
  }

  // Map serialization/deserialization for local database
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'],
      todo: map['todo'],
      completed: map['completed'] == 1,
      userId: map['userId'],
      synced: map['synced'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'todo': todo,
      'completed': completed ? 1 : 0,
      'userId': userId,
      'synced': synced ? 1 : 0,
    };
  }
}
