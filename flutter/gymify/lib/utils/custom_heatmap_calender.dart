import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomHeatMapCalendar extends StatelessWidget {
  final Map<DateTime, int> dataset; // Dataset for each date's activity level
  final DateTime startDate;
  final DateTime endDate;

  const CustomHeatMapCalendar({
    super.key,
    required this.dataset,
    required this.startDate,
    required this.endDate,
  });

  // Helper to get the number of days in a month
  int getDaysInMonth(DateTime date) {
    return DateTime(date.year, date.month + 1, 0).day;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = getDaysInMonth(startDate);
    final firstDayOfMonth = DateTime(startDate.year, startDate.month, 1);
    final lastDayOfMonth =
        DateTime(startDate.year, startDate.month, daysInMonth);

    // Generate the calendar grid
    List<Widget> calendarDays = [];
    for (int i = 0; i < daysInMonth; i++) {
      DateTime date = DateTime(startDate.year, startDate.month, i + 1);
      int heatValue = dataset[date] ?? 0; // Get heat value (0 if no data)

      // Color intensity based on heat value
      Color dayColor = _getColorFromHeatValue(heatValue);

      calendarDays.add(
        GestureDetector(
          onTap: () {
            // Add interaction for clicking the date
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Date: ${DateFormat('MMMM dd').format(date)} - Heat: $heatValue'),
            ));
          },
          child: Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: dayColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                (i + 1).toString(),
                style: TextStyle(
                  color: heatValue > 5 ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Create rows for the calendar grid
    List<Widget> rows = [];
    int rowCount = (calendarDays.length / 7).ceil();
    for (int i = 0; i < rowCount; i++) {
      int startIndex = i * 7;
      int endIndex = (i + 1) * 7;

      List<Widget> rowChildren = calendarDays.sublist(startIndex,
          endIndex > calendarDays.length ? calendarDays.length : endIndex);

      // Add empty space for missing days
      while (rowChildren.length < 7) {
        rowChildren.add(const SizedBox.shrink());
      }

      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowChildren,
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header for the days of the week
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Sun'),
            Text('Mon'),
            Text('Tue'),
            Text('Wed'),
            Text('Thu'),
            Text('Fri'),
            Text('Sat'),
          ],
        ),
        // Display the calendar rows
        ...rows,
      ],
    );
  }

  // Function to map heat value to a color intensity
  Color _getColorFromHeatValue(int heatValue) {
    if (heatValue == 0) return const Color(0xFFE0E0E0); // No activity
    if (heatValue <= 3) return Colors.lightGreenAccent; // Low activity
    if (heatValue <= 7) return Colors.yellow; // Moderate activity
    if (heatValue <= 10) return Colors.orange; // High activity
    return Colors.red; // Very high activity
  }
}
