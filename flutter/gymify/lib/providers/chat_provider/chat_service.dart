// import 'package:flutter/material.dart';
// import 'package:gymify/network/http.dart';
// import 'package:gymify/models/api_response.dart';

// class ChatProvider with ChangeNotifier {
//   List<dynamic> _conversations = [];
//   List<dynamic> get conversations => _conversations;

//   List<dynamic> _messages = [];
//   List<dynamic> get messages => _messages;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }


//   Future<void> fetchTrainers() async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.get('/trainers');
//       if (response.data['status'] == 'success') {
//         _trainers = response.data['data'];
//       }
//     } catch (e) {
//       print('Error fetching trainers: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }



//   Future<void> fetchConversations(int userId) async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.get('/get-all-conversations/$userId');
//       final apiResponse = ApiResponse<List<dynamic>>.fromJson(
//         response.data,
//         (data) => data as List,
//       );
//       if (apiResponse.status == 'success') {
//         _conversations = apiResponse.data;
//       }
//     } catch (e) {
//       print('Error fetching conversations: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> fetchMessages(int chatId, {int limit = 50, int offset = 0}) async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.get('/get-messages/$chatId', queryParameters: {
//         'limit': limit,
//         'offset': offset,
//       });
//       final apiResponse = ApiResponse<List<dynamic>>.fromJson(
//         response.data,
//         (data) => data as List,
//       );
//       if (apiResponse.status == 'success') {
//         _messages = apiResponse.data;
//       }
//     } catch (e) {
//       print('Error fetching messages: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   Future<void> sendMessage(Map<String, dynamic> messageData) async {
//     try {
//       final response = await httpClient.post('/send-message', data: messageData);
//       final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
//         response.data,
//         (data) => data as Map<String, dynamic>,
//       );
//       if (apiResponse.status == 'success') {
//         _messages.add(apiResponse.data);
//         notifyListeners();
//       }
//     } catch (e) {
//       print('Error sending message: $e');
//     }
//   }
// }
