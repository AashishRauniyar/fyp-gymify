import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/screens/main_screens/membership_screen/membership_screen.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'dart:developer';
import 'package:provider/provider.dart';

class KhaltiSDKDemo extends StatefulWidget {
  const KhaltiSDKDemo({super.key});

  @override
  State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
}

class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
  String pidx = ''; // We'll store the pidx value here
  String transactionId = '';
  String payableAmount = '';
  PaymentResult? paymentResult;
  late Future<Khalti?>
      khaltiFuture; // Future to initialize Khalti SDK asynchronously

  @override
  void initState() {
    super.initState();
    // Access pidx from the MembershipProvider state and initialize Khalti SDK
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var membershipProvider = context.read<MembershipProvider>();
      pidx = membershipProvider.pidx;
      payableAmount = membershipProvider.payableAmount;
      transactionId = membershipProvider.transactionId;
      setState(() {
        khaltiFuture =
            _initializeKhalti(); // Initialize Khalti SDK and assign it to khaltiFuture
      });
    });
  }

  // Initialize Khalti SDK
  Future<Khalti?> _initializeKhalti() async {
    if (pidx.isEmpty) {
      return null;
    }

    final payConfig = KhaltiPayConfig(
      publicKey:
          '11d8ca6a221240deb98b99ee2b4ea4ac', // Replace with your actual live public key
      pidx: pidx,
      environment: Environment.test, // Can be Environment.prod for live
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

    return khalti; // Return the khalti instance to be used in the FutureBuilder
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<Khalti?>(
          future: khaltiFuture, // The FutureBuilder now uses khaltiFuture
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator.adaptive();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final khaltiInstance = snapshot.data;

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/profile/default_avatar.jpg', // Your image asset

                    height: 200,
                    width: 200,
                  ),
                  const SizedBox(height: 120),
                  Text(
                    // replace with actual price
                    payableAmount,
                    style: const TextStyle(fontSize: 25),
                  ),
                  const Text('1 day fee'),
                  OutlinedButton(
                    onPressed: () {
                      // Open Khalti payment page
                      khaltiInstance?.open(context);
                    },
                    child: const Text('Pay with Khalti'),
                  ),
                  const SizedBox(height: 120),
                  paymentResult == null
                      ? Text(
                          'pidx: $pidx',
                          style: const TextStyle(fontSize: 15),
                        )
                      : Column(
                          children: [
                            Text('pidx: ${paymentResult!.payload?.pidx}'),
                            Text('Status: ${paymentResult!.payload?.status}'),
                            Text(
                                'Amount Paid: ${paymentResult!.payload?.totalAmount}'),
                            Text(
                                'Transaction ID: ${paymentResult!.payload?.transactionId}'),
                          ],
                        ),
                  const SizedBox(height: 120),
                  OutlinedButton(
                      onPressed: () {
                        context.pushNamed('membershipPlans');
                      },
                      child: const Text('Go to Membership Sceen')),
                  const Text(
                    'Demo Payment Using Khalti.',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            } else {
              return const Text('No Khalti SDK data available.');
            }
          },
        ),
      ),
    );
  }
}
