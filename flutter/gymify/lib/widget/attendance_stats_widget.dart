import 'package:flutter/material.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:gymify/providers/attendance_provider/attendance_provider.dart';

class AttendanceStatsWidget extends StatelessWidget {
  const AttendanceStatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return _buildLoadingState(context);
        }

        if (provider.hasError) {
          return _buildErrorState(context);
        }

        if (provider.attendanceHistory.isEmpty) {
          return _buildEmptyState(context);
        }

        // Get attendance stats
        final stats = provider.getAttendanceStats(daysToConsider: 30);
        final currentStreak = stats['currentStreak'] as int;
        final longestStreak = stats['longestStreak'] as int;
        final attendanceRate = stats['attendanceRate'] as double;

        // Calculate today's status
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final isCheckedInToday = provider.attendanceDays.containsKey(today);

        return _buildAttendanceCard(
          context,
          attendanceRate,
          currentStreak,
          longestStreak,
          provider.totalAttendance,
          isCheckedInToday,
        );
      },
    );
  }

  Widget _buildAttendanceCard(
    BuildContext context,
    double attendanceRate,
    int currentStreak,
    int longestStreak,
    int totalAttendance,
    bool isCheckedInToday,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),

        gradient: Theme.of(context).brightness == Brightness.dark
            ? LinearGradient(
                colors: [
                  theme.colorScheme.onSurface.withOpacity(0.1),
                  theme.colorScheme.onSurface.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null, // For light mode, no gradient, just a white background
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white // White background for light mode
            : null, // Dark mode will apply the gradient above
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gym Attendance',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          isCheckedInToday
                              ? Icons.check_circle
                              : Icons.schedule,
                          color:
                              isCheckedInToday ? Colors.green : Colors.orange,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isCheckedInToday
                              ? 'Checked in today'
                              : 'Not checked in today',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                isCheckedInToday ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalAttendance total visits',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              CircularPercentIndicator(
                radius: 40.0,
                lineWidth: 8.0,
                percent: attendanceRate,
                center: Text(
                  '${(attendanceRate * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                progressColor: _getAttendanceRateColor(attendanceRate),
                backgroundColor:
                    _getAttendanceRateColor(attendanceRate).withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatistic(
                  context,
                  'Current Streak',
                  '$currentStreak',
                  'days',
                  _getStreakColor(currentStreak),
                  Icons.local_fire_department),
              _buildStatistic(context, 'Longest Streak', '$longestStreak',
                  'days', Colors.amber, Icons.emoji_events),
              _buildStatistic(
                  context,
                  'This Month',
                  (attendanceRate * 30).toStringAsFixed(0),
                  '/30',
                  Colors.blue,
                  Icons.calendar_month),
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/attendance');
            },
            icon: const Icon(Icons.analytics),
            label: const Text('View Attendance Details'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.colorScheme.primary,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistic(BuildContext context, String label, String value,
      String unit, Color color, IconData icon) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$value$unit',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Color _getStreakColor(int streak) {
    if (streak >= 30) return Colors.deepPurple;
    if (streak >= 14) return Colors.deepOrange;
    if (streak >= 7) return Colors.orange;
    return Colors.blue;
  }

  Color _getAttendanceRateColor(double rate) {
    if (rate >= 0.8) return Colors.green;
    if (rate >= 0.6) return Colors.amber;
    if (rate >= 0.4) return Colors.orange;
    return Colors.red;
  }

  Widget _buildLoadingState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'Could not load attendance data',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Get userId from AuthProvider and fetch attendance
              final userId =
                  Provider.of<AuthProvider>(context, listen: false).userId;
              if (userId != null) {
                Provider.of<AttendanceProvider>(context, listen: false)
                    .fetchAttendanceHistory(int.parse(userId));
              }
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.fitness_center,
            color: theme.colorScheme.secondary.withOpacity(0.5),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            'No attendance data available',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Check in at the gym to start tracking your attendance',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: () {
              context.push('/attendance');
            },
            icon: const Icon(Icons.calendar_month),
            label: const Text('View Attendance Calendar'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: theme.colorScheme.primary,
              minimumSize: const Size(double.infinity, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
