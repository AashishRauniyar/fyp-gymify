// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/models/membership_models/membership_model.dart';
// import 'package:gymify/providers/membership_provider/membership_provider.dart';
// import 'package:gymify/providers/profile_provider/profile_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class MembershipScreen extends StatefulWidget {
//   const MembershipScreen({super.key});

//   @override
//   State<MembershipScreen> createState() => _MembershipScreenState();
// }

// class _MembershipScreenState extends State<MembershipScreen> {
//   bool _isLoading = false;
//   bool _isApplying = false;

//   String formatDate(DateTime date) {
//     final DateFormat formatter =
//         DateFormat('yyyy-MM-dd'); // Formats as '2025-03-18'
//     return formatter.format(date);
//   }

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _initializeData();
//     });

//     // _initializeData();
//   }

//   Future<void> _initializeData() async {
//     if (!mounted) return;
//     setState(() => _isLoading = true);

//     try {
//       final membershipProvider =
//           Provider.of<MembershipProvider>(context, listen: false);
//       await Future.wait([
//         membershipProvider.fetchMembershipPlans(),
//         membershipProvider.fetchMembershipStatus(context),
//       ]);
//     } catch (e) {
//       if (mounted) {
//         showCoolSnackBar(
//             context, 'Failed to load membership data: ${e.toString()}', false);
//       }
//     } finally {
//       if (mounted) {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   Widget _buildMembershipStatus(Membership membership) {
//     final statusColor = membership.status.toLowerCase() == 'active'
//         ? Colors.green
//         : membership.status.toLowerCase() == 'pending'
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
//                   membership.status,
//                   style: TextStyle(
//                     color: statusColor,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildStatusRow('Plan Type:', membership.planType),
//           _buildStatusRow('Price:', 'NRS ${membership.price}'),
//           _buildStatusRow('Payment Status:', membership.paymentStatus),
//           if (membership.status == 'Active')
//             _buildStatusRow('Start Date:', formatDate(membership.startDate!)),
//           if (membership.status == 'Active')
//             _buildStatusRow('End Date:', formatDate(membership.endDate!)),
//           // if membership inactive, show please collect card from gym counter message after payment
//           if (membership.status.toLowerCase() == 'pending')
//             const Text(
//               'Please collect your membership card from the gym counter after payment.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),

//           // if membership active, show card number from profile fetch
//           if (membership.status.toLowerCase() == 'active')
//             _buildStatusRow('Card Number:',
//                 context.read<ProfileProvider>().user?.cardNumber ?? 'N/A'),
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

//   Future<void> _showPaymentDialog(
//     BuildContext context,
//     int planId,
//     String planType,
//     String price,
//   ) async {
//     if (_isApplying) return;

//     final membershipProvider =
//         Provider.of<MembershipProvider>(context, listen: false);
//     final currentStatus = membershipProvider.membershipStatus;

//     if (currentStatus != null &&
//         (currentStatus['status']?.toLowerCase() == 'active' ||
//             currentStatus['status']?.toLowerCase() == 'pending')) {
//       showCoolSnackBar(
//         context,
//         "You already have an ${currentStatus['status']} membership",
//         false,
//       );
//       return;
//     }

//     return showDialog(
//       context: context,
//       barrierDismissible: !_isApplying,
//       builder: (BuildContext dialogContext) => AlertDialog(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Confirm Membership'),
//             const SizedBox(height: 8),
//             Text(
//               'Plan: $planType',
//               style:
//                   const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//             ),
//             Text(
//               'NRS $price',
//               style:
//                   const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text('Select Payment Method:'),
//             const SizedBox(height: 16),
//             ListTile(
//               enabled: !_isApplying,
//               leading: const Icon(Icons.payment),
//               title: const Text('Pay with Khalti'),
//               onTap: () async {
//                 Navigator.pop(dialogContext);
//                 // await _applyForMembership(context, planId, 'Khalti');
//                 final provider =
//                     Provider.of<MembershipProvider>(context, listen: false);

//                 await provider.applyForMembershipUsingKhalti(
//                     context, planId, int.parse(price), 'Khalti');

//                 // if (mounted) {
//                 //   return;
//                 // }
//                 if (context.mounted) {
//                   context.pushNamed('khalti');
//                 }

//                 // open khalti sdk
//               },
//             ),
//             ListTile(
//               enabled: !_isApplying,
//               leading: const Icon(Icons.money),
//               title: const Text('Pay with Cash'),
//               onTap: () async {
//                 Navigator.pop(dialogContext);
//                 await _applyForMembership(context, planId, 'Cash');
//               },
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: _isApplying ? null : () => Navigator.pop(dialogContext),
//             child: const Text('Cancel'),
//           ),
//         ],
//       ),
//     );
//   }

