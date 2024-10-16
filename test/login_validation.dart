import 'package:flutter_test/flutter_test.dart';
import 'package:task_manager_maidss/features/login/auth_view_model.dart';

void main() {
  group('AuthViewModel Validation Tests', () {
    late AuthViewModel authViewModel;

    setUp(() {
      authViewModel = AuthViewModel();
    });

    // Username Validation Tests
    test('Empty username returns error string', () {
      String? username = '';
      String? result = authViewModel.validateUsername(username);
      expect(result, 'Please enter username');
    });

    test('Null username returns error string', () {
      String? username;
      String? result = authViewModel.validateUsername(username);
      expect(result, 'Please enter username');
    });

    test('Valid username returns null', () {
      String? username = 'emilys';
      String? result = authViewModel.validateUsername(username);
      expect(result, null);
    });

    // Password Validation Tests
    test('Empty password returns error string', () {
      String? password = '';
      String? result = authViewModel.validatePassword(password);
      expect(result, 'Please enter password');
    });

    test('Null password returns error string', () {
      String? password;
      String? result = authViewModel.validatePassword(password);
      expect(result, 'Please enter password');
    });

    test('Valid password returns null', () {
      String? password = 'emilyspass';
      String? result = authViewModel.validatePassword(password);
      expect(result, null);
    });
  });
}
