import 'package:flutter/material.dart';

class Constants {
  static double padding = 16;

  static const String dbTodos = 'todos.db';
  static const String tableTodos = 'todos';

  static const String baseUrl = "https://dummyjson.com";
  static const Color primaryColor = Color(0xff01FFFF);
  static const Color facebookColor = Color(0xff0866FF);

  static const TextStyle primaryButtonTextStyle =
      TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w800);
  static const TextStyle todoCardTextStyle =
      TextStyle(fontWeight: FontWeight.w700, fontSize: 18);
  static const TextStyle todoCardSubTextStyle =
      TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.grey);
}
