// import 'package:flutter/material.dart';
// import 'package:gymify/models/api_response.dart';
// import 'package:gymify/models/attendance_models/attendance_model.dart';
// import 'package:gymify/network/http.dart';
//  // We'll create this next
// import 'package:intl/intl.dart';

// class AttendanceProvider with ChangeNotifier {
//   List<Attendance> _attendanceHistory = [];
//   List<Attendance> get attendanceHistory => _attendanceHistory;

//   Map<DateTime, bool> _attendanceDays = {};
//   Map<DateTime, bool> get attendanceDays => _attendanceDays;

//   int _totalAttendance = 0;
//   int get totalAttendance => _totalAttendance;

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   bool _hasError = false;
//   bool get hasError => _hasError;

//   String _errorMessage = '';
//   String get errorMessage => _errorMessage;

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(bool error, [String message = '']) {
//     _hasError = error;
//     _errorMessage = message;
//     notifyListeners();
//   }

//   // Fetch attendance history for a specific user
//   Future<void> fetchAttendanceHistory(int userId, {DateTime? startDate, DateTime? endDate}) async {
//     _setLoading(true);
//     _setError(false, '');

//     try {
//       // Prepare query parameters
//       Map<String, dynamic> queryParams = {};
//       if (startDate != null) {
//         queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(startDate);
//       }
//       if (endDate != null) {
//         queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(endDate);
//       }

//       final response = await httpClient.get(
//         '/attendance/user/$userId',
//         queryParameters: queryParams,
//       );

//       final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
//         response.data,
//         (data) => data as Map<String, dynamic>,
//       );

//       if (apiResponse.status == 'success') {
//         final attendanceList = (apiResponse.data['attendance'] as List)
//             .map((item) => Attendance.fromJson(item))
//             .toList();
//         _attendanceHistory = attendanceList;
//         _totalAttendance = apiResponse.data['total'] as int;

//         // Create a map of attendance days for easy lookup
//         _attendanceDays = {};
//         for (var attendance in _attendanceHistory) {
//           // Only the date part matters for calendar, not the time
//           final dateOnly = DateTime(
//             attendance.attendanceDate.year,
//             attendance.attendanceDate.month,
//             attendance.attendanceDate.day,
//           );
//           _attendanceDays[dateOnly] = true;
//         }
//       } else {
//         _setError(true, apiResponse.message);
//         throw Exception(apiResponse.message.isNotEmpty
//             ? apiResponse.message
//             : 'Unknown error');
//       }
//     } catch (e) {
//       _setError(true, e.toString());
//       print('Error fetching attendance history: $e');
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Get today's attendance for all users (admin functionality)
//   Future<List<Attendance>> fetchTodayAttendance() async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.get('/attendance/today');

//       final apiResponse = ApiResponse<List<dynamic>>.fromJson(
//         response.data,
//         (data) => data as List<dynamic>,
//       );

//       if (apiResponse.status == 'success') {
//         return apiResponse.data
//             .map((item) => Attendance.fromJson(item as Map<String, dynamic>))
//             .toList();
//       } else {
//         throw Exception(apiResponse.message.isNotEmpty
//             ? apiResponse.message
//             : 'Unknown error');
//       }
//     } catch (e) {
//       print('Error fetching today\'s attendance: $e');
//       return [];
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Mark attendance for a user using their card number
//   Future<bool> markAttendance(String cardNumber) async {
//     _setLoading(true);
//     try {
//       final response = await httpClient.post(
//         '/attendance',
//         data: {'card_number': cardNumber},
//       );

//       final responseData = response.data;

//       return responseData['status'] == 'success';
//     } catch (e) {
//       print('Error marking attendance: $e');
//       return false;
//     } finally {
//       _setLoading(false);
//     }
//   }

//   // Calculate attendance statistics
//   Map<String, dynamic> getAttendanceStats({int? daysToConsider}) {
//     if (_attendanceHistory.isEmpty) {
//       return {
//         'attendanceRate': 0.0,
//         'consecutiveDays': 0,
//         'currentStreak': 0,
//         'longestStreak': 0,
//       };
//     }

//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);

//     // Sort attendance by date (newest first)
//     final sortedAttendance = List<Attendance>.from(_attendanceHistory)
//       ..sort((a, b) => b.attendanceDate.compareTo(a.attendanceDate));

//     // Calculate attendance rate
//     double attendanceRate = 0.0;
//     if (daysToConsider != null) {
//       final considerStartDate = today.subtract(Duration(days: daysToConsider - 1));
//       int daysPresent = 0;

//       for (int i = 0; i < daysToConsider; i++) {
//         final checkDate = considerStartDate.add(Duration(days: i));
//         if (_attendanceDays.containsKey(checkDate)) {
//           daysPresent++;
//         }
//       }

//       attendanceRate = daysPresent / daysToConsider;
//     }

//     // Calculate current streak
//     int currentStreak = 0;
//     if (_attendanceDays.containsKey(today)) {
//       currentStreak = 1;
//       var checkDate = today.subtract(const Duration(days: 1));

//       while (_attendanceDays.containsKey(checkDate)) {
//         currentStreak++;
//         checkDate = checkDate.subtract(const Duration(days: 1));
//       }
//     } else {
//       var checkDate = today.subtract(const Duration(days: 1));
//       if (_attendanceDays.containsKey(checkDate)) {
//         currentStreak = 1;
//         checkDate = checkDate.subtract(const Duration(days: 1));

//         while (_attendanceDays.containsKey(checkDate)) {
//           currentStreak++;
//           checkDate = checkDate.subtract(const Duration(days: 1));
//         }
//       }
//     }

//     // Calculate longest streak
//     int longestStreak = 0;
//     int consecutiveDays = 0;

//     // Get all dates and sort them
//     List<DateTime> attendanceDates = _attendanceDays.keys.toList();
//     attendanceDates.sort((a, b) => a.compareTo(b));

//     if (attendanceDates.isNotEmpty) {
//       consecutiveDays = 1;
//       longestStreak = 1;

//       for (int i = 1; i < attendanceDates.length; i++) {
//         final difference = attendanceDates[i].difference(attendanceDates[i - 1]).inDays;

//         if (difference == 1) {
//           consecutiveDays++;
//           longestStreak = consecutiveDays > longestStreak ? consecutiveDays : longestStreak;
//         } else {
//           consecutiveDays = 1;
//         }
//       }
//     }

//     return {
//       'attendanceRate': attendanceRate,
//       'consecutiveDays': consecutiveDays,
//       'currentStreak': currentStreak,
//       'longestStreak': longestStreak,
//     };
//   }

//   // Get month's attendance rate
//   double getMonthAttendanceRate(DateTime month) {
//     final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
//     int presentDays = 0;

//     for (int day = 1; day <= daysInMonth; day++) {
//       final date = DateTime(month.year, month.month, day);
//       if (_attendanceDays.containsKey(date)) {
//         presentDays++;
//       }
//     }

//     return presentDays / daysInMonth;
//   }

//   // Clear attendance data
//   void clearAttendanceData() {
//     _attendanceHistory = [];
//     _attendanceDays = {};
//     _totalAttendance = 0;
//     notifyListeners();
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/models/attendance_models/attendance_model.dart';
import 'package:gymify/network/http.dart';
import 'package:intl/intl.dart';

class AttendanceProvider with ChangeNotifier {
  List<Attendance> _attendanceHistory = [];
  List<Attendance> get attendanceHistory => _attendanceHistory;

  Map<DateTime, bool> _attendanceDays = {};
  Map<DateTime, bool> get attendanceDays => _attendanceDays;

  int _totalAttendance = 0;
  int get totalAttendance => _totalAttendance;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(bool error, [String message = '']) {
    _hasError = error;
    _errorMessage = message;
    notifyListeners();
  }

  // Fetch attendance history for a specific user
  Future<void> fetchAttendanceHistory(int userId,
      {DateTime? startDate, DateTime? endDate}) async {
    _setLoading(true);
    _setError(false, '');

    try {
      // Prepare query parameters
      Map<String, dynamic> queryParams = {};
      if (startDate != null) {
        queryParams['start_date'] = DateFormat('yyyy-MM-dd').format(startDate);
      }
      if (endDate != null) {
        queryParams['end_date'] = DateFormat('yyyy-MM-dd').format(endDate);
      }

      final response = await httpClient.get(
        '/attendance/user/$userId',
        queryParameters: queryParams,
      );

      // Get direct response data
      final responseData = response.data;

      if (responseData != null && responseData['status'] == 'success') {
        // The response has 'data' as the key containing attendance information
        final data = responseData['data'];

        if (data != null) {
          // Process attendance data
          final attendanceList = (data['attendance'] as List).map((item) {
            // Transform 'users' field to 'UserInfo' for compatibility with the model
            if (item.containsKey('users') && !item.containsKey('UserInfo')) {
              item['UserInfo'] = item['users'];
            }
            return Attendance.fromJson(item as Map<String, dynamic>);
          }).toList();

          _attendanceHistory = attendanceList;
          _totalAttendance = data['total'] as int;

          // Create a map of attendance days for easy lookup
          _attendanceDays = {};
          for (var attendance in _attendanceHistory) {
            // Only the date part matters for calendar, not the time
            final dateOnly = DateTime(
              attendance.attendanceDate.year,
              attendance.attendanceDate.month,
              attendance.attendanceDate.day,
            );
            _attendanceDays[dateOnly] = true;
          }
        } else {
          _setError(true, 'No attendance data found');
        }
      } else {
        final message = responseData != null
            ? responseData['message'] ?? 'Unknown error'
            : 'Failed to fetch attendance data';
        _setError(true, message);
        throw Exception(message);
      }
    } catch (e) {
      _setError(true, e.toString());
      print('Error fetching attendance history: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Get today's attendance for all users (admin functionality)
  Future<List<Attendance>> fetchTodayAttendance() async {
    _setLoading(true);
    try {
      final response = await httpClient.get('/attendance/today');
      final responseData = response.data;

      if (responseData != null && responseData['status'] == 'success') {
        // Extract the attendance data list
        final attendanceData = responseData['data'];

        if (attendanceData != null) {
          if (attendanceData is List) {
            // If data is directly a list of attendance
            return attendanceData.map((item) {
              // Transform 'users' field to 'UserInfo'
              if (item.containsKey('users') && !item.containsKey('UserInfo')) {
                item['UserInfo'] = item['users'];
              }
              return Attendance.fromJson(item as Map<String, dynamic>);
            }).toList();
          } else {
            // If data contains a nested attendance list
            final attendanceList = attendanceData is Map &&
                    attendanceData.containsKey('attendance')
                ? attendanceData['attendance'] as List
                : [];

            return attendanceList.map((item) {
              // Transform 'users' field to 'UserInfo'
              if (item.containsKey('users') && !item.containsKey('UserInfo')) {
                item['UserInfo'] = item['users'];
              }
              return Attendance.fromJson(item as Map<String, dynamic>);
            }).toList();
          }
        }
      }

      // Return empty list if no data or unsuccessful response
      return [];
    } catch (e) {
      print('Error fetching today\'s attendance: $e');
      return [];
    } finally {
      _setLoading(false);
    }
  }

  // Mark attendance for a user using their card number
  Future<bool> markAttendance(String cardNumber) async {
    _setLoading(true);
    try {
      final response = await httpClient.post(
        '/attendance',
        data: {'card_number': cardNumber},
      );

      final responseData = response.data;
      return responseData != null && responseData['status'] == 'success';
    } catch (e) {
      print('Error marking attendance: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Calculate attendance statistics
  Map<String, dynamic> getAttendanceStats({int? daysToConsider}) {
    if (_attendanceHistory.isEmpty) {
      return {
        'attendanceRate': 0.0,
        'consecutiveDays': 0,
        'currentStreak': 0,
        'longestStreak': 0,
      };
    }

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Sort attendance by date (newest first)
    final sortedAttendance = List<Attendance>.from(_attendanceHistory)
      ..sort((a, b) => b.attendanceDate.compareTo(a.attendanceDate));

    // Calculate attendance rate
    double attendanceRate = 0.0;
    if (daysToConsider != null) {
      final considerStartDate =
          today.subtract(Duration(days: daysToConsider - 1));
      int daysPresent = 0;

      for (int i = 0; i < daysToConsider; i++) {
        final checkDate = considerStartDate.add(Duration(days: i));
        if (_attendanceDays.containsKey(checkDate)) {
          daysPresent++;
        }
      }

      attendanceRate = daysPresent / daysToConsider;
    }

    // Calculate current streak
    int currentStreak = 0;
    if (_attendanceDays.containsKey(today)) {
      currentStreak = 1;
      var checkDate = today.subtract(const Duration(days: 1));

      while (_attendanceDays.containsKey(checkDate)) {
        currentStreak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      }
    } else {
      var checkDate = today.subtract(const Duration(days: 1));
      if (_attendanceDays.containsKey(checkDate)) {
        currentStreak = 1;
        checkDate = checkDate.subtract(const Duration(days: 1));

        while (_attendanceDays.containsKey(checkDate)) {
          currentStreak++;
          checkDate = checkDate.subtract(const Duration(days: 1));
        }
      }
    }

    // Calculate longest streak
    int longestStreak = 0;
    int consecutiveDays = 0;

    // Get all dates and sort them
    List<DateTime> attendanceDates = _attendanceDays.keys.toList();
    attendanceDates.sort((a, b) => a.compareTo(b));

    if (attendanceDates.isNotEmpty) {
      consecutiveDays = 1;
      longestStreak = 1;

      for (int i = 1; i < attendanceDates.length; i++) {
        final difference =
            attendanceDates[i].difference(attendanceDates[i - 1]).inDays;

        if (difference == 1) {
          consecutiveDays++;
          longestStreak =
              consecutiveDays > longestStreak ? consecutiveDays : longestStreak;
        } else {
          consecutiveDays = 1;
        }
      }
    }

    return {
      'attendanceRate': attendanceRate,
      'consecutiveDays': consecutiveDays,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
    };
  }

  // Get month's attendance rate
  double getMonthAttendanceRate(DateTime month) {
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    int presentDays = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(month.year, month.month, day);
      if (_attendanceDays.containsKey(date)) {
        presentDays++;
      }
    }

    return presentDays / daysInMonth;
  }

  // Clear attendance data
  void clearAttendanceData() {
    _attendanceHistory = [];
    _attendanceDays = {};
    _totalAttendance = 0;
    notifyListeners();
  }
}
