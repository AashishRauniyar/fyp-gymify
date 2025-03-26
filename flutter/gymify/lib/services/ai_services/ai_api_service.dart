import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService{
  static  String? apiKey = dotenv.env['GEMINI_API_KEY'];
}