import 'package:flutter/material.dart';
import 'package:task_manager_maidss/utils/responsive/size_config.dart';

class Constants {
  static double padding = 16;

  // A separate file should be created for all text and messages in the app, in order to be able to change the language much easier, all messages and text will as key to value pairs
  static const String fbButtonText = 'Sign in with Facebook';
  static const String googleButtonText = 'Sign in with Google';

  static const String sharedPrefsKey_user = 'user';
  static const String dbTodos = 'todos.db';
  static const String tableTodos = 'todos';

  static const String baseUrl = "https://dummyjson.com";
  static const String loginUrl = "/auth/login";
  static const Color primaryColor = Color(0xff01FFFF);
  static const Color facebookColor = Color(0xff0866FF);

  static TextStyle primaryButtonTextStyle = TextStyle(
      fontSize: 2 * SizeConfig.textMultiplier!,
      color: Colors.white,
      fontWeight: FontWeight.w800);

  static TextStyle todoCardTextStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 2 * SizeConfig.textMultiplier!,
  );

  static TextStyle todoCardSubTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 1.8 * SizeConfig.textMultiplier!,
      color: Colors.grey);
}
