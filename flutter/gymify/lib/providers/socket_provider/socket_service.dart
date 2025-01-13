// import 'package:flutter/material.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class SocketProvider with ChangeNotifier {
//   late IO.Socket _socket;
//   bool _isConnected = false;
//   List<Map<String, dynamic>> _messages = [];

//   // Getters
//   bool get isConnected => _isConnected;
//   List<Map<String, dynamic>> get messages => _messages;

//   // Initialize and connect the socket
//   void connectSocket(String userId) {
//     _socket = IO.io('ws://localhost:8000/', <String, dynamic>{
//       'transports': ['websocket'],
//       'autoConnect': false,
//     });

//     _socket.connect();

//     // Listen for connection events
//     _socket.onConnect((_) {
//       print('Connected to the server');
//       _isConnected = true;
//       register(userId);
//       notifyListeners(); // Notify UI of connection status
//     });

//     _socket.on('register-success', (data) {
//       print('Register success: $data');
//     });

//     _socket.on('join-room-error', (data) {
//       print('Error joining room: $data');
//     });

//     _socket.onDisconnect((_) {
//       print('Disconnected from server');
//       _isConnected = false;
//       notifyListeners(); // Notify UI of disconnection
//     });

//     // Listen for messages
//     _socket.on('receive_message', (data) {
//       _messages.add(data); // Add received message to the list
//       notifyListeners(); // Notify UI of new messages
//     });
//   }

//   // register
//   void register(String userId) {
//     _socket.emit('register', {'userId': userId});
//   }


//   // Join a room
//   void joinRoom(int chatId, String userId) {
//     _socket.emit('join_room', {'chatId': chatId, 'userId': userId});
//     _socket.on('joined_room', (data) {
//       print('Joined room: $data');
//     });
//   }

//   // Send a message
//   void sendMessage(int chatId, String userId, String message) {
//     _socket.emit('send_message', {
//       'chatId': chatId,
//       'userId': userId,
//       'messageContent': {'text': message},
//     });
//   }

//   // Disconnect the socket
//   void disconnect() {
//     _socket.disconnect();
//     _isConnected = false;
//     notifyListeners(); // Notify UI of disconnection
//   }

//   // Clear messages
//   void clearMessages() {
//     _messages.clear();
//     notifyListeners(); // Notify UI of message state
//   }
// }


import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketProvider with ChangeNotifier {
  late IO.Socket _socket;
  bool _isConnected = false;
  Map<int, List<Map<String, dynamic>>> _roomMessages = {}; // Room-specific messages
  String? _errorMessage;

  // Getters
  bool get isConnected => _isConnected;
  Map<int, List<Map<String, dynamic>>> get roomMessages => _roomMessages;
  String? get errorMessage => _errorMessage;

  // Initialize and connect the socket
  void connectSocket(String userId) {
    _socket = IO.io('ws://localhost:8000/', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();
    _setupListeners(userId);
  }

  // Register event listeners
  void _setupListeners(String userId) {
    _socket.onConnect((_) {
      print('Connected to the server');
      _isConnected = true;
      notifyListeners();
      register(userId);
    });

    _socket.onDisconnect((_) {
      print('Disconnected from server');
      _isConnected = false;
      notifyListeners();
    });

    _socket.on('register-success', (data) {
      print('Register success: $data');
    });

    _socket.on('receive_message', (data) {
      _handleReceiveMessage(data);
    });

    _socket.on('join-room-error', (data) {
      _errorMessage = data['message'];
      notifyListeners();
    });
  }

  // Handle received messages
  void _handleReceiveMessage(Map<String, dynamic> data) {
    final chatId = data['chatId'];
    _roomMessages.putIfAbsent(chatId, () => []).add(data);
    notifyListeners();
  }

  // Register user
  void register(String userId) {
    _socket.emit('register', {'userId': userId});
  }

  // Join a room
  void joinRoom(int chatId, String userId) {
    _socket.emit('join_room', {'chatId': chatId, 'userId': userId});
    _socket.on('joined_room', (data) {
      print('Joined room: $data');
    });
  }

  // Send a message
  void sendMessage(int chatId, String userId, String message) {
    _socket.emit('send_message', {
      'chatId': chatId,
      'userId': userId,
      'messageContent': {'text': message},
    });
  }

  // Get messages for a specific room
  List<Map<String, dynamic>> getMessagesForRoom(int chatId) {
    return _roomMessages[chatId] ?? [];
  }

  // Disconnect the socket
  void disconnect() {
    _socket.disconnect();
    _isConnected = false;
    notifyListeners();
  }
}
