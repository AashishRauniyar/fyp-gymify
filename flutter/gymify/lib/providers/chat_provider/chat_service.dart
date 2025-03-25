
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



// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:gymify/constant/api_constant.dart';
// import 'package:http/http.dart' as http;
// import 'package:socket_io_client/socket_io_client.dart' as IO;

// class ChatProvider extends ChangeNotifier {
//   // Socket and state management
//   IO.Socket? _socket;
//   final List<Map<String, dynamic>> _messages = [];
//   String _connectionStatus = 'Disconnected';
//   bool _isListening = false;
//   bool _isTyping = false;
//   String? _currentUserId;
//   bool _isInitialized = false;
//   bool _hasNewMessages = false;
//   String? _lastMessageFromUser;
//   int? _currentChatId;
  
//   // Message cache to prevent duplication
//   final Set<String> _processedMessageIds = {};
  
//   // Debounce for typing events
//   Timer? _typingTimer;
//   bool _isCurrentlyTyping = false;

//   // Getters
//   bool get isTyping => _isTyping;
//   IO.Socket? get socket => _socket;
//   List<Map<String, dynamic>> get messages => _messages;
//   String get connectionStatus => _connectionStatus;
//   bool get isInitialized => _isInitialized;
//   bool get hasNewMessages => _hasNewMessages;
//   String? get lastMessageFromUser => _lastMessageFromUser;
//   int? get currentChatId => _currentChatId;

//   // Setters
//   set hasNewMessages(bool value) {
//     _hasNewMessages = value;
//     notifyListeners();
//   }

//   // API Methods
//   Future<int> startConversation(int userId, int trainerId) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$baseUrl/start"),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'userId': userId, 'trainerId': trainerId}),
//       );

//       if (response.statusCode == 201) {
//         final data = jsonDecode(response.body);
//         return data['data']['chat_id'];
//       } else {
//         throw Exception('Failed to start conversation: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error starting conversation: $e');
//       rethrow;
//     }
//   }

//   Future<void> fetchMessages(int chatId) async {
//     try {
//       _currentChatId = chatId;
//       final response = await http.get(Uri.parse("$baseUrl/messages/$chatId"));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final fetchedMessages = List<Map<String, dynamic>>.from(data['data']);
        
//         // Clear existing messages for this chat
//         _messages.clear();
//         _processedMessageIds.clear();
        
//         // Add fetched messages and track their IDs
//         for (var message in fetchedMessages) {
//           _messages.add(message);
//           _processedMessageIds.add(message['message_id'].toString());
//         }
        
//         // Sort messages by timestamp
//         _messages.sort((a, b) => 
//           DateTime.parse(a['sent_at']).compareTo(DateTime.parse(b['sent_at']))
//         );
        
//         notifyListeners();
//       } else {
//         throw Exception('Failed to fetch messages: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error fetching messages: $e');
//       rethrow;
//     }
//   }

//   Future<List<Map<String, dynamic>>> getConversations(int userId) async {
//     try {
//       final response = await http.get(Uri.parse("$baseUrl/conversations/$userId"));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return List<Map<String, dynamic>>.from(data['data']);
//       } else {
//         throw Exception('Failed to fetch conversations: ${response.statusCode}');
//       }
//     } catch (e) {
//       debugPrint('Error fetching conversations: $e');
//       rethrow;
//     }
//   }

//   // Socket initialization and management
//   void initializeSocket(String userId) {
//     if (_currentUserId == userId && _socket?.connected == true) {
//       debugPrint('Socket already initialized for user: $userId');
//       return;
//     }

//     // Clean up existing socket if any
//     cleanupSocket();

//     try {
//       _currentUserId = userId;
//       debugPrint('Initializing socket for user: $userId');

//       _socket = IO.io(
//         socketUrl,
//         IO.OptionBuilder()
//             .setTransports(['websocket'])
//             .disableAutoConnect()
//             .enableReconnection()
//             .setReconnectionAttempts(5)
//             .setReconnectionDelay(1000)
//             .setExtraHeaders({'userId': userId}) // Add user ID in headers
//             .build(),
//       );