//   Future<void> _applyForMembership(
//     BuildContext context,
//     int planId,
//     String paymentMethod,
//   ) async {
//     if (_isApplying) return;

//     setState(() => _isApplying = true);

//     try {
//       final provider = Provider.of<MembershipProvider>(context, listen: false);

//       //

//       await provider.applyForMembership(context, planId, paymentMethod);

//       if (!mounted) return;

//       final status = provider.membershipStatus;
//       if (status != null &&
//           (status['status']?.toLowerCase() == 'pending' ||
//               status['status']?.toLowerCase() == 'active')) {
//         // fetch status again

//         showCoolSnackBar(
//           context,
//           "Membership application submitted successfully!",
//           true,
//         );
//         if (context.mounted) {
//           await provider.fetchMembershipStatus(context);
//         }
//       }
//     } catch (e) {
//       if (mounted) {
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
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Consumer<MembershipProvider>(
//               builder: (context, membershipProvider, child) {
//                 if (membershipProvider.error.isNotEmpty &&
//                     membershipProvider.plans.isEmpty) {
//                   return Center(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.error_outline,
//                               color: Colors.red, size: 48),
//                           const SizedBox(height: 16),
//                           Text(
//                             membershipProvider.error,
//                             style: const TextStyle(
//                                 color: Colors.red, fontSize: 16),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 16),
//                           ElevatedButton.icon(
//                             onPressed: _initializeData,
//                             icon: const Icon(Icons.refresh),
//                             label: const Text('Retry'),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }

//                 return RefreshIndicator(
//                   onRefresh: _initializeData,
//                   child: ListView(
//                     children: [
//                       if (membershipProvider.membership != null)
//                         _buildMembershipStatus(membershipProvider.membership!),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 8),
//                         child: Text(
//                           'Available Plans',
//                           style:
//                               Theme.of(context).textTheme.titleLarge?.copyWith(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                         ),
//                       ),
//                       ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         padding: const EdgeInsets.all(16),
//                         itemCount: membershipProvider.plans.length,
//                         itemBuilder: (context, index) {
//                           final plan = membershipProvider.plans[index];
//                           return Card(
//                             elevation: 3,
//                             margin: const EdgeInsets.only(bottom: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.all(16),
//                               title: Text(
//                                 plan['plan_type'],
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               subtitle: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const SizedBox(height: 8),
//                                   Text(
//                                     'NRS ${plan['price']}',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               trailing: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 onPressed: _isApplying
//                                     ? null
//                                     : () => _showPaymentDialog(
//                                           context,
//                                           plan['plan_id'],
//                                           plan['plan_type'],
//                                           plan['price'],
//                                         ),
//                                 child: _isApplying
//                                     ? const SizedBox(
//                                         height: 20,
//                                         width: 20,
//                                         child: CircularProgressIndicator(
//                                           strokeWidth: 2,
//                                           valueColor:
//                                               AlwaysStoppedAnimation<Color>(
//                                                   Colors.white),
//                                         ),
//                                       )
//                                     : const Text(
//                                         'Apply',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

// void showCoolSnackBar(
//   BuildContext context,
//   String message,
//   bool isSuccess, {
//   String? actionLabel,
//   VoidCallback? onActionPressed,
// }) {
//   final scaffoldMessenger = ScaffoldMessenger.of(context);

//   // Dismiss any existing SnackBars before showing a new one
//   scaffoldMessenger.hideCurrentSnackBar();

//   final snackBar = SnackBar(
//     content: Row(
//       children: [
//         Icon(
//           isSuccess ? Icons.check_circle : Icons.error,
//           color: Colors.white,
//         ),
//         const SizedBox(width: 10),
//         Expanded(
//           child: Text(
//             message,
//             style: const TextStyle(color: Colors.white, fontSize: 16),
//           ),
//         ),
//       ],
//     ),
//     backgroundColor: isSuccess ? Colors.green.shade600 : Colors.red.shade600,
//     shape: RoundedRectangleBorder(
//       borderRadius: BorderRadius.circular(10),
//     ),
//     behavior: SnackBarBehavior.floating,
//     elevation: 6.0,
//     margin: const EdgeInsets.all(16.0),
//     duration: const Duration(seconds: 3),
//     action: actionLabel != null && onActionPressed != null
//         ? SnackBarAction(
//             label: actionLabel,
//             textColor: Colors.white,
//             onPressed: onActionPressed,
//           )
//         : null,
//   );

//   scaffoldMessenger.showSnackBar(snackBar);
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/membership_models/membership_model.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isApplying = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM dd, yyyy');
    return formatter.format(date);
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

      if (mounted) {
        _animationController.forward();
      }
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

  Widget _buildMembershipStatus(Membership membership) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color statusColor;
    IconData statusIcon;
    String statusMessage;

    switch (membership.status.toLowerCase()) {
      case 'active':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        statusMessage =
            'Your membership is active and you have full access to all gym facilities.';
        break;
      case 'pending':
        statusColor = Colors.orange;
        statusIcon = Icons.pending_actions;
        statusMessage =
            'Your membership is pending. Please collect your membership card from the gym counter after payment confirmation.';
        break;
      default:
        statusColor = Colors.blue;
        statusIcon = Icons.info;
        statusMessage =
            'Please apply for a membership to access gym facilities.';
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              statusColor.withOpacity(0.1),
              isDarkMode ? Colors.black12 : Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: statusColor.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: statusColor.withOpacity(0.3), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.15),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    statusIcon,
                    color: statusColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Current Membership',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          membership.status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Membership details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status message
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: statusColor,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            statusMessage,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Membership details
                  Text(
                    'Membership Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildDetailRow(
                      Icons.card_membership, 'Plan Type', membership.planType),
                  _buildDetailRow(
                      Icons.attach_money, 'Price', 'NRS ${membership.price}'),
                  _buildDetailRow(Icons.payment, 'Payment Status',
                      membership.paymentStatus),

                  if (membership.status.toLowerCase() == 'active') ...[
                    _buildDetailRow(Icons.date_range, 'Start Date',
                        formatDate(membership.startDate!)),
                    _buildDetailRow(Icons.event_available, 'End Date',
                        formatDate(membership.endDate!)),
                    _buildDetailRow(
                        Icons.credit_card,
                        'Card Number',
                        context.read<ProfileProvider>().user?.cardNumber ??
                            'N/A'),

                    // Progress indicator
                    const SizedBox(height: 20),
                    _buildMembershipProgress(
                        membership.startDate!, membership.endDate!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembershipProgress(DateTime startDate, DateTime endDate) {
    final now = DateTime.now();
    final totalDays = endDate.difference(startDate).inDays;
    final daysElapsed = now.difference(startDate).inDays;
    final progress = daysElapsed / totalDays;
    final daysLeft = endDate.difference(now).inDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Membership Progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 10,
            backgroundColor: Colors.grey.shade300,
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(progress * 100).round()}% Complete',
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            Text(
              '$daysLeft days left',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: daysLeft < 7
                    ? Colors.red
                    : Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Future<void> _showPaymentDialog(
  //   BuildContext context,
  //   int planId,
  //   String planType,
  //   String price,
  // ) async {
  //   if (_isApplying) return;

  //   final membershipProvider =
  //       Provider.of<MembershipProvider>(context, listen: false);
  //   final currentStatus = membershipProvider.membershipStatus;

  //   if (currentStatus != null &&
  //       (currentStatus['status']?.toLowerCase() == 'active' ||
  //           currentStatus['status']?.toLowerCase() == 'pending')) {
  //     showCoolSnackBar(
  //       context,
  //       "You already have an ${currentStatus['status']} membership",
  //       false,
  //     );
  //     return;
  //   }

  //   return showDialog(
  //     context: context,
  //     barrierDismissible: !_isApplying,
  //     builder: (BuildContext dialogContext) => AlertDialog(
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(20),
  //       ),
  //       title: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text(
  //             'Confirm Membership',
  //             style: TextStyle(
  //               color: Theme.of(context).colorScheme.primary,
  //               fontWeight: FontWeight.bold,
  //             ),
  //           ),
  //           const SizedBox(height: 12),
  //           Container(
  //             padding: const EdgeInsets.all(12),
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   planType,
  //                   style: const TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 Text(
  //                   'NRS $price',
  //                   style: TextStyle(
  //                     fontSize: 16,
  //                     color: Theme.of(context).colorScheme.secondary,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ],
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             'Select Payment Method:',
  //             style: TextStyle(
  //               fontWeight: FontWeight.w600,
  //               fontSize: 16,
  //             ),
  //           ),
  //           const SizedBox(height: 16),
  //           _buildPaymentOption(
  //             dialogContext,
  //             'Pay with Khalti',
  //             Icons.account_balance_wallet,
  //             Colors.purple,
  //             !_isApplying,
  //             () async {
  //               Navigator.pop(dialogContext);
  //               final provider =
  //                   Provider.of<MembershipProvider>(context, listen: false);
  //               await provider.applyForMembershipUsingKhalti(
  //                   context, planId, int.parse(price), 'Khalti');
  //               if (context.mounted) {
  //                 context.pushNamed('khalti');
  //               }
  //             },
  //           ),
  //           const SizedBox(height: 12),
  //           _buildPaymentOption(
  //             dialogContext,
  //             'Pay with Cash',
  //             Icons.money,
  //             Colors.green,
  //             !_isApplying,
  //             () async {
  //               Navigator.pop(dialogContext);
  //               await _applyForMembership(context, planId, 'Cash');
  //             },
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           style: TextButton.styleFrom(
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(8),
  //             ),
  //           ),
  //           onPressed: _isApplying ? null : () => Navigator.pop(dialogContext),
  //           child: const Text('Cancel'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> _showPaymentDialog(
    BuildContext context,
    int planId,
    String planType,
    String price,
  ) async {
    if (_isApplying) {
      // Show notification if already applying
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              const Text('Application in Progress'),
            ],
          ),
          content: const Text(
            'Your membership application is already being processed. Please wait for it to complete before applying again.',
            textAlign: TextAlign.center,
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final membershipProvider =
        Provider.of<MembershipProvider>(context, listen: false);
    final currentStatus = membershipProvider.membershipStatus;

    if (currentStatus != null &&
        (currentStatus['status']?.toLowerCase() == 'active' ||
            currentStatus['status']?.toLowerCase() == 'pending')) {
      // Show dialog for existing membership
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                currentStatus['status']?.toLowerCase() == 'active'
                    ? Icons.check_circle
                    : Icons.pending_actions,
                color: currentStatus['status']?.toLowerCase() == 'active'
                    ? Colors.green
                    : Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                'Membership ${currentStatus['status']}',
                style: TextStyle(
                  color: currentStatus['status']?.toLowerCase() == 'active'
                      ? Colors.green
                      : Colors.orange,
                ),
              ),
            ],
          ),
          content: Text(
            "You already have an ${currentStatus['status']} membership. You cannot apply for a new plan until your current membership expires or is cancelled.",
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Show payment method selection dialog
    return showDialog(
      context: context,
      barrierDismissible: !_isApplying,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Confirm Membership',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    planType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'NRS $price',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              dialogContext,
              'Pay with Khalti',
              Icons.account_balance_wallet,
              Colors.purple,
              !_isApplying,
              () async {
                setState(() => _isApplying = true);
                Navigator.pop(dialogContext);

                try {
                  final provider =
                      Provider.of<MembershipProvider>(context, listen: false);
                  await provider.applyForMembershipUsingKhalti(
                      context, planId, int.parse(price), 'Khalti');

                  if (context.mounted) {
                    context.pushNamed('khalti');
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
              },
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              dialogContext,
              'Pay with Cash',
              Icons.money,
              Colors.green,
              !_isApplying,
              () async {
                Navigator.pop(dialogContext);
                await _applyForMembership(context, planId, 'Cash');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _isApplying ? null : () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    bool enabled,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color:
              enabled ? color.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                enabled ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: enabled ? color : Colors.grey,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: enabled ? color : Colors.grey,
              ),
            ),
          ],
        ),
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
      appBar: const CustomAppBar(title: 'Membership'),
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
                      if (membershipProvider.membership != null)
                        _buildMembershipStatus(membershipProvider.membership!),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.fitness_center,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Available Plans',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      _buildMembershipPlans(membershipProvider),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildMembershipPlans(MembershipProvider membershipProvider) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.6,
          mainAxisSpacing: 16,
        ),
        itemCount: membershipProvider.plans.length,
        itemBuilder: (context, index) {
          final plan = membershipProvider.plans[index];
          final planType = plan['plan_type'];
          final price = plan['price'];
          final duration = plan['duration'];

          return _buildPlanCard(
            index,
            planType,
            price,
            duration.toString(),
            plan['description'] ?? 'Access to all gym facilities and equipment',
            () => _showPaymentDialog(
              context,
              plan['plan_id'],
              planType,
              price,
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlanCard(
    int index,
    String planType,
    String price,
    String duration,
    String description,
    VoidCallback onApply,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final colors = [
      [Colors.blue, Colors.lightBlue],
      [Colors.purple, Colors.purpleAccent],
      [Colors.green, Colors.lightGreen],
      [Colors.orange, Colors.amber],
    ];

    final colorIndex = index % colors.length;
    final primaryColor = colors[colorIndex][0];
    final secondaryColor = colors[colorIndex][1];

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(isDarkMode ? 0.2 : 0.1),
            secondaryColor.withOpacity(isDarkMode ? 0.1 : 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background pattern
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan type and icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        planType,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.fitness_center,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Price and duration
                  Row(
                    children: [
                      Text(
                        'NRS $price',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '/ $duration months',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Description
                  Expanded(
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Apply button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      onPressed: _isApplying ? null : onApply,
                      child: _isApplying
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Apply Now',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
