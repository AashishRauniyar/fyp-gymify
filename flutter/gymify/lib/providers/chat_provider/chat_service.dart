import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymify/constant/api_constant.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatProvider extends ChangeNotifier {
  // Socket and state management
  IO.Socket? _socket;
  final List<Map<String, dynamic>> _messages = [];
  String _connectionStatus = 'Disconnected';
  bool _isListening = false;
  bool _isTyping = false;
  String? _currentUserId;
  bool _isInitialized = false;

  // Getters
  bool get isTyping => _isTyping;
  IO.Socket? get socket => _socket;
  List<Map<String, dynamic>> get messages => _messages;
  String get connectionStatus => _connectionStatus;
  bool get isInitialized => _isInitialized;

  // API Methods
  Future<int> startConversation(int userId, int trainerId) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/start"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'userId': userId, 'trainerId': trainerId}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['data']['chat_id'];
      } else {
        throw Exception('Failed to start conversation: ${response.statusCode}');
      }
    } catch (e) {
      print('Error starting conversation: $e');
      rethrow;
    }
  }

  Future<void> fetchMessages(int chatId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/messages/$chatId"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final fetchedMessages = List<Map<String, dynamic>>.from(data['data']);
        _messages.clear();
        _messages.addAll(fetchedMessages);
        notifyListeners();
      } else {
        throw Exception('Failed to fetch messages: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching messages: $e');
      rethrow;
    }
  }

  // Socket initialization and management
  void initializeSocket(String userId) {
    if (_currentUserId == userId && _socket?.connected == true) {
      print('Socket already initialized for user: $userId');
      return;
    }

    // Clean up existing socket if any
    cleanupSocket();

    try {
      _currentUserId = userId;
      print('Initializing socket for user: $userId');

      _socket = IO.io(
        socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(5)
            .setReconnectionDelay(1000)
            .build(),
      );

      _setupSocketListeners(userId);
      _socket!.connect();
      _isInitialized = true;
    } catch (e) {
      print('Error initializing socket: $e');
      _connectionStatus = 'Error: Failed to initialize';
      notifyListeners();
    }
  }

  void _setupSocketListeners(String userId) {
    _socket!.onConnect((_) {
      print('Socket connected for user: $userId');
      _socket!.emit('register', {'userId': userId});
      _connectionStatus = 'Connected';
      notifyListeners();
    });

    _socket!.onDisconnect((_) {
      print('Socket disconnected for user: $userId');
      _connectionStatus = 'Disconnected';
      notifyListeners();
    });

    _socket!.onConnectError((error) {
      print('Socket connection error for user $userId: $error');
      _connectionStatus = 'Connection Error';
      notifyListeners();
    });

    _socket!.onError((error) {
      print('Socket error for user $userId: $error');
      _connectionStatus = 'Error';
      notifyListeners();
    });

    _socket!.onReconnect((_) {
      print('Socket reconnected for user: $userId');
      _socket!.emit('register', {'userId': userId});
      _connectionStatus = 'Reconnected';
      notifyListeners();
    });

    listenToMessages();
  }

  void listenToMessages() {
    if (_isListening) return;
    _isListening = true;

    _socket!.on('register-success', (data) {
      print('Register success: $data');
    });

    _socket!.on('receive_message', (data) {
      print('Message received: $data');
      if (data != null) {
        final isDuplicate = _messages.any(
          (message) => message['message_id'] == data['message_id'],
        );

        if (!isDuplicate) {
          _messages.add(data);
          notifyListeners();
        }
      }
    });

    _socket!.on('user_typing', (data) {
      print('User typing: $data');
      _isTyping = true;
      notifyListeners();
    });

    _socket!.on('user_stopped_typing', (data) {
      print('User stopped typing: $data');
      _isTyping = false;
      notifyListeners();
    });

    _socket!.on('joined_room', (data) {
      print('Joined room: $data');
    });
  }

  // Room management
  void joinRoom(int chatId, int userId) {
    if (!isSocketConnected()) {
      print('Cannot join room: Socket not connected');
      return;
    }

    print('Joining room: $chatId for user: $userId');
    _socket!.emit('join_room', {
      'chatId': chatId,
      'userId': userId,
    });
  }

  // Message handling
  void sendMessage(int chatId, String userId, String message) {
    if (!isSocketConnected()) {
      print('Cannot send message: Socket not connected');
      return;
    }

    print('Sending message in chat: $chatId from user: $userId');
    _socket!.emit('send_message', {
      'chatId': chatId,
      'userId': userId,
      'messageContent': {'text': message},
    });
  }

  void sendTypingEvent(int chatId, String userId, bool isTyping) {
    if (!isSocketConnected()) {
      print('Cannot send typing event: Socket not connected');
      return;
    }

    _socket!.emit(
      isTyping ? 'user_typing' : 'user_stopped_typing',
      {
        'chatId': chatId,
        'userId': userId,
      },
    );
  }

  // Utility methods
  bool isSocketConnected() {
    return _socket?.connected ?? false;
  }

  void cleanupSocket() {
    if (_socket != null) {
      print('Cleaning up socket for user: $_currentUserId');

      // Remove all listeners first
      _socket!.clearListeners();

      // Disconnect and dispose
      _socket!.disconnect();
      _socket!.dispose();

      // Reset all state
      _socket = null;
      _currentUserId = null;
      _isListening = false;
      _isInitialized = false;
      _messages.clear();
      _connectionStatus = 'Disconnected';

      notifyListeners();
    }
  }

  void handleLogout() {
    print('Handling logout, cleaning up socket');
    cleanupSocket();
  }

  // Lifecycle management
  @override
  void dispose() {
    cleanupSocket();
    super.dispose();
  }
}
