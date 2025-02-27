// import 'package:flutter/material.dart';
// import 'package:gymify/providers/membership_provider/membership_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:provider/provider.dart';

// class MembershipScreen extends StatefulWidget {
//   const MembershipScreen({super.key});

//   @override
//   _MembershipScreenState createState() => _MembershipScreenState();
// }

// class _MembershipScreenState extends State<MembershipScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<MembershipProvider>(context, listen: false)
//           .fetchMembershipPlans();
//     });
//   }

//   void _showPaymentDialog(BuildContext context, int planId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Select Payment Method'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text('Pay with Khalti'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _applyForMembership(context, planId, 'Khalti');
//                 },
//               ),
//               ListTile(
//                 title: const Text('Pay with Cash'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _applyForMembership(context, planId, 'Cash');
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _applyForMembership(
//       BuildContext context, int planId, String paymentMethod) async {
//     try {
//       await Provider.of<MembershipProvider>(context, listen: false)
//           .applyForMembership(context, planId, paymentMethod);

//       if (context.mounted) {
//         showCoolSnackBar(context,
//             "Membership applied successfully! Waiting for approval.", true);
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showCoolSnackBar(context, "Error: $e", false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final membershipProvider = Provider.of<MembershipProvider>(context);

//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Membership Plans'),
//       body: membershipProvider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : membershipProvider.error.isNotEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(membershipProvider.error,
//                           style:
//                               const TextStyle(color: Colors.red, fontSize: 16)),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () =>
//                             membershipProvider.fetchMembershipPlans(),
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: membershipProvider.plans.length,
//                   itemBuilder: (context, index) {
//                     final plan = membershipProvider.plans[index];
//                     return Card(
//                       elevation: 3,
//                       margin: const EdgeInsets.symmetric(vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(16),
//                         title: Text(
//                           plan['plan_type'],
//                           style: const TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                         subtitle: Text('Price: NRS ${plan['price']}'),
//                         trailing: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: () {
//                             _showPaymentDialog(context, plan['plan_id']);
//                           },
//                           child: const Text('Apply',
//                               style: TextStyle(color: Colors.white)),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//     );
//   }
// }

//! working code

// import 'package:flutter/material.dart';
// import 'package:gymify/providers/membership_provider/membership_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:provider/provider.dart';

// class MembershipScreen extends StatefulWidget {
//   const MembershipScreen({super.key});

//   @override
//   _MembershipScreenState createState() => _MembershipScreenState();
// }

// class _MembershipScreenState extends State<MembershipScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final membershipProvider =
//           Provider.of<MembershipProvider>(context, listen: false);
//       membershipProvider.fetchMembershipPlans();
//       membershipProvider.fetchMembershipStatus(context);
//     });
//   }

//   void _showPaymentDialog(BuildContext context, int planId) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Select Payment Method'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text('Pay with Khalti'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _applyForMembership(context, planId, 'Khalti');
//                 },
//               ),
//               ListTile(
//                 title: const Text('Pay with Cash'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _applyForMembership(context, planId, 'Cash');
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _applyForMembership(
//       BuildContext context, int planId, String paymentMethod) async {
//     try {
//       await Provider.of<MembershipProvider>(context, listen: false)
//           .applyForMembership(context, planId, paymentMethod);

//       if (context.mounted) {
//         showCoolSnackBar(context,
//             "Membership applied successfully! Waiting for approval.", true);
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showCoolSnackBar(context, "Error: $e", false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final membershipProvider = Provider.of<MembershipProvider>(context);
//     final membershipStatus = membershipProvider.membershipStatus;

//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Membership Plans'),
//       body: membershipProvider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : membershipProvider.error.isNotEmpty
//               ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Text(
//                         membershipProvider.error,
//                         style: const TextStyle(color: Colors.red, fontSize: 16),
//                       ),
//                       const SizedBox(height: 10),
//                       ElevatedButton(
//                         onPressed: () {
//                           membershipProvider.fetchMembershipPlans();
//                           membershipProvider.fetchMembershipStatus(context);
//                         },
//                         child: const Text('Retry'),
//                       ),
//                     ],
//                   ),
//                 )
//               : Column(
//                   children: [
//                     // Show membership status if applied
//                     if (membershipStatus != null)
//                       Container(
//                         width: double.infinity,
//                         margin: const EdgeInsets.all(16),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.shade50,
//                           borderRadius: BorderRadius.circular(12),
//                           border: Border.all(color: Colors.blue.shade300),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Current Membership Status:',
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Status: ${membershipStatus['status'] ?? 'N/A'}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                             Text(
//                               'Plan Type: ${membershipStatus['plan_type'] ?? 'N/A'}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                             Text(
//                               'Price: NRS ${membershipStatus['price'] ?? 'N/A'}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                             Text(
//                               'Payment Status: ${membershipStatus['payment_status'] ?? 'N/A'}',
//                               style: const TextStyle(fontSize: 16),
//                             ),
//                           ],
//                         ),
//                       ),
//                     Expanded(
//                       child: ListView.builder(
//                         padding: const EdgeInsets.all(16),
//                         itemCount: membershipProvider.plans.length,
//                         itemBuilder: (context, index) {
//                           final plan = membershipProvider.plans[index];
//                           return Card(
//                             elevation: 3,
//                             margin: const EdgeInsets.symmetric(vertical: 8),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.all(16),
//                               title: Text(
//                                 plan['plan_type'],
//                                 style: const TextStyle(
//                                     fontSize: 18, fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text('Price: NRS ${plan['price']}'),
//                               trailing: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.blue,
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 onPressed: () {
//                                   _showPaymentDialog(context, plan['plan_id']);
//                                 },
//                                 child: const Text('Apply',
//                                     style: TextStyle(color: Colors.white)),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:gymify/providers/membership_provider/membership_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:provider/provider.dart';

// class MembershipScreen extends StatefulWidget {
//   const MembershipScreen({super.key});

//   @override
//   _MembershipScreenState createState() => _MembershipScreenState();
// }

// class _MembershipScreenState extends State<MembershipScreen> {
//   bool _isApplying = false;

//   @override
//   void initState() {
//     super.initState();
//     _initializeData();
//   }

//   Future<void> _initializeData() async {
//     if (!mounted) return;

//     final membershipProvider =
//         Provider.of<MembershipProvider>(context, listen: false);
//     await membershipProvider.fetchMembershipPlans();
//     await membershipProvider.fetchMembershipStatus(context);
//   }

//   void _showPaymentDialog(
//       BuildContext context, int planId, String planType, String price) {
//     if (_isApplying) return; // Prevent multiple dialogs

//     final membershipProvider =
//         Provider.of<MembershipProvider>(context, listen: false);
//     final currentStatus = membershipProvider.membershipStatus;

//     // Check if user already has an active membership
//     if (currentStatus != null &&
//         (currentStatus['status'] == 'active' ||
//             currentStatus['status'] == 'pending')) {
//       showCoolSnackBar(context,
//           "You already have an ${currentStatus['status']} membership", false);
//       return;
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: !_isApplying,
//       builder: (context) {
//         return AlertDialog(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Confirm Membership'),
//               const SizedBox(height: 8),
//               Text(
//                 'Plan: $planType',
//                 style: const TextStyle(
//                     fontSize: 14, fontWeight: FontWeight.normal),
//               ),
//               Text(
//                 'Price: NRS $price',
//                 style: const TextStyle(
//                     fontSize: 14, fontWeight: FontWeight.normal),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Select Payment Method:'),
//               const SizedBox(height: 16),
//               ListTile(
//                 enabled: !_isApplying,
//                 leading: const Icon(Icons.payment),
//                 title: const Text('Pay with Khalti'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _applyForMembership(context, planId, 'Khalti');
//                 },
//               ),
//               ListTile(
//                 enabled: !_isApplying,
//                 leading: const Icon(Icons.money),
//                 title: const Text('Pay with Cash'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _applyForMembership(context, planId, 'Cash');
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: _isApplying ? null : () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _applyForMembership(
//       BuildContext context, int planId, String paymentMethod) async {
//     if (_isApplying) return;

//     setState(() => _isApplying = true);

//     try {
//       final provider = Provider.of<MembershipProvider>(context, listen: false);
//       await provider.applyForMembership(context, planId, paymentMethod);

//       if (!mounted) return;

//       final status = provider.membershipStatus;
//       if (status != null && status['status'] == 'pending') {
//         showCoolSnackBar(context,
//             "Membership application submitted! Waiting for approval.", true);
//       } else {
//         showCoolSnackBar(context,
//             "Failed to apply for membership. Please try again.", false);
//       }
//     } catch (e) {
//       if (!mounted) return;
//       showCoolSnackBar(context, "Error: ${e.toString()}", false);
//     } finally {
//       if (mounted) {
//         setState(() => _isApplying = false);
//       }
//     }
//   }

//   Widget _buildMembershipStatus(Map<String, dynamic> status) {
//     final statusColor = status['status']?.toLowerCase() == 'active'
//         ? Colors.green
//         : status['status']?.toLowerCase() == 'pending'
//             ? Colors.orange
//             : Colors.red;

//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: statusColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: statusColor.withOpacity(0.5)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Current Membership:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   status['status'] ?? 'N/A',
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildStatusRow('Plan Type:', status['plan_type'] ?? 'N/A'),
//           _buildStatusRow('Price:', 'NRS ${status['price'] ?? 'N/A'}'),
//           _buildStatusRow('Payment Status:', status['payment_status'] ?? 'N/A'),
//           if (status['start_date'] != null)
//             _buildStatusRow(
//                 'Start Date:', status['start_date'].toString().split('T')[0]),
//           if (status['end_date'] != null)
//             _buildStatusRow(
//                 'End Date:', status['end_date'].toString().split('T')[0]),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 16),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Membership Plans'),
//       body: Consumer<MembershipProvider>(
//         builder: (context, membershipProvider, child) {
//           if (membershipProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (membershipProvider.error.isNotEmpty) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       color: Colors.red,
//                       size: 48,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       membershipProvider.error,
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       onPressed: _initializeData,
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return RefreshIndicator(
//             onRefresh: _initializeData,
//             child: ListView(
//               children: [
//                 if (membershipProvider.membershipStatus != null)
//                   _buildMembershipStatus(membershipProvider.membershipStatus!),
//                 Padding(
//                   padding: const EdgeInsets.all(16),
//                   child: Text(
//                     'Available Plans',
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                 ),
//                 ...membershipProvider.plans.map((plan) => Card(
//                       elevation: 3,
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(16),
//                         title: Text(
//                           plan['plan_type'],
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 8),
//                             Text(
//                               'Price: NRS ${plan['price']}',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: _isApplying
//                               ? null
//                               : () => _showPaymentDialog(
//                                     context,
//                                     plan['plan_id'],
//                                     plan['plan_type'],
//                                     plan['price'],
//                                   ),
//                           child: Text(
//                             _isApplying ? 'Processing...' : 'Apply',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     )),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

//! final
// import 'package:flutter/material.dart';
// import 'package:gymify/providers/membership_provider/membership_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:provider/provider.dart';

// class MembershipScreen extends StatefulWidget {
//   const MembershipScreen({super.key});

//   @override
//   _MembershipScreenState createState() => _MembershipScreenState();
// }

// class _MembershipScreenState extends State<MembershipScreen> {
//   bool _isApplying = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeData();
//     });
//   }

//   Future<void> _initializeData() async {
//     if (!mounted) return;
//     final membershipProvider =
//         Provider.of<MembershipProvider>(context, listen: false);
//     await membershipProvider.fetchMembershipPlans();
//     await membershipProvider.fetchMembershipStatus(context);
//   }

//   Widget _buildMembershipStatus(Map<String, dynamic> status) {
//     final statusColor = status['status']?.toLowerCase() == 'active'
//         ? Colors.green
//         : status['status']?.toLowerCase() == 'pending'
//             ? Colors.orange
//             : Colors.blue;

//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: statusColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: statusColor.withOpacity(0.5)),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Text(
//                 'Current Membership:',
//                 style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                 decoration: BoxDecoration(
//                   color: statusColor.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Text(
//                   status['status'] ?? 'N/A',
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildStatusRow('Plan Type:', status['plan_type'] ?? 'N/A'),
//           _buildStatusRow('Price:', 'NRS ${status['price'] ?? 'N/A'}'),
//           _buildStatusRow('Payment Status:', status['payment_status'] ?? 'N/A'),
//           if (status['start_date'] != null)
//             _buildStatusRow(
//                 'Start Date:', status['start_date'].toString().split('T')[0]),
//           if (status['end_date'] != null)
//             _buildStatusRow(
//                 'End Date:', status['end_date'].toString().split('T')[0]),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatusRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Text(
//             label,
//             style: const TextStyle(fontSize: 16),
//           ),
//           const SizedBox(width: 8),
//           Text(
//             value,
//             style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPaymentDialog(
//       BuildContext context, int planId, String planType, String price) {
//     if (_isApplying) return;

//     final membershipProvider =
//         Provider.of<MembershipProvider>(context, listen: false);
//     final currentStatus = membershipProvider.membershipStatus;

//     if (currentStatus != null &&
//         (currentStatus['status']?.toLowerCase() == 'active' ||
//             currentStatus['status']?.toLowerCase() == 'pending')) {
//       showCoolSnackBar(context,
//           "You already have an ${currentStatus['status']} membership", false);
//       return;
//     }

//     showDialog(
//       context: context,
//       barrierDismissible: !_isApplying,
//       builder: (context) {
//         return AlertDialog(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Confirm Membership'),
//               const SizedBox(height: 8),
//               Text(
//                 'Plan: $planType',
//                 style: const TextStyle(
//                     fontSize: 14, fontWeight: FontWeight.normal),
//               ),
//               Text(
//                 'Price: NRS $price',
//                 style: const TextStyle(
//                     fontSize: 14, fontWeight: FontWeight.normal),
//               ),
//             ],
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text('Select Payment Method:'),
//               const SizedBox(height: 16),
//               ListTile(
//                 enabled: !_isApplying,
//                 leading: const Icon(Icons.payment),
//                 title: const Text('Pay with Khalti'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _applyForMembership(context, planId, 'Khalti');
//                 },
//               ),
//               ListTile(
//                 enabled: !_isApplying,
//                 leading: const Icon(Icons.money),
//                 title: const Text('Pay with Cash'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _applyForMembership(context, planId, 'Cash');
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: _isApplying ? null : () => Navigator.pop(context),
//               child: const Text('Cancel'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _applyForMembership(
//       BuildContext context, int planId, String paymentMethod) async {
//     if (_isApplying) return;

//     setState(() => _isApplying = true);

//     try {
//       final provider = Provider.of<MembershipProvider>(context, listen: false);
//       await provider.applyForMembership(context, planId, paymentMethod);

//       if (!mounted) return;

//       final status = provider.membershipStatus;
//       if (status != null &&
//           (status['status']?.toLowerCase() == 'pending' ||
//               status['status']?.toLowerCase() == 'active')) {
//         if (context.mounted) {
//           showCoolSnackBar(
//               context, "Membership application submitted successfully!", true);
//         }
//       }
//     } catch (e) {
//       if (context.mounted) {
//         showCoolSnackBar(context, e.toString(), false);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isApplying = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: const CustomAppBar(title: 'Membership Plans'),
//       body: Consumer<MembershipProvider>(
//         builder: (context, membershipProvider, child) {
//           if (membershipProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (membershipProvider.error.isNotEmpty &&
//               membershipProvider.plans.isEmpty) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Icon(
//                       Icons.error_outline,
//                       color: Colors.red,
//                       size: 48,
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       membershipProvider.error,
//                       style: const TextStyle(color: Colors.red, fontSize: 16),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       onPressed: _initializeData,
//                       icon: const Icon(Icons.refresh),
//                       label: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }

//           return RefreshIndicator(
//             onRefresh: _initializeData,
//             child: ListView(
//               children: [
//                 if (membershipProvider.membershipStatus != null)
//                   _buildMembershipStatus(membershipProvider.membershipStatus!),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Text(
//                     'Available Plans',
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                 ),
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   padding: const EdgeInsets.all(16),
//                   itemCount: membershipProvider.plans.length,
//                   itemBuilder: (context, index) {
//                     final plan = membershipProvider.plans[index];
//                     return Card(
//                       elevation: 3,
//                       margin: const EdgeInsets.only(bottom: 16),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(16),
//                         title: Text(
//                           plan['plan_type'],
//                           style: const TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const SizedBox(height: 8),
//                             Text(
//                               'Price: NRS ${plan['price']}',
//                               style: const TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                         trailing: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8),
//                             ),
//                           ),
//                           onPressed: _isApplying
//                               ? null
//                               : () => _showPaymentDialog(
//                                     context,
//                                     plan['plan_id'],
//                                     plan['plan_type'],
//                                     plan['price'],
//                                   ),
//                           child: Text(
//                             _isApplying ? 'Processing...' : 'Apply',
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  bool _isLoading = false;
  bool _isApplying = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });

    // _initializeData();
  }

  Future<void> _initializeData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final membershipProvider =
          Provider.of<MembershipProvider>(context, listen: false);
      await Future.wait([
        membershipProvider.fetchMembershipPlans(),
        membershipProvider.fetchMembershipStatus(context),
      ]);
    } catch (e) {
      if (mounted) {
        showCoolSnackBar(
            context, 'Failed to load membership data: ${e.toString()}', false);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildMembershipStatus(Map<String, dynamic> status) {
    final statusColor = status['status']?.toLowerCase() == 'active'
        ? Colors.green
        : status['status']?.toLowerCase() == 'pending'
            ? Colors.orange
            : Colors.blue;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Membership:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status['status'] ?? 'N/A',
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatusRow('Plan Type:', status['plan_type'] ?? 'N/A'),
          _buildStatusRow('Price:', 'NRS ${status['price'] ?? 'N/A'}'),
          _buildStatusRow('Payment Status:', status['payment_status'] ?? 'N/A'),
          if (status['start_date'] != null)
            _buildStatusRow(
                'Start Date:', status['start_date'].toString().split('T')[0]),
          if (status['end_date'] != null)
            _buildStatusRow(
                'End Date:', status['end_date'].toString().split('T')[0]),
          // if membership inactive, show please collect card from gym counter message after payment
          if (status['status']?.toLowerCase() == 'pending')
            const Text(
              'Please collect your membership card from the gym counter after payment.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

          // if membership active, show card number from profile fetch
          if (status['status']?.toLowerCase() == 'active')
            _buildStatusRow('Card Number:',
                context.read<ProfileProvider>().user?.cardNumber ?? 'N/A'),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Future<void> _showPaymentDialog(
    BuildContext context,
    int planId,
    String planType,
    String price,
  ) async {
    if (_isApplying) return;

    final membershipProvider =
        Provider.of<MembershipProvider>(context, listen: false);
    final currentStatus = membershipProvider.membershipStatus;

    if (currentStatus != null &&
        (currentStatus['status']?.toLowerCase() == 'active' ||
            currentStatus['status']?.toLowerCase() == 'pending')) {
      showCoolSnackBar(
        context,
        "You already have an ${currentStatus['status']} membership",
        false,
      );
      return;
    }

    return showDialog(
      context: context,
      barrierDismissible: !_isApplying,
      builder: (BuildContext dialogContext) => AlertDialog(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Confirm Membership'),
            const SizedBox(height: 8),
            Text(
              'Plan: $planType',
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            Text(
              'NRS $price',
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Payment Method:'),
            const SizedBox(height: 16),
            ListTile(
              enabled: !_isApplying,
              leading: const Icon(Icons.payment),
              title: const Text('Pay with Khalti'),
              onTap: () async {
                Navigator.pop(dialogContext);
                await _applyForMembership(context, planId, 'Khalti');
              },
            ),
            ListTile(
              enabled: !_isApplying,
              leading: const Icon(Icons.money),
              title: const Text('Pay with Cash'),
              onTap: () async {
                Navigator.pop(dialogContext);
                await _applyForMembership(context, planId, 'Cash');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isApplying ? null : () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Future<void> _applyForMembership(
    BuildContext context,
    int planId,
    String paymentMethod,
  ) async {
    if (_isApplying) return;

    setState(() => _isApplying = true);

    try {
      final provider = Provider.of<MembershipProvider>(context, listen: false);
      await provider.applyForMembership(context, planId, paymentMethod);

      if (!mounted) return;

      final status = provider.membershipStatus;
      if (status != null &&
          (status['status']?.toLowerCase() == 'pending' ||
              status['status']?.toLowerCase() == 'active')) {
        // fetch status again

        showCoolSnackBar(
          context,
          "Membership application submitted successfully!",
          true,
        );
        if (context.mounted) {
          await provider.fetchMembershipStatus(context);
        }
      }
    } catch (e) {
      if (mounted) {
        showCoolSnackBar(context, e.toString(), false);
      }
    } finally {
      if (mounted) {
        setState(() => _isApplying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Membership Plans'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<MembershipProvider>(
              builder: (context, membershipProvider, child) {
                if (membershipProvider.error.isNotEmpty &&
                    membershipProvider.plans.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              color: Colors.red, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            membershipProvider.error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _initializeData,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _initializeData,
                  child: ListView(
                    children: [
                      if (membershipProvider.membershipStatus != null)
                        _buildMembershipStatus(
                            membershipProvider.membershipStatus!),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Text(
                          'Available Plans',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        itemCount: membershipProvider.plans.length,
                        itemBuilder: (context, index) {
                          final plan = membershipProvider.plans[index];
                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                plan['plan_type'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  Text(
                                    'NRS ${plan['price']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              trailing: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _isApplying
                                    ? null
                                    : () => _showPaymentDialog(
                                          context,
                                          plan['plan_id'],
                                          plan['plan_type'],
                                          plan['price'],
                                        ),
                                child: _isApplying
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ),
                                      )
                                    : const Text(
                                        'Apply',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

void showCoolSnackBar(
  BuildContext context,
  String message,
  bool isSuccess, {
  String? actionLabel,
  VoidCallback? onActionPressed,
}) {
  final scaffoldMessenger = ScaffoldMessenger.of(context);

  // Dismiss any existing SnackBars before showing a new one
  scaffoldMessenger.hideCurrentSnackBar();

  final snackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          isSuccess ? Icons.check_circle : Icons.error,
          color: Colors.white,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            message,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    ),
    backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    behavior: SnackBarBehavior.floating,
    elevation: 6.0,
    margin: const EdgeInsets.all(16.0),
    duration: const Duration(seconds: 3),
    action: actionLabel != null && onActionPressed != null
        ? SnackBarAction(
            label: actionLabel,
            textColor: Colors.white,
            onPressed: onActionPressed,
          )
        : null,
  );

  scaffoldMessenger.showSnackBar(snackBar);
}
