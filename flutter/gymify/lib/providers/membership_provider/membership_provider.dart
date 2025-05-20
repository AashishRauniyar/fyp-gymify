import 'package:flutter/material.dart';
import 'package:gymify/models/api_response.dart';
import 'package:gymify/models/membership_models/membership_model.dart';
import 'package:gymify/network/http.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gymify/models/esewa_payment_response.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/rendering.dart';
import 'dart:convert'; // For Encoding

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

  String payableAmount = '';

  bool _isActive = false;
  bool get isActive => _isActive;

  EsewaPaymentResponse? _esewaPaymentResponse;
  EsewaPaymentResponse? get esewaPaymentResponse => _esewaPaymentResponse;

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
          if (_membership?.status == 'Active') {
            _isActive = true; // Set isActive to true if membership is active
          } else {
            _isActive =
                false; // Set isActive to false if membership is not active
          }
          print(" status is $_status");
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
        payableAmount = apiResponse.data['amount'].toString();
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

  // method to delete membership by a user (before being approved)
  Future<void> deleteMembership(BuildContext context) async {
    await handleApiCall(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;

      if (userId == null) {
        throw Exception('User ID not found. Please log in again.');
      }

      final response = await httpClient.delete('/memberships/user/$userId');

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        _membershipStatus = null;
        _membership = null;
        notifyListeners();
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Error deleting membership');
      }
    });
  }

  // Initiate eSewa Payment
  Future<void> applyForMembershipUsingEsewa(
      BuildContext context, int planId, int amount) async {
    await handleApiCall(() async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final userId = authProvider.userId;

      if (userId == null) {
        throw Exception('User ID not found. Please log in again.');
      }

      final response = await httpClient.post('/initiate-payment-esewa', data: {
        'plan_id': planId,
        'amount': amount,
      });

      final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
        response.data,
        (data) => data as Map<String, dynamic>,
      );

      if (apiResponse.status == 'success') {
        final data = apiResponse.data;

        // Validate URLs
        if (data['success_url'] == null || data['failure_url'] == null) {
          throw 'Payment configuration error: Success and failure URLs are required';
        }

        _esewaPaymentResponse = EsewaPaymentResponse.fromJson(data);
        notifyListeners();
        await launchEsewaWebCheckout(_esewaPaymentResponse!, context);
      } else {
        throw Exception(apiResponse.message.isNotEmpty
            ? apiResponse.message
            : 'Error applying for membership');
      }
    });
  }

  // Launch eSewa Web Checkout
  Future<void> launchEsewaWebCheckout(
      EsewaPaymentResponse payment, BuildContext context) async {
    final formHtml = '''
      <html>
        <body onload="document.forms[0].submit()">
          <form id="esewaPayForm" action="https://rc-epay.esewa.com.np/api/epay/main/v2/form" method="POST">
            <input type="hidden" name="amount" value="${payment.amount}" />
            <input type="hidden" name="tax_amount" value="${payment.taxAmount}" />
            <input type="hidden" name="total_amount" value="${payment.totalAmount}" />
            <input type="hidden" name="transaction_uuid" value="${payment.transactionUuid}" />
            <input type="hidden" name="product_code" value="${payment.productCode}" />
            <input type="hidden" name="product_service_charge" value="${payment.productServiceCharge}" />
            <input type="hidden" name="product_delivery_charge" value="${payment.productDeliveryCharge}" />
            <input type="hidden" name="success_url" value="${payment.successUrl}" />
            <input type="hidden" name="failure_url" value="${payment.failureUrl}" />
            <input type="hidden" name="signed_field_names" value="${payment.signedFieldNames}" />
            <input type="hidden" name="signature" value="${payment.signature}" />
          </form>
        </body>
      </html>
    ''';

    final data = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _EsewaWebViewScreen(
          formHtml: formHtml,
          successUrl: payment.successUrl,
        ),
      ),
    );

    if (data != null && data is String) {
      print('Intercepted eSewa success redirect with data: $data');
      await verifyEsewaPayment(context, data);
    }
  }

  // Verify eSewa Payment
  Future<void> verifyEsewaPayment(
      BuildContext context, String encodedData) async {
    final response = await httpClient.post('/verify-payment-esewa', data: {
      'data': encodedData,
    });

    final apiResponse = ApiResponse<Map<String, dynamic>>.fromJson(
      response.data,
      (data) => data as Map<String, dynamic>,
    );

    if (apiResponse.status == 'success') {
      // Update membership status in the provider
      _membershipStatus = apiResponse.data;

      // Create a new Membership object from the response
      _membership = Membership.fromJson({
        'status': apiResponse.data['status'],
        'planType': apiResponse.data['plan_type'],
        'price': apiResponse.data['price']?.toString() ?? '0',
        'paymentStatus': 'Paid',
        'startDate': apiResponse.data['start_date'],
        'endDate': apiResponse.data['end_date'],
      });

      // Update active status
      _isActive = apiResponse.data['status']?.toLowerCase() == 'active';

      // Notify all listeners about the state change
      notifyListeners();

      print('eSewa payment verification complete!');
      print('Updated membership status: ${apiResponse.data['status']}');
      print('Start date: ${apiResponse.data['start_date']}');
      print('End date: ${apiResponse.data['end_date']}');
    } else {
      throw Exception(apiResponse.message.isNotEmpty
          ? apiResponse.message
          : 'Error verifying eSewa payment');
    }
  }
}

class _EsewaWebViewScreen extends StatefulWidget {
  final String formHtml;
  final String successUrl;
  const _EsewaWebViewScreen(
      {super.key, required this.formHtml, required this.successUrl});

  @override
  State<_EsewaWebViewScreen> createState() => _EsewaWebViewScreenState();
}

class _EsewaWebViewScreenState extends State<_EsewaWebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.contains('/payment/success')) {
              final uri = Uri.parse(request.url);
              final data = uri.queryParameters['data'];
              print('Intercepted navigation to success_url: ${request.url}');
              print('Extracted data parameter: $data');
              Navigator.of(context).pop(data);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(widget.formHtml);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('eSewa Payment')),
      body: WebViewWidget(controller: _controller),
    );
  }
}
