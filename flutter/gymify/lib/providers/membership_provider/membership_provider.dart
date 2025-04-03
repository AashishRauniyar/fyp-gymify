import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/membership_models/membership_model.dart';
import 'package:gymify/network/http.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';

class MembershipProvider with ChangeNotifier {
  List<dynamic> _plans = [];
  Map<String, dynamic>? _membershipStatus;
  Membership? _membership;
  String _error = '';
  bool _isLoading = false;
  String pidx = '';
  String transactionId = '';
  String paymentUrl = '';

  String _status = '';

  bool _isActive = false;
  bool get isActive => _isActive;

  // Getters
  List<dynamic> get plans => _plans;
  Map<String, dynamic>? get membershipStatus => _membershipStatus;
  Membership? get membership => _membership;
  String get error => _error;
  bool get isLoading => _isLoading;
  String get status => _status;

  // Setters
  void setError(String error) {
    _error = error;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // General API handler
  Future<void> handleApiCall(Future<void> Function() apiCall) async {
    setLoading(true);
    clearError();
    try {
      await apiCall();
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  // Fetch all membership plans
  Future<void> fetchMembershipPlans() async {
    await handleApiCall(() async {
      final response = await httpClient.get('/plans');
      final apiResponse = ApiResponse<List<dynamic>>.fromJson(
        response.data,
        (data) => data as List<dynamic>,
      );

      if (apiResponse.status == 'success') {
        _plans = apiResponse.data;
        notifyListeners();
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Error fetching membership plans');
      }
    });
  }

  Future<void> applyForMembership(
      BuildContext context, int planId, String paymentMethod) async {
    await handleApiCall(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;

      if (userId == null) {
        throw Exception('User ID not found. Please log in again.');
      }
      // final intUserId = int.parse(userId.toString());

      final response = await httpClient.post('/memberships', data: {
        'user_id': userId,
        'plan_id': planId,
        'payment_method': paymentMethod,
      });

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        _membershipStatus = apiResponse.data;
        fetchMembershipStatus(context);
        notifyListeners();
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Error applying for membership');
      }
    });
  }

  Future<void> fetchMembershipStatus(BuildContext context) async {
    await handleApiCall(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;

      if (userId == null) {
        setError('User ID not found. Please log in again.');
        return;
      }

      try {
        final response = await httpClient.get('/memberships/status/$userId');
        final apiResponse = ApiResponse<Membership>.fromJson(
          response.data,
          (data) => Membership.fromJson(data as Map<String, dynamic>),
        );

        if (apiResponse.status == 'success') {
          _membership = apiResponse.data;
          _status = _membership?.status ?? ''; // Store membership status
          if(_membership?.status == 'Active') {
            _isActive = true; // Set isActive to true if membership is active
          } else {
            _isActive = false; // Set isActive to false if membership is not active
          }
          print(" status is ${_status}");
          // Store membership details
          print(_membership?.endDate);
        } else if (apiResponse.status == 'failure' &&
            apiResponse.message.contains("No membership found")) {
          _membership = null; // No membership exists, set to null
        } else {
          throw Exception(apiResponse.message.isNotEmpty
              ? apiResponse.message
              : 'Error fetching membership status');
        }

        notifyListeners();
      } catch (e) {
        setError('Failed to fetch membership status: $e');
      }
    });
  }

  // Apply for membership using Khalti
  Future<void> applyForMembershipUsingKhalti(BuildContext context, int planId,
      int amount, String paymentMethod) async {
    await handleApiCall(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;

      if (userId == null) {
        throw Exception('User ID not found. Please log in again.');
      }

      // Call your backend to initiate the Khalti payment
      final response = await httpClient.post('/initiate-payment', data: {
        'user_id': userId,
        'plan_id': planId,
        'amount': amount,
        'payment_method': paymentMethod,
      });

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        pidx = apiResponse.data['pidx'];
        transactionId = apiResponse.data['transaction_id'];
        paymentUrl = apiResponse.data['payment_url'];
        notifyListeners();
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Error applying for membership');
      }
    });
  }

  Future<void> verifyPayment(
      BuildContext context, String transactionId, String status) async {
    await handleApiCall(() async {
      final response = await httpClient.post('/verify-payment', data: {
        'transaction_id': transactionId,
        'status': status,
      });

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        // Update membership status in the provider
        _membershipStatus = apiResponse.data;
        notifyListeners();
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Error verifying payment');
      }
    });
  }
}
