import 'package:dio/dio.dart';
import 'package:task_manager_maidss/utils/constants.dart';

class AuthApiService {
  final Dio _dio = Dio();

  AuthApiService() {
    _dio.options.baseUrl = Constants.baseUrl;
  }

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        Constants.loginUrl,
        data: {'username': username, 'password': password},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // Add other headers if needed
          },
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        throw Exception('No internet connection');
      } else {
        throw Exception(e.response?.data['message'] ?? 'Failed to login');
      }
    }
  }
}
