import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'dart:developer';
import 'package:provider/provider.dart';

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  String pidx = '';
  String transactionId = '';
  String payableAmount = '';
  PaymentResult? paymentResult;
  bool isLoading = true;
  late Future<Khalti?> khaltiFuture;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var membershipProvider = context.read<MembershipProvider>();
      pidx = membershipProvider.pidx;
      payableAmount = membershipProvider.payableAmount;
      transactionId = membershipProvider.transactionId;
      setState(() {
        isLoading = false;
        khaltiFuture = _initializeKhalti();
      });
    });
  }

  Future<Khalti?> _initializeKhalti() async {
    if (pidx.isEmpty) {
      return null;
    }

    final payConfig = KhaltiPayConfig(
      publicKey: '11d8ca6a221240deb98b99ee2b4ea4ac',
      pidx: pidx,
      environment: Environment.test,
    );

    final khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        log(paymentResult.toString());
        setState(() {
          this.paymentResult = paymentResult;
        });
        print(paymentResult);
        if (paymentResult.payload?.status == 'Completed') {
          final provider =
              Provider.of<MembershipProvider>(context, listen: false);
          provider.verifyPayment(context, transactionId, "Completed");
          showCoolSnackBar(context, "Payment Successful", true);

          // Add a slight delay before redirecting to welcome screen
          Future.delayed(const Duration(seconds: 2), () {
            // Clear navigation stack and navigate to welcome screen
            context.go('/welcome');
          });
        } else {
          showCoolSnackBar(context, "Payment Failed", false);
        }

        khalti.close(context);
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        log(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
        khalti.close(context);
      },
      onReturn: () => log('Successfully redirected to return_url.'),
    );

    return khalti;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Payment',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : FutureBuilder<Khalti?>(
              future: khaltiFuture,
              initialData: null,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 80, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}',
                            textAlign: TextAlign.center),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.pushNamed('membershipPlans'),
                          child: const Text('Go Back to Membership Plans'),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasData) {
                  final khaltiInstance = snapshot.data;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // Payment Summary Card
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Payment Summary',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    // clipBehavior: Clip.antiAlias,
                                    child: Image.asset(
                                      'assets/logo/khalti_logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Text(
                                    'Amount to Pay',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rs. $payableAmount',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    'Membership fee',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  // Payment Button
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        khaltiInstance?.open(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                            0xFF5C2D91), // Khalti purple color
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Image.network(
                                            'https://khalti.s3.ap-south-1.amazonaws.com/KPG/dist/2020.12.17.11.13.41/icons/khalti.png',
                                            height: 24,
                                            width: 24,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return const Icon(Icons.payment,
                                                  color: Colors.white);
                                            },
                                          ),
                                          const SizedBox(width: 8),
                                          const Text(
                                            'Pay with Khalti',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Payment Status Card (shown only after payment attempt)
                          if (paymentResult != null)
                            Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Payment Details',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildDetailRow(
                                        'Status',
                                        paymentResult!.payload?.status ??
                                            'Unknown'),
                                    _buildDetailRow('Amount',
                                        'Rs. ${paymentResult!.payload?.totalAmount ?? '0'}'),
                                    _buildDetailRow(
                                        'Transaction ID',
                                        paymentResult!.payload?.transactionId ??
                                            'N/A'),
                                    _buildDetailRow('PIDX',
                                        paymentResult!.payload?.pidx ?? 'N/A'),
                                  ],
                                ),
                              ),
                            ),

                          const SizedBox(height: 24),

                          // Bottom navigation buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  context.pushNamed('membershipPlans');
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                child: const Text('Back to Plans'),
                              ),
                              OutlinedButton(
                                onPressed: () {
                                  context.go('/welcome');
                                },
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                ),
                                child: const Text('Go to Welcome'),
                              ),
                            ],
                          ),

                          // const SizedBox(height: 24),
                          // const Text(
                          //   'This is a demo payment using Khalti payment gateway',
                          //   style: TextStyle(fontSize: 12, color: Colors.grey),
                          //   textAlign: TextAlign.center,
                          // ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 60, color: Colors.orange),
                        const SizedBox(height: 16),
                        const Text(
                          'No payment information available',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => context.pushNamed('membershipPlans'),
                          child: const Text('Go Back to Membership Plans'),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: label == 'Status' && value == 'Completed'
                  ? Colors.green
                  : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
