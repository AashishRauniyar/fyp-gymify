import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:gymify/constant/api_constant.dart';
import 'package:gymify/services/storage_service.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart';

StorageService _storageService = SharedPrefsService();

var token = _storageService.getString('auth_token');

// final Dio httpClient = Dio(BaseOptions(
//   baseUrl: baseUrl,
//   connectTimeout: const Duration(seconds: 10),
//   receiveTimeout: const Duration(seconds: 10),
//   headers: {
//             'Authorization': 'Bearer $token',
//             'Accept': 'application/json',
//             'Content-Type': 'application/json',
//           },
// )
// );

final Dio httpClient = Dio(BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: const Duration(seconds: 10),
  receiveTimeout: const Duration(seconds: 10),
  headers: {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  },
))
  ..interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      // Get the token from SharedPreferences dynamically before each request
      String? token = await _storageService.getString('auth_token');

      if (token != null) {
        // Add the token to the Authorization header
        options.headers['Authorization'] = 'Bearer $token';
      }

      return handler.next(options); // Continue with the request
    },
  ));

MediaType getContentType(File file) {
  // Rename `extension` to `fileExtension` to avoid conflicts
  String fileExtension = extension(file.path).toLowerCase();
  switch (fileExtension) {
    case '.jpg':
    case '.jpeg':
      return MediaType('image', 'jpeg');
    case '.png':
      return MediaType('image', 'png');
    case '.gif':
      return MediaType('image', 'gif');
    case '.mp4':
      return MediaType('video', 'mp4');
    default:
      return MediaType(
          'application', 'octet-stream'); // Fallback for unknown types
  }
}

/// Re-encodes an image as JPEG to ensure proper MIME type
Future<File> reEncodeImage(File file) async {
  final Uint8List imageBytes = await file.readAsBytes();
  final img.Image? decodedImage = img.decodeImage(imageBytes);
  if (decodedImage != null) {
    final Uint8List jpegImage = Uint8List.fromList(img.encodeJpg(decodedImage));
    final File convertedFile = File('${file.path}.jpeg');
    await convertedFile.writeAsBytes(jpegImage);
    return convertedFile;
  }
  return file;
}