//       _setupSocketListeners(userId);
//       _socket!.connect();
//       _isInitialized = true;
      
//     } catch (e) {
//       debugPrint('Error initializing socket: $e');
//       _connectionStatus = 'Error: Failed to initialize';
//       notifyListeners();
//     }
//   }

//   void _setupSocketListeners(String userId) {
//     _socket!.onConnect((_) {
//       debugPrint('Socket connected for user: $userId');
//       _socket!.emit('register', {'userId': userId});
//       _connectionStatus = 'Online';
//       notifyListeners();
//     });

//     _socket!.onDisconnect((_) {
//       debugPrint('Socket disconnected for user: $userId');
//       _connectionStatus = 'Offline';
//       notifyListeners();
//     });

//     _socket!.onConnectError((error) {
//       debugPrint('Socket connection error for user $userId: $error');
//       _connectionStatus = 'Connection Error';
//       notifyListeners();
//     });

//     _socket!.onError((error) {
//       debugPrint('Socket error for user $userId: $error');
//       _connectionStatus = 'Error';
//       notifyListeners();
//     });

//     _socket!.onReconnect((_) {
//       debugPrint('Socket reconnected for user: $userId');
//       _socket!.emit('register', {'userId': userId});
//       _connectionStatus = 'Online';
      
//       // Rejoin current chat room if any
//       if (_currentChatId != null) {
//         joinRoom(_currentChatId!, int.parse(userId));
//       }
      
//       notifyListeners();
//     });

//     _socket!.onReconnectAttempt((attemptNumber) {
//       _connectionStatus = 'Reconnecting... ($attemptNumber)';
//       notifyListeners();
//     });

//     listenToMessages();
//   }

//   void listenToMessages() {
//     if (_isListening) return;
//     _isListening = true;

//     _socket!.on('register-success', (data) {
//       debugPrint('Register success: $data');
//     });

//     _socket!.on('receive_message', (data) {
//       debugPrint('Message received: $data');
//       if (data != null) {
//         final messageId = data['message_id'].toString();
//         // Check if this message is already processed
//         if (!_processedMessageIds.contains(messageId)) {
//           _processedMessageIds.add(messageId);
//           _messages.add(data);
          
//           // Track metadata for new messages
//           _hasNewMessages = true;
//           _lastMessageFromUser = data['sender_id'].toString();
          
//           notifyListeners();
//         }
//       }
//     });

//     _socket!.on('user_typing', (data) {
//       debugPrint('User typing: $data');
//       _isTyping = true;
//       notifyListeners();
//     });

//     _socket!.on('user_stopped_typing', (data) {
//       debugPrint('User stopped typing: $data');
//       _isTyping = false;
//       notifyListeners();
//     });

//     _socket!.on('joined_room', (data) {
//       debugPrint('Joined room: $data');
//     });
    
//     _socket!.on('message_delivered', (data) {
//       debugPrint('Message delivered: $data');
//       _updateMessageStatus(data['message_id'], 'delivered');
//     });
    
//     _socket!.on('message_read', (data) {
//       debugPrint('Message read: $data');
//       _updateMessageStatus(data['message_id'], 'read');
//     });
//   }

//   // Room management
//   void joinRoom(int chatId, int userId) {
//     if (!isSocketConnected()) {
//       debugPrint('Cannot join room: Socket not connected');
//       return;
//     }

//     _currentChatId = chatId;
//     debugPrint('Joining room: $chatId for user: $userId');
//     _socket!.emit('join_room', {
//       'chatId': chatId,
//       'userId': userId,
//     });
//   }

//   // Message handling
//   void sendMessage(int chatId, String userId, String message) {
//     if (!isSocketConnected()) {
//       debugPrint('Cannot send message: Socket not connected');
//       return;
//     }

//     debugPrint('Sending message in chat: $chatId from user: $userId');
    
