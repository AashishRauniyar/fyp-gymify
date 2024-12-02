
import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

// A generic API response model
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final String status;
  final String message;
  final T data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) => _$ApiResponseToJson(this, toJsonT);
}
