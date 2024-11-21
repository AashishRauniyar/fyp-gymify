import 'package:dio/dio.dart';
import 'package:gymify/constant/api_constant.dart';

final Dio httpClient = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 3),
  headers: {
      'Accept': 'application/json',
    },
)
);
