import 'package:dio/dio.dart';


class AuthInterceptor extends Interceptor {
  

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // Add the token to headers if available
    final token = await getToken(); // Replace with your token retrieval logic
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Handle token expiration (e.g., refresh token or logout user)
      print("Token expired, logging out...");
    }
    super.onError(err, handler);
  }

  Future<String?> getToken() async {
    // Implement logic to retrieve token from secure storage
    


    return null; // Replace with actual token retrieval logic
  }
}