//     // Create a temporary message ID for optimistic updates
//     final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    
//     // Add message to local state immediately for optimistic UI update
//     final newMessage = {
//       'message_id': tempId,
//       'chat_id': chatId,
//       'sender_id': userId,
//       'message_content': {'text': message},
//       'sent_at': DateTime.now().toIso8601String(),
//       'status': 'sending'
//     };
    
//     _messages.add(newMessage);
//     _processedMessageIds.add(tempId);
//     _lastMessageFromUser = userId;
//     _hasNewMessages = true;
    
//     notifyListeners();

//     // Emit the message to the server
//     _socket!.emit('send_message', {
//       'chatId': chatId,
//       'userId': userId,
//       'messageContent': {'text': message},
//       'clientTempId': tempId, // Include the temp ID for correlation
//     });
    
//     // Listen for acknowledgment
//     _socket!.once('message_sent', (data) {
//       debugPrint('Message sent acknowledgment: $data');
      
//       // Update the temporary message with the real message ID and status
//       _updateTempMessage(tempId, data);
//     });
//   }

//   void _updateTempMessage(String tempId, Map<String, dynamic> serverData) {
//     final index = _messages.indexWhere((msg) => msg['message_id'] == tempId);
//     if (index != -1) {
//       // Update the message with server data
//       _messages[index] = {
//         ..._messages[index],
//         'message_id': serverData['message_id'],
//         'status': 'sent',
//         'sent_at': serverData['sent_at'] ?? _messages[index]['sent_at'],
//       };
      
//       // Update the processed IDs set
//       _processedMessageIds.remove(tempId);
//       _processedMessageIds.add(serverData['message_id'].toString());
      
//       notifyListeners();
//     }
//   }

//   void _updateMessageStatus(String messageId, String status) {
//     final index = _messages.indexWhere((msg) => msg['message_id'].toString() == messageId);
//     if (index != -1) {
//       _messages[index] = {
//         ..._messages[index],
//         'status': status,
//       };
//       notifyListeners();
//     }
//   }

//   void markMessageAsRead(String messageId) {
//     if (!isSocketConnected() || _currentChatId == null) {
//       debugPrint('Cannot mark message as read: Socket not connected or no active chat');
//       return;
//     }
    
//     _socket!.emit('mark_as_read', {
//       'chatId': _currentChatId,
//       'messageId': messageId,
//     });
//   }

//   void markAllMessagesAsRead() {
//     if (!isSocketConnected() || _currentChatId == null || _currentUserId == null) {
//       debugPrint('Cannot mark messages as read: Socket not connected or no active chat');
//       return;
//     }
    
//     _socket!.emit('mark_all_as_read', {
//       'chatId': _currentChatId,
//       'userId': _currentUserId,
//     });
    
//     // Update local state to mark all messages as read
//     for (int i = 0; i < _messages.length; i++) {
//       if (_messages[i]['sender_id'].toString() != _currentUserId) {
//         _messages[i] = {
//           ..._messages[i],
//           'status': 'read',
//         };
//       }
//     }
    
//     notifyListeners();
//   }

//   void sendTypingEvent(int chatId, String userId, bool isTyping) {
//     if (!isSocketConnected()) {
//       debugPrint('Cannot send typing event: Socket not connected');
//       return;
//     }
    
//     // Debounce typing events to reduce network traffic
//     if (isTyping) {
//       if (!_isCurrentlyTyping) {
//         _isCurrentlyTyping = true;
//         _socket!.emit('user_typing', {
//           'chatId': chatId,
//           'userId': userId,
//         });
//       }
      
//       // Reset the timer on new typing events
//       _typingTimer?.cancel();
//       _typingTimer = Timer(const Duration(seconds: 2), () {
//         _isCurrentlyTyping = false;
//         _socket!.emit('user_stopped_typing', {
//           'chatId': chatId,
//           'userId': userId,
//         });
//       });
//     } else if (_isCurrentlyTyping) {
//       _typingTimer?.cancel();
//       _isCurrentlyTyping = false;
//       _socket!.emit('user_stopped_typing', {
//         'chatId': chatId,
//         'userId': userId,
//       });
//     }
//   }

