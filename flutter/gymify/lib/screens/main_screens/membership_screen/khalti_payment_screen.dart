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

// import 'package:flutter/material.dart';
// import 'package:khalti'

// import 'package:'

// class KhaltiSDKDemo extends StatefulWidget {
//   const KhaltiSDKDemo({super.key});

//   @override
//   State<KhaltiSDKDemo> createState() => _KhaltiSDKDemoState();
// }

// class _KhaltiSDKDemoState extends State<KhaltiSDKDemo> {
//   late final Future<Khalti> khalti;

//   @override
//   void initState() {
//     super.initState();
//     final payConfig = KhaltiPayConfig(
//       publicKey: '__live_public_key__', // Merchant's public key
//       pidx: pidx, // This should be generated via a server side POST request.
//       environment: Environment.prod,
//     );

//     khalti = Khalti.init(
//       enableDebugging: true,
//       payConfig: payConfig,
//       onPaymentResult: (paymentResult, khalti) {
//         log(paymentResult.toString());
//       },
//       onMessage: (
//         khalti, {
//         description,
//         statusCode,
//         event,
//         needsPaymentConfirmation,
//       }) async {
//         log(
//           'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
//         );
//       },
//       onReturn: () => log('Successfully redirected to return_url.'),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Rest of the code
//   }
// }