import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/membership_models/membership_model.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isApplying = false;
  bool _isEsewaPaymentPending = false;
  bool _isCancellingMembership = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  StreamSubscription? _esewaSub;
  final AppLinks _appLinks = AppLinks();

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

    // Listen for eSewa payment redirect
    _listenForEsewaRedirect();
  }

  void _listenForEsewaRedirect() {
    _esewaSub = _appLinks.uriLinkStream.listen((Uri? uri) async {
      if (uri != null) {
        if (uri.path == '/payment/success') {
          final data = uri.queryParameters['data'];
          print('eSewa redirect received!');
          print('Redirect URI: $uri');
          print('Data parameter from eSewa: ${data ?? 'null'}');
          if (data != null) {
            setState(() => _isEsewaPaymentPending = true);
            try {
              print('Calling verifyEsewaPayment with data: $data');
              final provider =
                  Provider.of<MembershipProvider>(context, listen: false);
              await provider.verifyEsewaPayment(context, data);
              if (mounted) {
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('eSewa Payment Successful! Membership Activated.'),
                    backgroundColor: Colors.green,
                  ),
                );

                // Refresh membership status
                await provider.fetchMembershipStatus(context);

                // Force rebuild the widget
                setState(() {});

                // Optional: Add a small delay to ensure smooth transition
                await Future.delayed(const Duration(milliseconds: 500));

                // Navigate back to membership screen to show updated status
                if (mounted) {
                  context.go('/membership');
                }
              }
            } catch (e) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text('Payment verification failed: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            } finally {
              if (mounted) {
                setState(() => _isEsewaPaymentPending = false);
              }
            }
          }
        } else if (uri.path == '/payment/failure') {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Payment was cancelled or failed. Please try again.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }, onError: (err) {
      print('Error in eSewa redirect: $err');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Error processing payment redirect. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _esewaSub?.cancel();
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

                  // Show Cancel Membership button if status is pending
                  if (membership.status.toLowerCase() == 'pending')
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.cancel, color: Colors.white),
                          label: _isCancellingMembership
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Cancel Membership Request'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _isCancellingMembership
                              ? null
                              : () async {
                                  setState(
                                      () => _isCancellingMembership = true);
                                  final provider =
                                      Provider.of<MembershipProvider>(context,
                                          listen: false);
                                  try {
                                    await provider.deleteMembership(context);
                                    if (mounted) {
                                      showCoolSnackBar(
                                          context,
                                          'Membership request cancelled.',
                                          true);
                                      await provider
                                          .fetchMembershipStatus(context);
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      showCoolSnackBar(
                                          context,
                                          'Failed to cancel membership: \\${e.toString()}',
                                          false);
                                    }
                                  } finally {
                                    if (mounted)
                                      setState(() =>
                                          _isCancellingMembership = false);
                                  }
                                },
                        ),
                      ),
                    ),

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
              'assets/logo/khalti.png',
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
              'assets/logo/cash.png',
              Colors.green,
              !_isApplying,
              () async {
                Navigator.pop(dialogContext);
                await _applyForMembership(context, planId, 'Cash');
              },
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              dialogContext,
              'Pay with eSewa',
              'assets/logo/esewa.png',
              Colors.green,
              !_isApplying && !_isEsewaPaymentPending,
              () async {
                setState(() => _isApplying = true);
                Navigator.pop(dialogContext);

                try {
                  final provider =
                      Provider.of<MembershipProvider>(context, listen: false);
                  await provider.applyForMembershipUsingEsewa(
                      context, planId, int.parse(price));
                } catch (e) {
                  if (mounted) {
                    String errorMessage = 'Payment failed: ';
                    if (e.toString().contains('network')) {
                      errorMessage += 'Please check your internet connection';
                    } else if (e.toString().contains('invalid')) {
                      errorMessage += 'Invalid payment details';
                    } else {
                      errorMessage += e.toString();
                    }
                    showCoolSnackBar(context, errorMessage, false);
                  }
                } finally {
                  if (mounted) {
                    setState(() => _isApplying = false);
                  }
                }
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
    String imagePath,
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
            Image.asset(
              imagePath,
              height: 28,
              width: 28,
              color: enabled ? null : Colors.grey,
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
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        itemCount: membershipProvider.plans.length,
        itemBuilder: (context, index) {
          final plan = membershipProvider.plans[index];
          final planType = plan['plan_type'];
          final price = plan['price'];
          final duration = plan['duration'];

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPlanCard(
              index,
              planType,
              price,
              duration.toString(),
              plan['description'] ??
                  'Access to all gym facilities and equipment',
              () => _showPaymentDialog(
                context,
                plan['plan_id'],
                planType,
                price,
              ),
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

    // Check if the user has an active membership
    final membershipProvider = Provider.of<MembershipProvider>(context);
    final hasActiveMembership = membershipProvider.membership != null &&
        membershipProvider.membership!.status.toLowerCase() == 'active';

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
                  Text(
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
                      onPressed:
                          (hasActiveMembership || _isApplying) ? null : onApply,
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
                          : Text(
                              hasActiveMembership
                                  ? 'Active Membership'
                                  : 'Apply Now',
                              style: const TextStyle(
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
