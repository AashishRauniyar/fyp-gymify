import 'package:dio/dio.dart';
import 'package:gymify/network/http.dart';
import 'package:gymify/services/storage_service.dart';

class LoginService {
  final StorageService _storageService = SharedPrefsService();

  /// Login function
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await httpClient.post(
        '/login',
        data: {
          'email': email,
          'password': password,
        },
        options: Options(
          headers: {
            
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        // Save the token in SharedPreferences
        final token = response.data['token'];
        await _storageService.setString('auth_token', token);

        // Return user details
        return {
          'success': true,
          'user': response.data['user'],
          'token': token,
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  /// Get token from SharedPreferences
  Future<String?> getToken() async {
    return await _storageService.getString('auth_token');
  }

  /// Logout by clearing the token
  Future<void> logout() async {
    await _storageService.remove('auth_token');
  }
}
