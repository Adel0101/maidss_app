import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_maidss/services/api/auth_service.dart';
import 'package:task_manager_maidss/utils/constants.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthApiService _authApiService = AuthApiService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String? _user;
  String? get token => _user;

  Future<void> loadUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _user = prefs.getString(Constants.sharedPrefsKey_user);
    if (_user != null && _user!.isNotEmpty) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final SharedPreferences _prefs = await SharedPreferences.getInstance();
    _isLoading = true;
    notifyListeners();

    try {
      final Map<String, dynamic> userData =
          await _authApiService.login(username, password);
      if (userData.isNotEmpty) {
        await _prefs.setString(
            Constants.sharedPrefsKey_user, json.encode(userData));
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw e;
    }
  }

  Future<void> logout() async {
    _user = null;
    _isLoggedIn = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(Constants.sharedPrefsKey_user);
    notifyListeners();
  }

  String? validateUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter username';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter password';
    }
    return null;
  }
}
