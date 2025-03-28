import 'package:flutter/material.dart';
import 'package:gymify/providers/attendance_provider/attendance_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class AttendanceDatePicker extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  final double height;
  final DateTime initialDate;

  const AttendanceDatePicker({
    super.key,
    this.onDateSelected,
    this.height = 100,
    required this.initialDate,
  });

  @override
  State<AttendanceDatePicker> createState() => _AttendanceDatePickerState();
}

class _AttendanceDatePickerState extends State<AttendanceDatePicker> {
  late DateTime _selectedDate;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
    _scrollController = ScrollController();

    // Position to today initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date header showing month and year
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('MMMM yyyy').format(_selectedDate),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                // Today button
                TextButton.icon(
                  onPressed: () {
                    final today = DateTime.now();
                    setState(() {
                      _selectedDate = today;
                    });
                    // Scroll to today
                    _scrollToToday();
                    if (widget.onDateSelected != null) {
                      widget.onDateSelected!(today);
                    }
                  },
                  icon: Icon(Icons.calendar_today,
                      size: 18, color: theme.colorScheme.primary),
                  label: Text(
                    'Today',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                // Legend for attendance colors
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Attended',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Missed',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Custom date picker with our own custom implementation
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Expanded(
                child: _buildCustomDatePicker(context, attendanceProvider),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _scrollToToday() {
    // Calculate position of today
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month - 1, 1);
    final difference = today.difference(startDate).inDays;

    // Scroll to today's position (width of each item is 60 + 8 for margins)
    if (_scrollController.hasClients) {
      _scrollController.animateTo(difference * 68.0,
          duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  Widget _buildCustomDatePicker(
      BuildContext context, AttendanceProvider attendanceProvider) {
    final theme = Theme.of(context);

    // Create a list of dates for the current view (2 months)
    final today = DateTime.now();
    final startDate = DateTime(today.year, today.month - 1, 1);
    final endDate = DateTime(today.year, today.month + 1, 0);
    final daysCount = endDate.difference(startDate).inDays + 1;

    // Position scroll controller initially near today
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: daysCount,
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isToday = date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;

        final isSelected = date.year == _selectedDate.year &&
            date.month == _selectedDate.month &&
            date.day == _selectedDate.day;

        final isAttended = attendanceProvider.attendanceDays
            .containsKey(DateTime(date.year, date.month, date.day));

        final isPastDate =
            date.isBefore(DateTime(today.year, today.month, today.day));

        // Color logic for attendance status
        Color backgroundColor;
        Color textColor = theme.colorScheme.onSurface;
        BoxBorder? border;

        if (isSelected) {
          backgroundColor = theme.colorScheme.primary;
          textColor = Colors.white;
        } else if (isToday) {
          backgroundColor = theme.colorScheme.surface;
          textColor = theme.colorScheme.primary;
          border = Border.all(
            color: theme.colorScheme.primary,
            width: 2,
          );
        } else if (isAttended) {
          backgroundColor = theme.colorScheme.primary.withOpacity(0.2);
          textColor = theme.colorScheme.primary;
        } else if (isPastDate) {
          backgroundColor = Colors.red.withOpacity(0.1);
          textColor = Colors.red.shade800;
        } else {
          backgroundColor = theme.colorScheme.surface;
        }

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedDate = date;
            });
            if (widget.onDateSelected != null) {
              widget.onDateSelected!(date);
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            width: 60,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(14),
              border: border,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: theme.colorScheme.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('MMM').format(date),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date.day.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('E').format(date),
                  style: TextStyle(
                    fontSize: 11,
                    color: isSelected
                        ? Colors.white.withOpacity(0.8)
                        : Colors.grey,
                  ),
                ),

                // Attendance indicator dot
                if (isAttended && !isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
