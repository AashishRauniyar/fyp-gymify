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

class _MembershipScreenState extends State<MembershipScreen> {
  bool _isLoading = false;
  bool _isApplying = false;

  String formatDate(DateTime date) {
    final DateFormat formatter =
        DateFormat('yyyy-MM-dd'); // Formats as '2025-03-18'
    return formatter.format(date);
  }

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

  Widget _buildMembershipStatus(Membership membership) {
    final statusColor = membership.status.toLowerCase() == 'active'
        ? Colors.green
        : membership.status.toLowerCase() == 'pending'
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
                  membership.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildStatusRow('Plan Type:', membership.planType),
          _buildStatusRow('Price:', 'NRS ${membership.price}'),
          _buildStatusRow('Payment Status:', membership.paymentStatus),
          if (membership.status == 'Active')
            _buildStatusRow('Start Date:', formatDate(membership.startDate!)),
          if (membership.status == 'Active')
            _buildStatusRow('End Date:', formatDate(membership.endDate!)),
          // if membership inactive, show please collect card from gym counter message after payment
          if (membership.status.toLowerCase() == 'pending')
            const Text(
              'Please collect your membership card from the gym counter after payment.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),

          // if membership active, show card number from profile fetch
          if (membership.status.toLowerCase() == 'active')
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
                // await _applyForMembership(context, planId, 'Khalti');
                final provider =
                    Provider.of<MembershipProvider>(context, listen: false);

                await provider.applyForMembershipUsingKhalti(
                    context, planId, int.parse(price), 'Khalti');

                // if (mounted) {
                //   return;
                // }
                if (context.mounted) {
                  context.pushNamed('khalti');
                }

                // open khalti sdk
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

      //

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
                      if (membershipProvider.membership != null)
                        _buildMembershipStatus(membershipProvider.membership!),
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
