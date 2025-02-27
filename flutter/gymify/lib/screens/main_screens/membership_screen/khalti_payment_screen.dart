// import 'package:flutter/material.dart';

// class KhaltiPaymentScreen extends StatefulWidget {
//   const KhaltiPaymentScreen({super.key});

//   @override
//   State<KhaltiPaymentScreen> createState() => _KhaltiPaymentScreenState();
// }

// class _KhaltiPaymentScreenState extends State<KhaltiPaymentScreen> {

//   @override
//   void initState() {
//     super.initState();
    
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }



import 'package:flutter/material.dart';
import 'package:gymify/network/http.dart';

class KhaltiPaymentScreen extends StatefulWidget {
  final String publicKey;
  final String pidx;
  final String transactionId;

  const KhaltiPaymentScreen({
    Key? key,
    required this.publicKey,
    required this.pidx,
    required this.transactionId,
  }) : super(key: key);

  @override
  State<KhaltiPaymentScreen> createState() => _KhaltiPaymentScreenState();
}

class _KhaltiPaymentScreenState extends State<KhaltiPaymentScreen> {
  late final Future<Khalti> _khaltiFuture;

  @override
  void initState() {
    super.initState();

    final payConfig = KhaltiPayConfig(
      publicKey: widget.publicKey,
      pidx: widget.pidx,
      environment: Environment.prod, // Change to Environment.test for sandbox
    );

    _khaltiFuture = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) async {
        print("Payment Result: ${paymentResult.payload}");
        // After payment, call your backend to verify the payment status.
        try {
          final response = await httpClient.post('/verify-payment', data: {
            'transaction_id': widget.transactionId,
            'status': paymentResult.payload?.status ?? '',
          });
          // Handle response as needed (e.g. show confirmation, update UI)
          Navigator.pop(context);
        } catch (e) {
          print("Error verifying payment: $e");
          // Optionally show an error snackbar here.
        }
      },
      onMessage: (khalti, {description, statusCode, event, needsPaymentConfirmation}) async {
        print("Khalti Message: $description");
        if (needsPaymentConfirmation == true) {
          await khalti.verify();
        }
      },
      onReturn: () {
        print("User returned to app from Khalti Payment");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Khalti>(
      future: _khaltiFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            snapshot.data!.open(context);
          });
          return Scaffold(
            appBar: AppBar(title: const Text("Khalti Payment")),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          appBar: AppBar(title: const Text("Initializing Payment")),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