//   // Utility methods
//   bool isSocketConnected() {
//     return _socket?.connected ?? false;
//   }

//   void cleanupSocket() {
//     // Cancel any pending timers
//     _typingTimer?.cancel();
    
//     if (_socket != null) {
//       debugPrint('Cleaning up socket for user: $_currentUserId');
      
//       // Remove all listeners first
//       _socket!.clearListeners();
      
//       // Disconnect and dispose
//       _socket!.disconnect();
//       _socket!.dispose();
      
//       // Reset all state
//       _socket = null;
//       _currentUserId = null;
//       _currentChatId = null;
//       _isListening = false;
//       _isInitialized = false;
//       _isCurrentlyTyping = false;
//       _messages.clear();
//       _processedMessageIds.clear();
//       _hasNewMessages = false;
//       _lastMessageFromUser = null;
//       _connectionStatus = 'Disconnected';
      
//       notifyListeners();
//     }
//   }

//   void handleLogout() {
//     debugPrint('Handling logout, cleaning up socket');
//     cleanupSocket();
//   }

//   // Debug methods
//   void debugMessages() {
//     debugPrint('Current messages: ${_messages.length}');
//     for (var msg in _messages) {
//       debugPrint('ID: ${msg['message_id']}, Sender: ${msg['sender_id']}, Status: ${msg['status'] ?? 'unknown'}');
//     }
//   }

//   // Helper methods for chat management
//   bool hasUnreadMessages() {
//     if (_currentUserId == null) return false;
    
//     return _messages.any((msg) => 
//       msg['sender_id'].toString() != _currentUserId && 
//       (msg['status'] == null || msg['status'] != 'read')
//     );
//   }

//   int unreadMessageCount() {
//     if (_currentUserId == null) return 0;
    
//     return _messages.where((msg) => 
//       msg['sender_id'].toString() != _currentUserId && 
//       (msg['status'] == null || msg['status'] != 'read')
//     ).length;
//   }

//   // Methods for handling message failures and retries
//   void retryMessage(String messageId) {
//     final index = _messages.indexWhere((msg) => msg['message_id'] == messageId);
//     if (index != -1) {
//       final message = _messages[index];
      
//       // Update status to "sending" again
//       _messages[index] = {
//         ...message,
//         'status': 'sending',
//       };
//       notifyListeners();
      
//       // Re-send the message
//       _socket!.emit('send_message', {
//         'chatId': message['chat_id'],
//         'userId': message['sender_id'],
//         'messageContent': message['message_content'],
//         'clientTempId': messageId, // For correlation
//       });
//     }
//   }

//   void deleteMessage(String messageId) {
//     if (!isSocketConnected() || _currentChatId == null) {
//       debugPrint('Cannot delete message: Socket not connected or no active chat');
//       return;
//     }
    
//     final index = _messages.indexWhere((msg) => msg['message_id'] == messageId);
//     if (index != -1) {
//       // Update local state first for immediate UI feedback
//       _messages.removeAt(index);
//       _processedMessageIds.remove(messageId);
//       notifyListeners();
      
//       // Then notify the server
//       _socket!.emit('delete_message', {
//         'chatId': _currentChatId,
//         'messageId': messageId,
//       });
//     }
//   }

//   // Methods for message search
//   List<Map<String, dynamic>> searchMessages(String query) {
//     if (query.isEmpty) return [];
    
//     final lowercaseQuery = query.toLowerCase();
//     return _messages.where((msg) {
//       final messageText = msg['message_content']?['text']?.toString().toLowerCase() ?? '';
//       return messageText.contains(lowercaseQuery);
//     }).toList();
//   }

//   // Advanced socket handling
//   void reconnect() {
//     if (_socket != null && !_socket!.connected && _currentUserId != null) {
//       debugPrint('Manually reconnecting socket for user: $_currentUserId');
//       _socket!.connect();
//     }
//   }
  
//   // Lifecycle management
//   @override
//   void dispose() {
//     _typingTimer?.cancel();
//     cleanupSocket();
//     super.dispose();
//   }
// }
