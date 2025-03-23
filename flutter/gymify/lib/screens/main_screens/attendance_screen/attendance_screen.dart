// import 'package:flutter/material.dart';
// import 'package:gymify/providers/attendance_provider/attendance_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';

// class AttendanceCalendarScreen extends StatefulWidget {
//   const AttendanceCalendarScreen({super.key});

//   @override
//   State<AttendanceCalendarScreen> createState() =>
//       _AttendanceCalendarScreenState();
// }

// class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime _currentMonth = DateTime.now();

//   // For date range selection
//   DateTime _rangeStart = DateTime.now().subtract(const Duration(days: 30));
//   DateTime _rangeEnd = DateTime.now();

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);

//     // Get tab index from route arguments if available
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is int && args >= 0 && args < 3) {
//         _tabController.index = args;
//       }

//       _fetchAttendanceData();
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchAttendanceData() async {
//     final userId = Provider.of<AuthProvider>(context, listen: false).userId;
//     if (userId != null) {
//       await Provider.of<AttendanceProvider>(context, listen: false)
//           .fetchAttendanceHistory(int.parse(userId),
//               startDate: _rangeStart, endDate: _rangeEnd);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Tracker'),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'Calendar'),
//             Tab(text: 'Stats'),
//             Tab(text: 'History'),
//           ],
//         ),
//       ),
//       body: Consumer<AttendanceProvider>(
//         builder: (context, attendanceProvider, child) {
//           if (attendanceProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (attendanceProvider.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Error loading attendance data',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(attendanceProvider.errorMessage),
//                   const SizedBox(height: 16),
//                   ElevatedButton(
//                     onPressed: _fetchAttendanceData,
//                     child: const Text('Retry'),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return TabBarView(
//             controller: _tabController,
//             children: [
//               _buildCalendarTab(attendanceProvider),
//               _buildStatsTab(attendanceProvider),
//               _buildHistoryTab(attendanceProvider),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCalendarTab(AttendanceProvider attendanceProvider) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TableCalendar(
//                   firstDay: DateTime.utc(2020, 1, 1),
//                   lastDay: DateTime.now(),
//                   focusedDay: _focusedDay,
//                   calendarFormat: _calendarFormat,
//                   selectedDayPredicate: (day) {
//                     return isSameDay(_selectedDay, day);
//                   },
//                   eventLoader: (day) {
//                     // Mark days with attendance records
//                     if (attendanceProvider.attendanceDays.containsKey(
//                       DateTime(day.year, day.month, day.day),
//                     )) {
//                       return ['present'];
//                     }
//                     return [];
//                   },
//                   onDaySelected: (selectedDay, focusedDay) {
//                     setState(() {
//                       _selectedDay = selectedDay;
//                       _focusedDay = focusedDay;
//                     });
//                   },
//                   onFormatChanged: (format) {
//                     setState(() {
//                       _calendarFormat = format;
//                     });
//                   },
//                   onPageChanged: (focusedDay) {
//                     // Update the month when navigating
//                     _focusedDay = focusedDay;
//                     setState(() {
//                       _currentMonth = focusedDay;
//                     });
//                   },
//                   calendarStyle: CalendarStyle(
//                     // Marks for attendance days
//                     markersMaxCount: 1,
//                     markerDecoration: const BoxDecoration(
//                       color: Colors.green,
//                       shape: BoxShape.circle,
//                     ),
//                     // Today's style
//                     todayDecoration: BoxDecoration(
//                       color: Theme.of(context).primaryColor.withOpacity(0.3),
//                       shape: BoxShape.circle,
//                     ),
//                     // Selected day style
//                     selectedDecoration: BoxDecoration(
//                       color: Theme.of(context).primaryColor,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   headerStyle: const HeaderStyle(
//                     formatButtonVisible: true,
//                     titleCentered: true,
//                     formatButtonShowsNext: false,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           // Monthly summary card
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Card(
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${DateFormat('MMMM yyyy').format(_currentMonth)} Summary',
//                           style: Theme.of(context).textTheme.titleLarge,
//                         ),
//                         _buildAttendanceIndicator(),
//                       ],
//                     ),
//                     const SizedBox(height: 16),
//                     // Monthly stats
//                     _buildMonthlySummary(attendanceProvider),

//                     if (_selectedDay != null) ...[
//                       const Divider(height: 24),
//                       Text(
//                         'Selected Day: ${DateFormat('EEEE, MMMM d, yyyy').format(_selectedDay!)}',
//                         style: Theme.of(context).textTheme.titleMedium,
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         attendanceProvider.attendanceDays.containsKey(
//                           DateTime(_selectedDay!.year, _selectedDay!.month,
//                               _selectedDay!.day),
//                         )
//                             ? 'Status: Present ✓'
//                             : 'Status: Absent ✗',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: attendanceProvider.attendanceDays.containsKey(
//                             DateTime(_selectedDay!.year, _selectedDay!.month,
//                                 _selectedDay!.day),
//                           )
//                               ? Colors.green
//                               : Colors.red,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMonthlySummary(AttendanceProvider attendanceProvider) {
//     final daysInMonth =
//         DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
//     int presentDays = 0;

//     for (int day = 1; day <= daysInMonth; day++) {
//       final date = DateTime(_currentMonth.year, _currentMonth.month, day);
//       if (attendanceProvider.attendanceDays.containsKey(date)) {
//         presentDays++;
//       }
//     }

//     final attendanceRate = presentDays / daysInMonth;

//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Days Present:'),
//             Text('$presentDays / $daysInMonth'),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text('Attendance Rate:'),
//             Text('${(attendanceRate * 100).toStringAsFixed(1)}%'),
//           ],
//         ),
//         const SizedBox(height: 16),
//         LinearProgressIndicator(
//           value: attendanceRate,
//           minHeight: 10,
//           backgroundColor: Colors.grey[300],
//           valueColor: AlwaysStoppedAnimation<Color>(
//             attendanceRate >= 0.8
//                 ? Colors.green
//                 : attendanceRate >= 0.6
//                     ? Colors.amber
//                     : Colors.red,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildAttendanceIndicator() {
//     return Row(
//       children: [
//         Container(
//           width: 16,
//           height: 16,
//           decoration: const BoxDecoration(
//             color: Colors.green,
//             shape: BoxShape.circle,
//           ),
//         ),
//         const SizedBox(width: 4),
//         const Text('Present'),
//       ],
//     );
//   }

//   Widget _buildStatsTab(AttendanceProvider attendanceProvider) {
//     final stats = attendanceProvider.getAttendanceStats(daysToConsider: 30);

//     return SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Attendance statistics cards
//             _buildStatsCards(stats),

//             const SizedBox(height: 24),

//             // Weekly attendance chart
//             _buildWeeklyAttendanceChart(attendanceProvider),

//             const SizedBox(height: 24),

//             // Monthly attendance chart
//             _buildMonthlyAttendanceChart(attendanceProvider),

//             const SizedBox(height: 16),

//             // Date range picker for custom stats
//             _buildDateRangePicker(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatsCards(Map<String, dynamic> stats) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Attendance Overview',
//           style: Theme.of(context).textTheme.titleLarge,
//         ),
//         const SizedBox(height: 16),
//         GridView.count(
//           crossAxisCount: 2,
//           crossAxisSpacing: 16,
//           mainAxisSpacing: 16,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           children: [
//             _buildStatCard(
//               title: '30-Day Rate',
//               value: '${(stats['attendanceRate'] * 100).toStringAsFixed(1)}%',
//               icon: Icons.calendar_today,
//               color: stats['attendanceRate'] >= 0.8
//                   ? Colors.green
//                   : stats['attendanceRate'] >= 0.6
//                       ? Colors.amber
//                       : Colors.red,
//             ),
//             _buildStatCard(
//               title: 'Current Streak',
//               value: '${stats['currentStreak']} days',
//               icon: Icons.local_fire_department,
//               color: Colors.orange,
//             ),
//             _buildStatCard(
//               title: 'Longest Streak',
//               value: '${stats['longestStreak']} days',
//               icon: Icons.emoji_events,
//               color: Colors.amber,
//             ),
//             _buildStatCard(
//               title: 'Total Check-ins',
//               value:
//                   '${Provider.of<AttendanceProvider>(context, listen: false).totalAttendance}',
//               icon: Icons.check_circle_outline,
//               color: Colors.blue,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildStatCard({
//     required String title,
//     required String value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 32, color: color),
//             const SizedBox(height: 8),
//             Text(
//               title,
//               style: Theme.of(context).textTheme.titleSmall,
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: Theme.of(context).textTheme.headlineSmall?.copyWith(
//                     color: color,
//                     fontWeight: FontWeight.bold,
//                   ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeeklyAttendanceChart(AttendanceProvider attendanceProvider) {
//     final today = DateTime.now();
//     final weekData = <String, bool>{};

//     // Create data for the past 7 days
//     for (int i = 6; i >= 0; i--) {
//       final day = today.subtract(Duration(days: i));
//       final dateKey = DateTime(day.year, day.month, day.day);
//       weekData[DateFormat('E').format(day)] =
//           attendanceProvider.attendanceDays.containsKey(dateKey);
//     }

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Past Week Attendance',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: 1,
//                   barTouchData: BarTouchData(enabled: false),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           if (value < 0 || value >= weekData.length) {
//                             return const SizedBox();
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               weekData.keys.elementAt(value.toInt()),
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     leftTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   barGroups: List.generate(
//                     weekData.length,
//                     (index) => BarChartGroupData(
//                       x: index,
//                       barRods: [
//                         BarChartRodData(
//                           toY: weekData.values.elementAt(index) ? 1 : 0,
//                           color: weekData.values.elementAt(index)
//                               ? Colors.green
//                               : Colors.red,
//                           width: 20,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(4),
//                             topRight: Radius.circular(4),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 16,
//                   height: 16,
//                   decoration: const BoxDecoration(
//                     color: Colors.green,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Text('Present'),
//                 const SizedBox(width: 16),
//                 Container(
//                   width: 16,
//                   height: 16,
//                   decoration: const BoxDecoration(
//                     color: Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Text('Absent'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMonthlyAttendanceChart(AttendanceProvider attendanceProvider) {
//     final now = DateTime.now();
//     final monthlyData = <String, double>{};

//     // Generate data for the past 6 months
//     for (int i = 5; i >= 0; i--) {
//       final month = DateTime(now.year, now.month - i, 1);
//       final monthName = DateFormat('MMM').format(month);
//       monthlyData[monthName] = attendanceProvider.getMonthAttendanceRate(month);
//     }

//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Monthly Attendance Rate',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               height: 200,
//               child: LineChart(
//                 LineChartData(
//                   gridData: const FlGridData(show: true),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           if (value < 0 || value >= monthlyData.length) {
//                             return const SizedBox();
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               monthlyData.keys.elementAt(value.toInt()),
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           return Text('${(value * 100).toInt()}%');
//                         },
//                       ),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: true),
//                   minX: 0,
//                   maxX: monthlyData.length - 1.0,
//                   minY: 0,
//                   maxY: 1,
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: List.generate(
//                         monthlyData.length,
//                         (index) => FlSpot(
//                           index.toDouble(),
//                           monthlyData.values.elementAt(index),
//                         ),
//                       ),
//                       isCurved: true,
//                       color: Theme.of(context).primaryColor,
//                       barWidth: 3,
//                       dotData: const FlDotData(show: true),
//                       belowBarData: BarAreaData(
//                         show: true,
//                         color: Theme.of(context).primaryColor.withOpacity(0.3),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDateRangePicker() {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'Custom Date Range',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.calendar_today),
//                     label: Text(DateFormat('MMM d, yyyy').format(_rangeStart)),
//                     onPressed: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: _rangeStart,
//                         firstDate: DateTime(2020),
//                         lastDate: DateTime.now(),
//                       );
//                       if (picked != null && picked != _rangeStart) {
//                         setState(() {
//                           _rangeStart = picked;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: OutlinedButton.icon(
//                     icon: const Icon(Icons.calendar_today),
//                     label: Text(DateFormat('MMM d, yyyy').format(_rangeEnd)),
//                     onPressed: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: _rangeEnd,
//                         firstDate: _rangeStart,
//                         lastDate: DateTime.now(),
//                       );
//                       if (picked != null && picked != _rangeEnd) {
//                         setState(() {
//                           _rangeEnd = picked;
//                         });
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {
//                   final userId =
//                       Provider.of<AuthProvider>(context, listen: false).userId;
//                   if (userId != null) {
//                     Provider.of<AttendanceProvider>(context, listen: false)
//                         .fetchAttendanceHistory(int.parse(userId),
//                             startDate: _rangeStart, endDate: _rangeEnd);
//                   }
//                 },
//                 child: const Text('Apply Date Range'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHistoryTab(AttendanceProvider attendanceProvider) {
//     final attendanceHistory = attendanceProvider.attendanceHistory;

//     if (attendanceHistory.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(
//               Icons.calendar_today_outlined,
//               size: 64,
//               color: Colors.grey,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No attendance records found',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             const Text('Try selecting a different date range'),
//           ],
//         ),
//       );
//     }

//     return ListView.builder(
//       padding: const EdgeInsets.all(16),
//       itemCount: attendanceHistory.length,
//       itemBuilder: (context, index) {
//         final attendance = attendanceHistory[index];
//         return Card(
//           margin: const EdgeInsets.only(bottom: 12),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Theme.of(context).primaryColor,
//               child: const Icon(Icons.check, color: Colors.white),
//             ),
//             title: Text(
//               attendance.userInfo.fullName,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             subtitle: Text(attendance.userInfo.userName),
//             trailing: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Text(
//                   DateFormat('MMM d, yyyy').format(attendance.attendanceDate),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   DateFormat('EEEE').format(attendance.attendanceDate),
//                   style: TextStyle(color: Colors.grey[600], fontSize: 12),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

//! -----------------------------------------------------------------------------------------
//! -----------------------------------------------------------------------------------------

//! best version ever
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:gymify/providers/attendance_provider/attendance_provider.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/auth_provider/auth_provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:intl/intl.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:lottie/lottie.dart';

// class AttendanceCalendarScreen extends StatefulWidget {
//   const AttendanceCalendarScreen({super.key});

//   @override
//   State<AttendanceCalendarScreen> createState() =>
//       _AttendanceCalendarScreenState();
// }

// class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime _currentMonth = DateTime.now();

//   // For date range selection
//   DateTime _rangeStart = DateTime.now().subtract(const Duration(days: 30));
//   DateTime _rangeEnd = DateTime.now();

//   // For animations
//   bool _showHeatmap = false;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);

//     // Get tab index from route arguments if available
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final args = ModalRoute.of(context)?.settings.arguments;
//       if (args is int && args >= 0 && args < 3) {
//         _tabController.index = args;
//       }

//       _fetchAttendanceData();

//       // Animate heatmap in after data loads
//       Future.delayed(const Duration(milliseconds: 500), () {
//         if (mounted) {
//           setState(() {
//             _showHeatmap = true;
//           });
//         }
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   Future<void> _fetchAttendanceData() async {
//     final userId = Provider.of<AuthProvider>(context, listen: false).userId;
//     if (userId != null) {
//       await Provider.of<AttendanceProvider>(context, listen: false)
//           .fetchAttendanceHistory(int.parse(userId),
//               startDate: _rangeStart, endDate: _rangeEnd);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Attendance Tracker'),
//         elevation: 0,
//         bottom: TabBar(
//           controller: _tabController,
//           indicatorColor: Theme.of(context).colorScheme.secondary,
//           indicatorWeight: 3,
//           labelStyle: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//           tabs: const [
//             Tab(text: 'Calendar'),
//             Tab(text: 'Stats'),
//             Tab(text: 'History'),
//           ],
//         ),
//       ),
//       body: Consumer<AttendanceProvider>(
//         builder: (context, attendanceProvider, child) {
//           if (attendanceProvider.isLoading) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Use a fitness themed loading animation
//                   Lottie.network(
//                     'https://assets4.lottiefiles.com/packages/lf20_bXRG9q.json',
//                     width: 200,
//                     height: 200,
//                   ),
//                   const SizedBox(height: 20),
//                   Text(
//                     'Loading your fitness data...',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ],
//               ),
//             );
//           }

//           if (attendanceProvider.hasError) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                     Icons.error_outline,
//                     size: 80,
//                     color: Theme.of(context).colorScheme.error,
//                   ),
//                   const SizedBox(height: 16),
//                   Text(
//                     'Error loading attendance data',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     attendanceProvider.errorMessage,
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 24),
//                   ElevatedButton.icon(
//                     onPressed: _fetchAttendanceData,
//                     icon: const Icon(Icons.refresh),
//                     label: const Text('Retry'),
//                     style: ElevatedButton.styleFrom(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 24,
//                         vertical: 12,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }

//           return TabBarView(
//             controller: _tabController,
//             children: [
//               _buildCalendarTab(attendanceProvider, isDarkMode),
//               _buildStatsTab(attendanceProvider, isDarkMode),
//               _buildHistoryTab(attendanceProvider, isDarkMode),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildCalendarTab(
//       AttendanceProvider attendanceProvider, bool isDarkMode) {
//     final daysInMonth =
//         DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
//     int presentDays = 0;

//     for (int day = 1; day <= daysInMonth; day++) {
//       final date = DateTime(_currentMonth.year, _currentMonth.month, day);
//       if (attendanceProvider.attendanceDays.containsKey(date)) {
//         presentDays++;
//       }
//     }

//     return RefreshIndicator(
//       onRefresh: _fetchAttendanceData,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0),
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               // Monthly progress card
//               Card(
//                 elevation: 4,
//                 shadowColor:
//                     Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_month,
//                             color: Theme.of(context).colorScheme.primary,
//                             size: 28,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             DateFormat('MMMM yyyy').format(_currentMonth),
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20),

//                       // Progress circles
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           _buildProgressCircle(
//                             title: 'Days Present',
//                             value: presentDays,
//                             maxValue: daysInMonth,
//                             color: Theme.of(context).colorScheme.primary,
//                             icon: Icons.check_circle,
//                           ),
//                           _buildProgressCircle(
//                             title: 'Month Progress',
//                             value: DateTime.now().day <= daysInMonth
//                                 ? DateTime.now().day
//                                 : daysInMonth,
//                             maxValue: daysInMonth,
//                             color: Colors.amber,
//                             icon: Icons.calendar_today,
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Calendar widget
//               Card(
//                 elevation: 4,
//                 shadowColor:
//                     Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: TableCalendar(
//                     firstDay: DateTime.utc(2020, 1, 1),
//                     lastDay: DateTime.now(),
//                     focusedDay: _focusedDay,
//                     calendarFormat: _calendarFormat,
//                     selectedDayPredicate: (day) {
//                       return isSameDay(_selectedDay, day);
//                     },
//                     eventLoader: (day) {
//                       // Mark days with attendance records
//                       if (attendanceProvider.attendanceDays.containsKey(
//                         DateTime(day.year, day.month, day.day),
//                       )) {
//                         return ['present'];
//                       }
//                       return [];
//                     },
//                     onDaySelected: (selectedDay, focusedDay) {
//                       HapticFeedback.lightImpact();
//                       setState(() {
//                         _selectedDay = selectedDay;
//                         _focusedDay = focusedDay;
//                       });
//                     },
//                     onFormatChanged: (format) {
//                       setState(() {
//                         _calendarFormat = format;
//                       });
//                     },
//                     onPageChanged: (focusedDay) {
//                       // Update the month when navigating
//                       _focusedDay = focusedDay;
//                       setState(() {
//                         _currentMonth = focusedDay;
//                       });
//                     },
//                     calendarStyle: CalendarStyle(
//                       // Improved styling
//                       markersMaxCount: 1,
//                       markerDecoration: BoxDecoration(
//                         color: Theme.of(context).colorScheme.secondary,
//                         shape: BoxShape.circle,
//                       ),
//                       markerSize: 8,
//                       todayDecoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor.withOpacity(0.3),
//                         shape: BoxShape.circle,
//                       ),
//                       selectedDecoration: BoxDecoration(
//                         color: Theme.of(context).primaryColor,
//                         shape: BoxShape.circle,
//                       ),
//                       outsideDaysVisible: false,
//                       weekendTextStyle: TextStyle(
//                         color: isDarkMode ? Colors.red[200] : Colors.red,
//                       ),
//                     ),
//                     headerStyle: HeaderStyle(
//                       titleCentered: true,
//                       formatButtonDecoration: BoxDecoration(
//                         color: Theme.of(context)
//                             .colorScheme
//                             .secondary
//                             .withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       formatButtonTextStyle: TextStyle(
//                         color: Theme.of(context).colorScheme.secondary,
//                       ),
//                       leftChevronIcon: Icon(
//                         Icons.chevron_left,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                       rightChevronIcon: Icon(
//                         Icons.chevron_right,
//                         color: Theme.of(context).colorScheme.primary,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 20),

//               // Selected day info
//               if (_selectedDay != null)
//                 Card(
//                   elevation: 4,
//                   shadowColor:
//                       Theme.of(context).colorScheme.primary.withOpacity(0.3),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16)),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           DateFormat('EEEE, MMMM d, yyyy')
//                               .format(_selectedDay!),
//                           style: Theme.of(context).textTheme.titleMedium,
//                         ),
//                         const SizedBox(height: 16),
//                         Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 24,
//                               backgroundColor:
//                                   attendanceProvider.attendanceDays.containsKey(
//                                 DateTime(_selectedDay!.year,
//                                     _selectedDay!.month, _selectedDay!.day),
//                               )
//                                       ? Colors.green.withOpacity(0.2)
//                                       : Colors.red.withOpacity(0.2),
//                               child: Icon(
//                                 attendanceProvider.attendanceDays.containsKey(
//                                   DateTime(_selectedDay!.year,
//                                       _selectedDay!.month, _selectedDay!.day),
//                                 )
//                                     ? Icons.check
//                                     : Icons.close,
//                                 color: attendanceProvider.attendanceDays
//                                         .containsKey(
//                                   DateTime(_selectedDay!.year,
//                                       _selectedDay!.month, _selectedDay!.day),
//                                 )
//                                     ? Colors.green
//                                     : Colors.red,
//                                 size: 32,
//                               ),
//                             ),
//                             const SizedBox(width: 16),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     attendanceProvider.attendanceDays
//                                             .containsKey(
//                                       DateTime(
//                                           _selectedDay!.year,
//                                           _selectedDay!.month,
//                                           _selectedDay!.day),
//                                     )
//                                         ? 'Attendance Recorded'
//                                         : 'No Attendance',
//                                     style: Theme.of(context)
//                                         .textTheme
//                                         .titleMedium
//                                         ?.copyWith(
//                                           color: attendanceProvider
//                                                   .attendanceDays
//                                                   .containsKey(
//                                             DateTime(
//                                                 _selectedDay!.year,
//                                                 _selectedDay!.month,
//                                                 _selectedDay!.day),
//                                           )
//                                               ? Colors.green
//                                               : Colors.red,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     attendanceProvider.attendanceDays
//                                             .containsKey(
//                                       DateTime(
//                                           _selectedDay!.year,
//                                           _selectedDay!.month,
//                                           _selectedDay!.day),
//                                     )
//                                         ? 'Checked in for workout'
//                                         : isFutureDate(_selectedDay!)
//                                             ? 'Future date'
//                                             : 'You missed your workout',
//                                     style:
//                                         Theme.of(context).textTheme.bodyMedium,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//               const SizedBox(height: 24),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   bool isFutureDate(DateTime date) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final checkDate = DateTime(date.year, date.month, date.day);
//     return checkDate.isAfter(today);
//   }

//   Widget _buildProgressCircle({
//     required String title,
//     required int value,
//     required int maxValue,
//     required Color color,
//     required IconData icon,
//   }) {
//     return Column(
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             SizedBox(
//               height: 100,
//               width: 100,
//               child: CircularProgressIndicator(
//                 value: maxValue > 0 ? value / maxValue : 0,
//                 strokeWidth: 10,
//                 backgroundColor: Colors.grey[300],
//                 valueColor: AlwaysStoppedAnimation<Color>(color),
//               ),
//             ),
//             Column(
//               children: [
//                 Icon(icon, color: color),
//                 const SizedBox(height: 4),
//                 Text(
//                   '$value/$maxValue',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         const SizedBox(height: 12),
//         Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//       ],
//     );
//   }

//   Widget _buildStatsTab(
//       AttendanceProvider attendanceProvider, bool isDarkMode) {
//     final stats = attendanceProvider.getAttendanceStats(daysToConsider: 30);
//     final currentStreak = stats['currentStreak'] as int;
//     final longestStreak = stats['longestStreak'] as int;

//     // Define colors based on theme
//     final primaryColor = Theme.of(context).colorScheme.primary;
//     final secondaryColor = Theme.of(context).colorScheme.secondary;
//     final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];

//     // Get attendance distribution data
//     final weekdayDistribution = _getWeekdayDistribution(attendanceProvider);

//     return RefreshIndicator(
//       onRefresh: _fetchAttendanceData,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Attendance overview card with streak visualizations
//               Card(
//                 elevation: 4,
//                 shadowColor: primaryColor.withOpacity(0.3),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Icon(Icons.insights, color: primaryColor, size: 28),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Attendance Overview',
//                             style: Theme.of(context).textTheme.titleLarge,
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),

//                       // Streak information with improved visuals
//                       Row(
//                         children: [
//                           _buildStreakIndicator(
//                             title: 'Current Streak',
//                             value: currentStreak,
//                             icon: Icons.local_fire_department,
//                             color: _getStreakColor(currentStreak),
//                           ),
//                           const SizedBox(width: 20),
//                           _buildStreakIndicator(
//                             title: 'Longest Streak',
//                             value: longestStreak,
//                             icon: Icons.emoji_events,
//                             color: Colors.amber,
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 24),

//                       // 30-day attendance rate with improved visualization
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             '30-Day Attendance Rate',
//                             style: Theme.of(context).textTheme.titleMedium,
//                           ),
//                           const SizedBox(height: 8),
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: Stack(
//                                   children: [
//                                     Container(
//                                       height: 24,
//                                       decoration: BoxDecoration(
//                                         color: backgroundColor,
//                                         borderRadius: BorderRadius.circular(12),
//                                       ),
//                                     ),
//                                     FractionallySizedBox(
//                                       widthFactor:
//                                           stats['attendanceRate'] as double,
//                                       child: Container(
//                                         height: 24,
//                                         decoration: BoxDecoration(
//                                           color: _getAttendanceRateColor(
//                                               stats['attendanceRate']
//                                                   as double),
//                                           borderRadius:
//                                               BorderRadius.circular(12),
//                                         ),
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Text(
//                                 '${((stats['attendanceRate'] as double) * 100).toStringAsFixed(1)}%',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 18,
//                                   color: _getAttendanceRateColor(
//                                       stats['attendanceRate'] as double),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 8),
//                           _getRateAssessmentText(
//                               stats['attendanceRate'] as double),
//                         ],
//                       ),

//                       const SizedBox(height: 20),

//                       // Total check-ins visualization
//                       Row(
//                         children: [
//                           Icon(Icons.check_circle, color: secondaryColor),
//                           const SizedBox(width: 8),
//                           Text(
//                             'Total Check-ins:',
//                             style: Theme.of(context).textTheme.titleSmall,
//                           ),
//                           const Spacer(),
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 8),
//                             decoration: BoxDecoration(
//                               color: secondaryColor.withOpacity(0.2),
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             child: Text(
//                               '${attendanceProvider.totalAttendance}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: secondaryColor,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 24),

//               // Enhanced weekly attendance chart
//               _buildEnhancedWeeklyChart(attendanceProvider, isDarkMode),

//               const SizedBox(height: 24),

//               // Attendance day distribution by weekday
//               _buildWeekdayDistributionChart(weekdayDistribution, isDarkMode),

//               const SizedBox(height: 24),

//               // Enhanced monthly attendance chart
//               _buildEnhancedMonthlyChart(attendanceProvider, isDarkMode),

//               const SizedBox(height: 24),

//               // Date range picker with improved UI
//               _buildEnhancedDateRangePicker(isDarkMode),

//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildStreakIndicator({
//     required String title,
//     required int value,
//     required IconData icon,
//     required Color color,
//   }) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16),
//         decoration: BoxDecoration(
//           color: color.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Icon(icon, color: color, size: 32),
//             const SizedBox(height: 8),
//             Text(
//               '$value',
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: color,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               title,
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getStreakColor(int streak) {
//     if (streak >= 30) return Colors.deepPurple;
//     if (streak >= 14) return Colors.deepOrange;
//     if (streak >= 7) return Colors.orange;
//     return Colors.blue;
//   }

//   Color _getAttendanceRateColor(double rate) {
//     if (rate >= 0.8) return Colors.green;
//     if (rate >= 0.6) return Colors.amber;
//     if (rate >= 0.4) return Colors.orange;
//     return Colors.red;
//   }

//   Widget _getRateAssessmentText(double rate) {
//     String text;
//     Color color;

//     if (rate >= 0.9) {
//       text = "🎯 Excellent! You're a fitness champion!";
//       color = Colors.green;
//     } else if (rate >= 0.8) {
//       text = '🔥 Great job staying consistent!';
//       color = Colors.green;
//     } else if (rate >= 0.6) {
//       text = '👍 Good effort! Keep pushing yourself!';
//       color = Colors.amber;
//     } else if (rate >= 0.4) {
//       text = "🏋️ You're making progress. Let's step it up!";
//       color = Colors.orange;
//     } else {
//       text = '💪 Every visit counts. Set a goal to visit more often!';
//       color = Colors.red;
//     }

//     return Text(
//       text,
//       style: TextStyle(
//         color: color,
//         fontStyle: FontStyle.italic,
//       ),
//     );
//   }

//   Widget _buildEnhancedWeeklyChart(
//       AttendanceProvider attendanceProvider, bool isDarkMode) {
//     final today = DateTime.now();
//     final weekData = <String, bool>{};
//     final weekLabels = <String>[];

//     // Create data for the past 7 days
//     for (int i = 6; i >= 0; i--) {
//       final day = today.subtract(Duration(days: i));
//       final dateKey = DateTime(day.year, day.month, day.day);
//       final dayLabel = DateFormat('E').format(day);
//       weekData[dayLabel] =
//           attendanceProvider.attendanceDays.containsKey(dateKey);
//       weekLabels.add(dayLabel);
//     }

//     return Card(
//       elevation: 4,
//       shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.date_range,
//                     color: Theme.of(context).colorScheme.primary),
//                 const SizedBox(width: 8),
//                 Text(
//                   'This Week\'s Attendance',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               '${DateFormat('MMMM d').format(today.subtract(const Duration(days: 6)))} - ${DateFormat('MMMM d').format(today)}',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 12,
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               height: 220,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: 1,
//                   minY: 0,
//                   barTouchData: BarTouchData(
//                     enabled: true,
//                     touchTooltipData: BarTouchTooltipData(
//                       // tooltipBgColor: isDarkMode ? Colors.grey[800]! : Colors.white,
//                       getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                         return BarTooltipItem(
//                           weekData.values.elementAt(groupIndex)
//                               ? 'Present'
//                               : 'Absent',
//                           TextStyle(
//                             color: weekData.values.elementAt(groupIndex)
//                                 ? Colors.green
//                                 : Colors.red,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           if (value < 0 || value >= weekLabels.length) {
//                             return const SizedBox();
//                           }

//                           // Highlight today
//                           final isToday = value == weekLabels.length - 1;

//                           return Padding(
//                             padding: const EdgeInsets.only(top: 10.0),
//                             child: Text(
//                               weekLabels[value.toInt()],
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: isToday
//                                     ? FontWeight.bold
//                                     : FontWeight.normal,
//                                 color: isToday
//                                     ? Theme.of(context).colorScheme.primary
//                                     : isDarkMode
//                                         ? Colors.white70
//                                         : Colors.black87,
//                               ),
//                             ),
//                           );
//                         },
//                         reservedSize: 30,
//                       ),
//                     ),
//                     leftTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   gridData: FlGridData(
//                     show: true,
//                     horizontalInterval: 0.5,
//                     getDrawingHorizontalLine: (value) => FlLine(
//                       color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
//                       strokeWidth: 1,
//                       dashArray: [5, 5],
//                     ),
//                     drawVerticalLine: false,
//                   ),
//                   borderData: FlBorderData(show: false),
//                   barGroups: List.generate(
//                     weekData.length,
//                     (index) => BarChartGroupData(
//                       x: index,
//                       barRods: [
//                         BarChartRodData(
//                           toY: weekData.values.elementAt(index) ? 1 : 0,
//                           color: weekData.values.elementAt(index)
//                               ? Colors.green.withOpacity(0.8)
//                               : Colors.red.withOpacity(0.6),
//                           width: 20,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(4),
//                             topRight: Radius.circular(4),
//                           ),
//                           backDrawRodData: BackgroundBarChartRodData(
//                             show: true,
//                             toY: 1,
//                             color: isDarkMode
//                                 ? Colors.grey[800]
//                                 : Colors.grey[200],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 16,
//                   height: 16,
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.8),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Text('Present'),
//                 const SizedBox(width: 24),
//                 Container(
//                   width: 16,
//                   height: 16,
//                   decoration: BoxDecoration(
//                     color: Colors.red.withOpacity(0.6),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 4),
//                 const Text('Absent'),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Get weekday distribution data
//   Map<String, int> _getWeekdayDistribution(
//       AttendanceProvider attendanceProvider) {
//     final Map<String, int> distribution = {
//       'Mon': 0,
//       'Tue': 0,
//       'Wed': 0,
//       'Thu': 0,
//       'Fri': 0,
//       'Sat': 0,
//       'Sun': 0,
//     };

//     // Count attendance per weekday
//     for (final dateTime in attendanceProvider.attendanceDays.keys) {
//       final weekday = DateFormat('E').format(dateTime);
//       switch (weekday) {
//         case 'Mon':
//           distribution['Mon'] = (distribution['Mon'] ?? 0) + 1;
//           break;
//         case 'Tue':
//           distribution['Tue'] = (distribution['Tue'] ?? 0) + 1;
//           break;
//         case 'Wed':
//           distribution['Wed'] = (distribution['Wed'] ?? 0) + 1;
//           break;
//         case 'Thu':
//           distribution['Thu'] = (distribution['Thu'] ?? 0) + 1;
//           break;
//         case 'Fri':
//           distribution['Fri'] = (distribution['Fri'] ?? 0) + 1;
//           break;
//         case 'Sat':
//           distribution['Sat'] = (distribution['Sat'] ?? 0) + 1;
//           break;
//         case 'Sun':
//           distribution['Sun'] = (distribution['Sun'] ?? 0) + 1;
//           break;
//       }
//     }

//     return distribution;
//   }

//   // Weekday distribution chart
//   Widget _buildWeekdayDistributionChart(
//       Map<String, int> distribution, bool isDarkMode) {
//     // Find max value for scaling
//     final maxValue = distribution.values.isEmpty
//         ? 1
//         : distribution.values.reduce((a, b) => a > b ? a : b);

//     return Card(
//       elevation: 4,
//       shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.calendar_view_week,
//                     color: Theme.of(context).colorScheme.primary),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Workout Pattern',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             const Text(
//               'Your most frequent gym days',
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontSize: 12,
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               height: 200,
//               child: BarChart(
//                 BarChartData(
//                   alignment: BarChartAlignment.spaceAround,
//                   maxY: maxValue + (maxValue * 0.2), // Add 20% padding
//                   barTouchData: BarTouchData(
//                     enabled: true,
//                     touchTooltipData: BarTouchTooltipData(
//                       // tooltipBgColor: isDarkMode ? Colors.grey[800]! : Colors.white,
//                       getTooltipItem: (group, groupIndex, rod, rodIndex) {
//                         final day = distribution.keys.elementAt(groupIndex);
//                         final count = distribution.values.elementAt(groupIndex);
//                         return BarTooltipItem(
//                           '$day: $count visits',
//                           TextStyle(
//                             color: Theme.of(context).colorScheme.primary,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           if (value < 0 || value >= distribution.length) {
//                             return const SizedBox();
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               distribution.keys.elementAt(value.toInt()),
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           if (value % 1 != 0)
//                             return const SizedBox(); // Only show whole numbers
//                           return Text(
//                             value.toInt().toString(),
//                             style: TextStyle(
//                               color: isDarkMode
//                                   ? Colors.white70
//                                   : Colors.grey[700],
//                               fontSize: 10,
//                             ),
//                           );
//                         },
//                         reservedSize: 30,
//                       ),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   gridData: FlGridData(
//                     show: true,
//                     getDrawingHorizontalLine: (value) => FlLine(
//                       color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
//                       strokeWidth: 1,
//                       dashArray: [5, 5],
//                     ),
//                     drawVerticalLine: false,
//                   ),
//                   borderData: FlBorderData(show: false),
//                   barGroups: List.generate(
//                     distribution.length,
//                     (index) => BarChartGroupData(
//                       x: index,
//                       barRods: [
//                         BarChartRodData(
//                           toY: distribution.values.elementAt(index).toDouble(),
//                           color: _getBarColor(index,
//                               distribution.values.elementAt(index), maxValue),
//                           width: 20,
//                           borderRadius: const BorderRadius.only(
//                             topLeft: Radius.circular(4),
//                             topRight: Radius.circular(4),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Insights about workout pattern
//             _buildWorkoutPatternInsights(distribution),
//           ],
//         ),
//       ),
//     );
//   }

//   Color _getBarColor(int index, int value, int maxValue) {
//     // Special color for weekends
//     if (index == 5 || index == 6) {
//       return value > 0
//           ? Theme.of(context).colorScheme.secondary
//           : Theme.of(context).colorScheme.secondary.withOpacity(0.3);
//     }

//     // Color gradient based on frequency
//     if (value == maxValue && value > 0) {
//       return Colors.green; // Most frequent day
//     } else if (value >= maxValue * 0.7) {
//       return Colors.teal;
//     } else if (value >= maxValue * 0.4) {
//       return Colors.blue;
//     } else if (value > 0) {
//       return Colors.lightBlue;
//     } else {
//       return Colors.grey.withOpacity(0.3); // No visits
//     }
//   }

//   Widget _buildWorkoutPatternInsights(Map<String, int> distribution) {
//     // Find the most frequent day
//     int maxCount = 0;
//     String maxDay = '';

//     distribution.forEach((day, count) {
//       if (count > maxCount) {
//         maxCount = count;
//         maxDay = day;
//       }
//     });

//     // Check weekend vs weekday pattern
//     final weekdayCount = (distribution['Mon'] ?? 0) +
//         (distribution['Tue'] ?? 0) +
//         (distribution['Wed'] ?? 0) +
//         (distribution['Thu'] ?? 0) +
//         (distribution['Fri'] ?? 0);

//     final weekendCount =
//         (distribution['Sat'] ?? 0) + (distribution['Sun'] ?? 0);

//     String patternInsight;
//     if (maxCount == 0) {
//       patternInsight = "Not enough data to identify your workout pattern yet.";
//     } else if (weekdayCount > weekendCount * 2) {
//       patternInsight =
//           "You tend to work out on weekdays much more than weekends.";
//     } else if (weekendCount > weekdayCount) {
//       patternInsight = "You prefer weekend workouts over weekday sessions.";
//     } else {
//       patternInsight = "Your most consistent workout day is $maxDay.";
//     }

//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(
//             Icons.lightbulb_outline,
//             color: Theme.of(context).colorScheme.primary,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               patternInsight,
//               style: TextStyle(
//                 fontStyle: FontStyle.italic,
//                 color: Theme.of(context).brightness == Brightness.dark
//                     ? Colors.white70
//                     : Colors.black87,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnhancedMonthlyChart(
//       AttendanceProvider attendanceProvider, bool isDarkMode) {
//     final now = DateTime.now();
//     final monthlyData = <String, double>{};
//     final attendanceCounts = <String, int>{};
//     final totalDaysPerMonth = <String, int>{};

//     // Generate data for the past 6 months
//     for (int i = 5; i >= 0; i--) {
//       final month = DateTime(now.year, now.month - i, 1);
//       final monthName = DateFormat('MMM').format(month);
//       final rate = attendanceProvider.getMonthAttendanceRate(month);
//       monthlyData[monthName] = rate;

//       // Calculate days present and total days
//       final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
//       int daysPresent = 0;

//       for (int day = 1; day <= daysInMonth; day++) {
//         final date = DateTime(month.year, month.month, day);
//         if (attendanceProvider.attendanceDays.containsKey(date)) {
//           daysPresent++;
//         }
//       }

//       attendanceCounts[monthName] = daysPresent;
//       totalDaysPerMonth[monthName] = daysInMonth;
//     }

//     return Card(
//       elevation: 4,
//       shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.insert_chart,
//                     color: Theme.of(context).colorScheme.primary),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Monthly Attendance Rate',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Your consistency over the last 6 months',
//               style: TextStyle(
//                 color: Colors.grey[600],
//                 fontSize: 12,
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               height: 250,
//               child: LineChart(
//                 LineChartData(
//                   lineTouchData: LineTouchData(
//                     touchTooltipData: LineTouchTooltipData(
//                       // tooltipBgColor: isDarkMode ? Colors.grey[800]! : Colors.white,
//                       //TODO: WHAT?
//                       getTooltipColor: (spot) =>
//                           Theme.of(context).colorScheme.primary,
//                       getTooltipItems: (touchedSpots) {
//                         return touchedSpots.map((spot) {
//                           final month =
//                               monthlyData.keys.elementAt(spot.x.toInt());
//                           final present = attendanceCounts[month] ?? 0;
//                           final total = totalDaysPerMonth[month] ?? 30;
//                           return LineTooltipItem(
//                             '$month: ${(spot.y * 100).toStringAsFixed(1)}%\n$present / $total days',
//                             TextStyle(
//                               color: Theme.of(context).colorScheme.primary,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           );
//                         }).toList();
//                       },
//                     ),
//                   ),
//                   gridData: FlGridData(
//                     show: true,
//                     drawVerticalLine: false,
//                     horizontalInterval: 0.2,
//                     getDrawingHorizontalLine: (value) => FlLine(
//                       color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
//                       strokeWidth: 1,
//                       dashArray: [5, 5],
//                     ),
//                   ),
//                   titlesData: FlTitlesData(
//                     show: true,
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           if (value < 0 || value >= monthlyData.length) {
//                             return const SizedBox();
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.only(top: 8.0),
//                             child: Text(
//                               monthlyData.keys.elementAt(value.toInt()),
//                               style: const TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                     leftTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           return Text('${(value * 100).toInt()}%');
//                         },
//                         reservedSize: 35,
//                       ),
//                     ),
//                     topTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                     rightTitles: const AxisTitles(
//                       sideTitles: SideTitles(showTitles: false),
//                     ),
//                   ),
//                   borderData: FlBorderData(show: false),
//                   minX: 0,
//                   maxX: monthlyData.length - 1.0,
//                   minY: 0,
//                   maxY: 1,
//                   lineBarsData: [
//                     LineChartBarData(
//                       spots: List.generate(
//                         monthlyData.length,
//                         (index) => FlSpot(
//                           index.toDouble(),
//                           monthlyData.values.elementAt(index),
//                         ),
//                       ),
//                       isCurved: true,
//                       color: Theme.of(context).colorScheme.primary,
//                       barWidth: 4,
//                       isStrokeCapRound: true,
//                       dotData: FlDotData(
//                         show: true,
//                         getDotPainter: (spot, percent, barData, index) =>
//                             FlDotCirclePainter(
//                           radius: 6,
//                           color: Theme.of(context).colorScheme.primary,
//                           strokeWidth: 2,
//                           strokeColor: isDarkMode ? Colors.black : Colors.white,
//                         ),
//                       ),
//                       belowBarData: BarAreaData(
//                         show: true,
//                         color: Theme.of(context)
//                             .colorScheme
//                             .primary
//                             .withOpacity(0.15),
//                         gradient: LinearGradient(
//                           colors: [
//                             Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(0.3),
//                             Theme.of(context)
//                                 .colorScheme
//                                 .primary
//                                 .withOpacity(0.05),
//                           ],
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Monthly trend analysis
//             _buildMonthlyTrendAnalysis(monthlyData),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMonthlyTrendAnalysis(Map<String, double> monthlyData) {
//     // Calculate trend
//     double trend = 0;
//     if (monthlyData.length >= 2) {
//       final values = monthlyData.values.toList();
//       final latestMonth = values.last;
//       final previousMonth = values[values.length - 2];
//       trend = latestMonth - previousMonth;
//     }

//     // Get month names
//     final latestMonthName =
//         monthlyData.keys.isNotEmpty ? monthlyData.keys.last : '';

//     // Determine icon and text
//     IconData icon;
//     String trendText;
//     Color trendColor;

//     if (trend > 0.1) {
//       icon = Icons.trending_up;
//       trendText = "Great improvement! You're going to the gym more frequently.";
//       trendColor = Colors.green;
//     } else if (trend > 0) {
//       icon = Icons.trending_up;
//       trendText = "Slight improvement in your gym attendance. Keep it up!";
//       trendColor = Colors.green;
//     } else if (trend == 0) {
//       icon = Icons.trending_flat;
//       trendText = "Your gym attendance is steady. Consistency is key!";
//       trendColor = Colors.blue;
//     } else if (trend > -0.1) {
//       icon = Icons.trending_down;
//       trendText = "Slight decrease in gym visits. Try to stay consistent!";
//       trendColor = Colors.orange;
//     } else {
//       icon = Icons.trending_down;
//       trendText = "Your gym attendance has decreased. Let's get back on track!";
//       trendColor = Colors.red;
//     }

//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: trendColor.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: trendColor),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '$latestMonthName Trend: ${(trend * 100).abs().toStringAsFixed(1)}%',
//                   style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: trendColor,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   trendText,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Theme.of(context).brightness == Brightness.dark
//                         ? Colors.white70
//                         : Colors.black87,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnhancedDateRangePicker(bool isDarkMode) {
//     return Card(
//       elevation: 4,
//       shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Icon(Icons.date_range,
//                     color: Theme.of(context).colorScheme.primary),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Custom Date Range',
//                   style: Theme.of(context).textTheme.titleMedium,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               children: [
//                 Expanded(
//                   child: InkWell(
//                     onTap: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: _rangeStart,
//                         firstDate: DateTime(2020),
//                         lastDate: DateTime.now(),
//                         builder: (context, child) {
//                           return Theme(
//                             data: Theme.of(context).copyWith(
//                               colorScheme: ColorScheme.light(
//                                 primary: Theme.of(context).colorScheme.primary,
//                                 onPrimary: Colors.white,
//                                 surface: isDarkMode
//                                     ? Colors.grey[800]!
//                                     : Colors.white,
//                                 onSurface:
//                                     isDarkMode ? Colors.white : Colors.black,
//                               ),
//                             ),
//                             child: child!,
//                           );
//                         },
//                       );
//                       if (picked != null && picked != _rangeStart) {
//                         setState(() {
//                           _rangeStart = picked;
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[400]!),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_today,
//                             size: 18,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             DateFormat('MMM d, yyyy').format(_rangeStart),
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: isDarkMode ? Colors.white : Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Text(
//                     'to',
//                     style: TextStyle(
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: InkWell(
//                     onTap: () async {
//                       final picked = await showDatePicker(
//                         context: context,
//                         initialDate: _rangeEnd,
//                         firstDate: _rangeStart,
//                         lastDate: DateTime.now(),
//                         builder: (context, child) {
//                           return Theme(
//                             data: Theme.of(context).copyWith(
//                               colorScheme: ColorScheme.light(
//                                 primary: Theme.of(context).colorScheme.primary,
//                                 onPrimary: Colors.white,
//                                 surface: isDarkMode
//                                     ? Colors.grey[800]!
//                                     : Colors.white,
//                                 onSurface:
//                                     isDarkMode ? Colors.white : Colors.black,
//                               ),
//                             ),
//                             child: child!,
//                           );
//                         },
//                       );
//                       if (picked != null && picked != _rangeEnd) {
//                         setState(() {
//                           _rangeEnd = picked;
//                         });
//                       }
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 12),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey[400]!),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_today,
//                             size: 18,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             DateFormat('MMM d, yyyy').format(_rangeEnd),
//                             style: TextStyle(
//                               fontWeight: FontWeight.w500,
//                               color: isDarkMode ? Colors.white : Colors.black87,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Quick date range selections
//             SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: [
//                   _buildQuickDateRangeButton('Last 7 days', 7),
//                   _buildQuickDateRangeButton('Last 30 days', 30),
//                   _buildQuickDateRangeButton('Last 3 months', 90),
//                   _buildQuickDateRangeButton('Last 6 months', 180),
//                   _buildQuickDateRangeButton('This year', 365),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   final userId =
//                       Provider.of<AuthProvider>(context, listen: false).userId;
//                   if (userId != null) {
//                     Provider.of<AttendanceProvider>(context, listen: false)
//                         .fetchAttendanceHistory(int.parse(userId),
//                             startDate: _rangeStart, endDate: _rangeEnd);

//                     // Provide feedback
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           'Date range updated: ${DateFormat('MMM d').format(_rangeStart)} - ${DateFormat('MMM d').format(_rangeEnd)}',
//                         ),
//                         behavior: SnackBarBehavior.floating,
//                         backgroundColor: Theme.of(context).colorScheme.primary,
//                       ),
//                     );
//                   }
//                 },
//                 icon: const Icon(Icons.refresh),
//                 label: const Text('Apply Date Range'),
//                 style: ElevatedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildQuickDateRangeButton(String label, int days) {
//     final now = DateTime.now();

//     return Padding(
//       padding: const EdgeInsets.only(right: 8.0),
//       child: OutlinedButton(
//         onPressed: () {
//           setState(() {
//             _rangeEnd = now;
//             _rangeStart = now.subtract(Duration(days: days));
//           });
//         },
//         style: OutlinedButton.styleFrom(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           side: BorderSide(
//             color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
//           ),
//         ),
//         child: Text(label),
//       ),
//     );
//   }

//   Widget _buildHistoryTab(
//       AttendanceProvider attendanceProvider, bool isDarkMode) {
//     final attendanceHistory = attendanceProvider.attendanceHistory;

//     if (attendanceHistory.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.calendar_today_outlined,
//               size: 80,
//               color: Colors.grey[400],
//             ),
//             const SizedBox(height: 16),
//             Text(
//               'No attendance records found',
//               style: Theme.of(context).textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Try selecting a different date range',
//               style: TextStyle(color: Colors.grey[600]),
//             ),
//             const SizedBox(height: 24),
//             ElevatedButton.icon(
//               onPressed: () {
//                 _tabController.animateTo(1); // Switch to Stats tab
//               },
//               icon: const Icon(Icons.date_range),
//               label: const Text('Change Date Range'),
//               style: ElevatedButton.styleFrom(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ],
//         ),
//       );
//     }

//     // Group by month for section headers
//     final Map<String, List<dynamic>> groupedData = {};

//     for (final attendance in attendanceHistory) {
//       final monthYear =
//           DateFormat('MMMM yyyy').format(attendance.attendanceDate);

//       if (!groupedData.containsKey(monthYear)) {
//         groupedData[monthYear] = [];
//       }

//       groupedData[monthYear]!.add(attendance);
//     }

//     // Convert to list sorted by date (newest first)
//     final groupedEntries = groupedData.entries.toList()
//       ..sort((a, b) {
//         final aDate = a.value[0].attendanceDate;
//         final bDate = b.value[0].attendanceDate;
//         return bDate.compareTo(aDate);
//       });

//     return RefreshIndicator(
//       onRefresh: _fetchAttendanceData,
//       child: CustomScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         slivers: [
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: _buildHistoryHeaderCard(attendanceHistory.length),
//             ),
//           ),
//           ...groupedEntries.map((entry) {
//             final monthYear = entry.key;
//             final attendances = entry.value;

//             return SliverList(
//               delegate: SliverChildBuilderDelegate(
//                 (context, index) {
//                   if (index == 0) {
//                     // Month header
//                     return Padding(
//                       padding: const EdgeInsets.only(
//                         left: 16.0,
//                         right: 16.0,
//                         top: 16.0,
//                         bottom: 8.0,
//                       ),
//                       child: Row(
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Theme.of(context).colorScheme.primary,
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             child: Text(
//                               monthYear,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Divider(
//                               color: Theme.of(context)
//                                   .colorScheme
//                                   .primary
//                                   .withOpacity(0.5),
//                               thickness: 1,
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             '${attendances.length} visits',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 12,
//                             ),
//                           ),
//                         ],
//                       ),
//                     );
//                   }

//                   // Attendance entry
//                   final attendance = attendances[index - 1];
//                   return _buildAttendanceHistoryCard(attendance, isDarkMode);
//                 },
//                 childCount: attendances.length + 1, // +1 for the header
//               ),
//             );
//           }),
//           // Add some bottom padding
//           const SliverToBoxAdapter(
//             child: SizedBox(height: 40),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHistoryHeaderCard(int totalEntries) {
//     return Card(
//       elevation: 4,
//       shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Attendance History',
//                       style: Theme.of(context).textTheme.titleLarge,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       'Your gym check-ins over time',
//                       style: TextStyle(
//                         color: Colors.grey[600],
//                         fontSize: 12,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color:
//                         Theme.of(context).colorScheme.primary.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(
//                         Icons.check_circle,
//                         color: Theme.of(context).colorScheme.primary,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         '$totalEntries check-ins',
//                         style: TextStyle(
//                           color: Theme.of(context).colorScheme.primary,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: 'Search history...',
//                 prefixIcon: const Icon(Icons.search),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey.withOpacity(0.1),
//                 contentPadding: const EdgeInsets.symmetric(vertical: 0),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAttendanceHistoryCard(dynamic attendance, bool isDarkMode) {
//     final attendanceDate = attendance.attendanceDate;
//     final formattedDate = DateFormat('EEEE, MMM d').format(attendanceDate);
//     final formattedTime = DateFormat('hh:mm a').format(attendanceDate);

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
//       child: Card(
//         elevation: 2,
//         shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: ListTile(
//           contentPadding:
//               const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//           leading: Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: Icon(
//                 Icons.fitness_center,
//                 color: Theme.of(context).colorScheme.primary,
//               ),
//             ),
//           ),
//           title: Text(
//             formattedDate,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 4),
//               Text(
//                 attendance.userInfo.fullName,
//                 style: TextStyle(
//                   fontSize: 13,
//                   color: isDarkMode ? Colors.white70 : Colors.black87,
//                 ),
//               ),
//               // If gym location is available
//               if (attendance.gymId != null)
//                 Row(
//                   children: [
//                     Icon(
//                       Icons.location_on,
//                       size: 12,
//                       color: Colors.grey[600],
//                     ),
//                     const SizedBox(width: 4),
//                     Text(
//                       'Gym #${attendance.gymId}',
//                       style: TextStyle(
//                         fontSize: 12,
//                         color: Colors.grey[600],
//                       ),
//                     ),
//                   ],
//                 ),
//             ],
//           ),
//           trailing: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Text(
//               formattedTime,
//               style: TextStyle(
//                 color: Theme.of(context).colorScheme.secondary,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymify/providers/attendance_provider/attendance_provider.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';

class AttendanceCalendarScreen extends StatefulWidget {
  const AttendanceCalendarScreen({super.key});

  @override
  State<AttendanceCalendarScreen> createState() =>
      _AttendanceCalendarScreenState();
}

class _AttendanceCalendarScreenState extends State<AttendanceCalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime _currentMonth = DateTime.now();

  // For date range selection
  DateTime _rangeStart = DateTime.now().subtract(const Duration(days: 30));
  DateTime _rangeEnd = DateTime.now();

  // For animations
  bool _showHeatmap = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDay = _focusedDay; // Initialize selected day to today

    // Get tab index from route arguments if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is int && args >= 0 && args < 3) {
        _tabController.index = args;
      }

      _fetchAttendanceData();

      // Animate heatmap in after data loads
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _showHeatmap = true;
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAttendanceData() async {
    final userId = Provider.of<AuthProvider>(context, listen: false).userId;
    if (userId != null) {
      await Provider.of<AttendanceProvider>(context, listen: false)
          .fetchAttendanceHistory(int.parse(userId),
              startDate: _rangeStart, endDate: _rangeEnd);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance Tracker'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          indicatorWeight: 3,
          labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          tabs: const [
            Tab(text: 'Calendar'),
            Tab(text: 'Stats'),
            Tab(text: 'History'),
          ],
        ),
      ),
      body: Consumer<AttendanceProvider>(
        builder: (context, attendanceProvider, child) {
          if (attendanceProvider.isLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Use a fitness themed loading animation
                  Lottie.network(
                    'https://assets4.lottiefiles.com/packages/lf20_bXRG9q.json',
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Loading your fitness data...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          if (attendanceProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: size.width * 0.2,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading attendance data',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    attendanceProvider.errorMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _fetchAttendanceData,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildCalendarTab(attendanceProvider, isDarkMode, size),
              _buildStatsTab(attendanceProvider, isDarkMode, size),
              _buildHistoryTab(attendanceProvider, isDarkMode, size),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCalendarTab(
      AttendanceProvider attendanceProvider, bool isDarkMode, Size size) {
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    int presentDays = 0;

    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      if (attendanceProvider.attendanceDays.containsKey(date)) {
        presentDays++;
      }
    }

    return RefreshIndicator(
      onRefresh: _fetchAttendanceData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Monthly progress card
              Card(
                elevation: 4,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month,
                            color: Theme.of(context).colorScheme.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat('MMMM yyyy').format(_currentMonth),
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Progress circles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildProgressCircle(
                            title: 'Days Present',
                            value: presentDays,
                            maxValue: daysInMonth,
                            color: Theme.of(context).colorScheme.primary,
                            icon: Icons.check_circle,
                            size: size,
                          ),
                          _buildProgressCircle(
                            title: 'Month Progress',
                            value: DateTime.now().day <= daysInMonth
                                ? DateTime.now().day
                                : daysInMonth,
                            maxValue: daysInMonth,
                            color: Colors.amber,
                            icon: Icons.calendar_today,
                            size: size,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Calendar widget
              Card(
                elevation: 4,
                shadowColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.now(),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month',
                      CalendarFormat.twoWeeks: '2 Weeks',
                      CalendarFormat.week: 'Week',
                    },
                    // Use calendarBuilders for custom day containers
                    calendarBuilders: CalendarBuilders(
                      // Custom day cell builder to show attendance with background color
                      defaultBuilder: (context, day, focusedDay) {
                        // Check if there's attendance on this day
                        bool hasAttendance =
                            attendanceProvider.attendanceDays.containsKey(
                          DateTime(day.year, day.month, day.day),
                        );

                        // Create a customized day cell with colored background for attendance days
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: hasAttendance
                              ? BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primary
                                      .withOpacity(0.3),
                                  shape: BoxShape.circle,
                                )
                              : null,
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: hasAttendance
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  : null,
                            ),
                          ),
                        );
                      },
                      // Custom builder for selected day to ensure it looks different from attendance days
                      selectedBuilder: (context, day, focusedDay) {
                        bool hasAttendance =
                            attendanceProvider.attendanceDays.containsKey(
                          DateTime(day.year, day.month, day.day),
                        );

                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            // color: Theme.of(context).primaryColor,
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${day.day}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                      // Custom builder for today to differentiate it from normal days
                      todayBuilder: (context, day, focusedDay) {
                        bool hasAttendance =
                            attendanceProvider.attendanceDays.containsKey(
                          DateTime(day.year, day.month, day.day),
                        );

                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: hasAttendance
                                ? Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(
                                        0.5) // Darker if has attendance
                                : Theme.of(context).primaryColor.withOpacity(
                                    0.2), // Light highlight if today

                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: hasAttendance
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  : null,
                            ),
                          ),
                        );
                      },
                      // Custom builder for weekend days to maintain weekend styling
                      outsideBuilder: (context, day, focusedDay) {
                        return Container(
                          margin: const EdgeInsets.all(4.0),
                          alignment: Alignment.center,
                          child: Text(
                            '${day.day}',
                            style: TextStyle(
                              color: Colors.grey[400],
                            ),
                          ),
                        );
                      },
                      // Builders for weekend days that fall in the current month
                      dowBuilder: (context, day) {
                        final weekday = DateFormat.E().format(day);
                        final isWeekend = weekday == 'Sun' || weekday == 'Sat';

                        return Center(
                          child: Text(
                            weekday,
                            style: TextStyle(
                              color: isWeekend
                                  ? (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.red[200]
                                      : Colors.red)
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    ),
                    // You can remove the eventLoader since we're using the custom builders
                    onDaySelected: (selectedDay, focusedDay) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                      setState(() {
                        _currentMonth = focusedDay;
                      });
                    },
                    headerStyle: HeaderStyle(
                      titleCentered: true,
                      formatButtonDecoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      formatButtonTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    // These styles will be overridden by the custom builders
                    calendarStyle: const CalendarStyle(
                      outsideDaysVisible: false,
                    ),
                  ),
                  // child: TableCalendar(
                  //   firstDay: DateTime.utc(2020, 1, 1),
                  //   lastDay: DateTime.now(),
                  //   focusedDay: _focusedDay,
                  //   calendarFormat: _calendarFormat,
                  //   selectedDayPredicate: (day) {
                  //     return isSameDay(_selectedDay, day);
                  //   },
                  //   availableCalendarFormats: const {
                  //     CalendarFormat.month: 'Month',
                  //     CalendarFormat.twoWeeks: '2 Weeks',
                  //     CalendarFormat.week: 'Week',
                  //   },
                  //   calendarBuilders: CalendarBuilders(
                  //     markerBuilder: (context, date, events) {
                  //       if (events.isNotEmpty) {
                  //         // Create filled circle instead of dot
                  //         return Positioned(
                  //           bottom: 1,
                  //           right: 1,
                  //           left: 1,
                  //           child: Container(
                  //             height: 6,
                  //             width: 6,
                  //             decoration: BoxDecoration(
                  //               shape: BoxShape.circle,
                  //               color: Theme.of(context).colorScheme.secondary,
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //       return null;
                  //     },
                  //   ),
                  //   eventLoader: (day) {
                  //     // Mark days with attendance records
                  //     if (attendanceProvider.attendanceDays.containsKey(
                  //       DateTime(day.year, day.month, day.day),
                  //     )) {
                  //       return ['present'];
                  //     }
                  //     return [];
                  //   },
                  //   onDaySelected: (selectedDay, focusedDay) {
                  //     HapticFeedback.lightImpact();
                  //     setState(() {
                  //       _selectedDay = selectedDay;
                  //       _focusedDay = focusedDay;
                  //     });
                  //   },
                  //   onFormatChanged: (format) {
                  //     setState(() {
                  //       _calendarFormat = format;
                  //     });
                  //   },
                  //   onPageChanged: (focusedDay) {
                  //     // Update the month when navigating
                  //     _focusedDay = focusedDay;
                  //     setState(() {
                  //       _currentMonth = focusedDay;
                  //     });
                  //   },
                  //   calendarStyle: CalendarStyle(
                  //     // Improved styling
                  //     markersMaxCount: 1,
                  //     markerDecoration: BoxDecoration(
                  //       color: Theme.of(context).colorScheme.secondary,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     markerSize: 8,
                  //     todayDecoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor.withOpacity(0.3),
                  //       shape: BoxShape.circle,
                  //     ),
                  //     selectedDecoration: BoxDecoration(
                  //       color: Theme.of(context).primaryColor,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     // Marker for attendance has a cell with colored background
                  //     markersAnchor: 0.7,
                  //     cellMargin: const EdgeInsets.all(2),
                  //     outsideDaysVisible: false,
                  //     weekendTextStyle: TextStyle(
                  //       color: isDarkMode ? Colors.red[200] : Colors.red,
                  //     ),
                  //   ),
                  //   headerStyle: HeaderStyle(
                  //     titleCentered: true,
                  //     formatButtonDecoration: BoxDecoration(
                  //       color: Theme.of(context)
                  //           .colorScheme
                  //           .secondary
                  //           .withOpacity(0.1),
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     formatButtonTextStyle: TextStyle(
                  //       color: Theme.of(context).colorScheme.secondary,
                  //     ),
                  //     leftChevronIcon: Icon(
                  //       Icons.chevron_left,
                  //       color: Theme.of(context).colorScheme.primary,
                  //     ),
                  //     rightChevronIcon: Icon(
                  //       Icons.chevron_right,
                  //       color: Theme.of(context).colorScheme.primary,
                  //     ),
                  //   ),
                  //   daysOfWeekStyle: DaysOfWeekStyle(
                  //     weekdayStyle: Theme.of(context).textTheme.bodySmall ??
                  //         const TextStyle(),
                  //     weekendStyle: (Theme.of(context).textTheme.bodySmall ??
                  //             const TextStyle())
                  //         .copyWith(
                  //       color: isDarkMode ? Colors.red[200] : Colors.red,
                  //     ),
                  //   ),
                  // ),
                ),
              ),

              const SizedBox(height: 20),

              // Selected day info
              if (_selectedDay != null)
                Card(
                  elevation: 4,
                  shadowColor:
                      Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, MMMM d, yyyy')
                              .format(_selectedDay!),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 24,
                              backgroundColor:
                                  attendanceProvider.attendanceDays.containsKey(
                                DateTime(_selectedDay!.year,
                                    _selectedDay!.month, _selectedDay!.day),
                              )
                                      ? Colors.green.withOpacity(0.2)
                                      : Colors.red.withOpacity(0.2),
                              child: Icon(
                                attendanceProvider.attendanceDays.containsKey(
                                  DateTime(_selectedDay!.year,
                                      _selectedDay!.month, _selectedDay!.day),
                                )
                                    ? Icons.check
                                    : Icons.close,
                                color: attendanceProvider.attendanceDays
                                        .containsKey(
                                  DateTime(_selectedDay!.year,
                                      _selectedDay!.month, _selectedDay!.day),
                                )
                                    ? Colors.green
                                    : Colors.red,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    attendanceProvider.attendanceDays
                                            .containsKey(
                                      DateTime(
                                          _selectedDay!.year,
                                          _selectedDay!.month,
                                          _selectedDay!.day),
                                    )
                                        ? 'Attendance Recorded'
                                        : 'No Attendance',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: attendanceProvider
                                                  .attendanceDays
                                                  .containsKey(
                                            DateTime(
                                                _selectedDay!.year,
                                                _selectedDay!.month,
                                                _selectedDay!.day),
                                          )
                                              ? Colors.green
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    attendanceProvider.attendanceDays
                                            .containsKey(
                                      DateTime(
                                          _selectedDay!.year,
                                          _selectedDay!.month,
                                          _selectedDay!.day),
                                    )
                                        ? 'Checked in for workout'
                                        : isFutureDate(_selectedDay!)
                                            ? 'Future date'
                                            : 'You missed your workout',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  bool isFutureDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final checkDate = DateTime(date.year, date.month, date.day);
    return checkDate.isAfter(today);
  }

  Widget _buildProgressCircle({
    required String title,
    required int value,
    required int maxValue,
    required Color color,
    required IconData icon,
    required Size size,
  }) {
    // Make circle size responsive to screen width
    final circleSize = size.width < 360 ? size.width * 0.22 : 100.0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: circleSize,
              width: circleSize,
              child: CircularProgressIndicator(
                value: maxValue > 0 ? value / maxValue : 0,
                strokeWidth: circleSize * 0.1, // 10% of circle size
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Column(
              children: [
                Icon(icon, color: color),
                const SizedBox(height: 4),
                Text(
                  '$value/$maxValue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildStatsTab(
      AttendanceProvider attendanceProvider, bool isDarkMode, Size size) {
    final stats = attendanceProvider.getAttendanceStats(daysToConsider: 30);
    final currentStreak = stats['currentStreak'] as int;
    final longestStreak = stats['longestStreak'] as int;

    // Define colors based on theme
    final primaryColor = Theme.of(context).colorScheme.primary;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final backgroundColor = isDarkMode ? Colors.grey[800] : Colors.grey[200];

    // Get attendance distribution data
    final weekdayDistribution = _getWeekdayDistribution(attendanceProvider);

    return RefreshIndicator(
      onRefresh: _fetchAttendanceData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Attendance overview card with streak visualizations
              Card(
                elevation: 4,
                shadowColor: primaryColor.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.insights, color: primaryColor, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            'Attendance Overview',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Streak information with improved visuals
                      Row(
                        children: [
                          _buildStreakIndicator(
                            title: 'Current Streak',
                            value: currentStreak,
                            icon: Icons.local_fire_department,
                            color: _getStreakColor(currentStreak),
                            size: size,
                          ),
                          const SizedBox(width: 20),
                          _buildStreakIndicator(
                            title: 'Longest Streak',
                            value: longestStreak,
                            icon: Icons.emoji_events,
                            color: Colors.amber,
                            size: size,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // 30-day attendance rate with improved visualization
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '30-Day Attendance Rate',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: backgroundColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor:
                                          stats['attendanceRate'] as double,
                                      child: Container(
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: _getAttendanceRateColor(
                                              stats['attendanceRate']
                                                  as double),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '${((stats['attendanceRate'] as double) * 100).toStringAsFixed(1)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: _getAttendanceRateColor(
                                      stats['attendanceRate'] as double),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _getRateAssessmentText(
                              stats['attendanceRate'] as double),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Total check-ins visualization
                      Row(
                        children: [
                          Icon(Icons.check_circle, color: secondaryColor),
                          const SizedBox(width: 8),
                          Text(
                            'Total Check-ins:',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: secondaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${attendanceProvider.totalAttendance}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: secondaryColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Enhanced weekly attendance chart
              _buildEnhancedWeeklyChart(attendanceProvider, isDarkMode, size),

              const SizedBox(height: 24),

              // Attendance day distribution by weekday
              _buildWeekdayDistributionChart(
                  weekdayDistribution, isDarkMode, size),

              const SizedBox(height: 24),

              // Enhanced monthly attendance chart
              _buildEnhancedMonthlyChart(attendanceProvider, isDarkMode, size),

              const SizedBox(height: 24),

              // Date range picker with improved UI
              _buildEnhancedDateRangePicker(isDarkMode, size),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStreakIndicator({
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required Size size,
  }) {
    // Adjust padding based on screen size
    final horizontalPadding = size.width < 360 ? 8.0 : 16.0;
    final verticalPadding = size.width < 360 ? 12.0 : 16.0;
    final fontSize = size.width < 360 ? 24.0 : 28.0;

    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              '$value',
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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

  Widget _getRateAssessmentText(double rate) {
    String text;
    Color color;

    if (rate >= 0.9) {
      text = "🎯 Excellent! You're a fitness champion!";
      color = Colors.green;
    } else if (rate >= 0.8) {
      text = '🔥 Great job staying consistent!';
      color = Colors.green;
    } else if (rate >= 0.6) {
      text = '👍 Good effort! Keep pushing yourself!';
      color = Colors.amber;
    } else if (rate >= 0.4) {
      text = "🏋️ You're making progress. Let's step it up!";
      color = Colors.orange;
    } else {
      text = '💪 Every visit counts. Set a goal to visit more often!';
      color = Colors.red;
    }

    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontStyle: FontStyle.italic,
          ),
    );
  }

  Widget _buildEnhancedWeeklyChart(
      AttendanceProvider attendanceProvider, bool isDarkMode, Size size) {
    final today = DateTime.now();
    final weekData = <String, bool>{};
    final weekLabels = <String>[];

    // Create data for the past 7 days
    for (int i = 6; i >= 0; i--) {
      final day = today.subtract(Duration(days: i));
      final dateKey = DateTime(day.year, day.month, day.day);
      final dayLabel = DateFormat('E').format(day);
      weekData[dayLabel] =
          attendanceProvider.attendanceDays.containsKey(dateKey);
      weekLabels.add(dayLabel);
    }

    // Adjust chart height based on screen size
    final chartHeight = size.height < 700 ? 180.0 : 220.0;

    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.date_range,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'This Week\'s Attendance',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${DateFormat('MMMM d').format(today.subtract(const Duration(days: 6)))} - ${DateFormat('MMMM d').format(today)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: chartHeight,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1,
                  minY: 0,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor:
                      //     isDarkMode ? Colors.grey[800]! : Colors.white,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          weekData.values.elementAt(groupIndex)
                              ? 'Present'
                              : 'Absent',
                          TextStyle(
                            color: weekData.values.elementAt(groupIndex)
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= weekLabels.length) {
                            return const SizedBox();
                          }

                          // Highlight today
                          final isToday = value == weekLabels.length - 1;

                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text(
                              weekLabels[value.toInt()],
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: isToday
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: isToday
                                        ? Theme.of(context).colorScheme.primary
                                        : isDarkMode
                                            ? Colors.white70
                                            : Colors.black87,
                                  ),
                            ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 0.5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    weekData.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: weekData.values.elementAt(index) ? 1 : 0,
                          color: weekData.values.elementAt(index)
                              ? Colors.green.withOpacity(0.8)
                              : Colors.red.withOpacity(0.6),
                          width: size.width < 360
                              ? 15
                              : 20, // Responsive bar width
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: 1,
                            color: isDarkMode
                                ? Colors.grey[800]
                                : Colors.grey[200],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text('Present', style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(width: 24),
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.6),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text('Absent', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Get weekday distribution data
  Map<String, int> _getWeekdayDistribution(
      AttendanceProvider attendanceProvider) {
    final Map<String, int> distribution = {
      'Mon': 0,
      'Tue': 0,
      'Wed': 0,
      'Thu': 0,
      'Fri': 0,
      'Sat': 0,
      'Sun': 0,
    };

    // Count attendance per weekday
    for (final dateTime in attendanceProvider.attendanceDays.keys) {
      final weekday = DateFormat('E').format(dateTime);
      distribution[weekday] = (distribution[weekday] ?? 0) + 1;
    }

    return distribution;
  }

  // Weekday distribution chart
  Widget _buildWeekdayDistributionChart(
      Map<String, int> distribution, bool isDarkMode, Size size) {
    // Find max value for scaling
    final maxValue = distribution.values.isEmpty
        ? 1
        : distribution.values.reduce((a, b) => a > b ? a : b);

    // Adjust chart height based on screen size
    final chartHeight = size.height < 700 ? 180.0 : 200.0;

    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_view_week,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Workout Pattern',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Your most frequent gym days',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey,
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: chartHeight,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: maxValue + (maxValue * 0.2), // Add 20% padding
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      // tooltipBgColor:
                      //     isDarkMode ? Colors.grey[800]! : Colors.white,
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final day = distribution.keys.elementAt(groupIndex);
                        final count = distribution.values.elementAt(groupIndex);
                        return BarTooltipItem(
                          '$day: $count visits',
                          TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= distribution.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              distribution.keys.elementAt(value.toInt()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value % 1 != 0)
                            return const SizedBox(); // Only show whole numbers
                          return Text(
                            value.toInt().toString(),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isDarkMode
                                          ? Colors.white70
                                          : Colors.grey[700],
                                    ),
                          );
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(
                    distribution.length,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: distribution.values.elementAt(index).toDouble(),
                          color: _getBarColor(index,
                              distribution.values.elementAt(index), maxValue),
                          width: size.width < 360
                              ? 15
                              : 20, // Responsive bar width
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Insights about workout pattern
            _buildWorkoutPatternInsights(distribution),
          ],
        ),
      ),
    );
  }

  Color _getBarColor(int index, int value, int maxValue) {
    // Special color for weekends
    if (index == 5 || index == 6) {
      return value > 0
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).colorScheme.secondary.withOpacity(0.3);
    }

    // Color gradient based on frequency
    if (value == maxValue && value > 0) {
      return Colors.green; // Most frequent day
    } else if (value >= maxValue * 0.7) {
      return Colors.teal;
    } else if (value >= maxValue * 0.4) {
      return Colors.blue;
    } else if (value > 0) {
      return Colors.lightBlue;
    } else {
      return Colors.grey.withOpacity(0.3); // No visits
    }
  }

  Widget _buildWorkoutPatternInsights(Map<String, int> distribution) {
    // Find the most frequent day
    int maxCount = 0;
    String maxDay = '';

    distribution.forEach((day, count) {
      if (count > maxCount) {
        maxCount = count;
        maxDay = day;
      }
    });

    // Check weekend vs weekday pattern
    final weekdayCount = (distribution['Mon'] ?? 0) +
        (distribution['Tue'] ?? 0) +
        (distribution['Wed'] ?? 0) +
        (distribution['Thu'] ?? 0) +
        (distribution['Fri'] ?? 0);

    final weekendCount =
        (distribution['Sat'] ?? 0) + (distribution['Sun'] ?? 0);

    String patternInsight;
    if (maxCount == 0) {
      patternInsight = "Not enough data to identify your workout pattern yet.";
    } else if (weekdayCount > weekendCount * 2) {
      patternInsight =
          "You tend to work out on weekdays much more than weekends.";
    } else if (weekendCount > weekdayCount) {
      patternInsight = "You prefer weekend workouts over weekday sessions.";
    } else {
      patternInsight = "Your most consistent workout day is $maxDay.";
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.lightbulb_outline,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              patternInsight,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.black87,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedMonthlyChart(
      AttendanceProvider attendanceProvider, bool isDarkMode, Size size) {
    final now = DateTime.now();
    final monthlyData = <String, double>{};
    final attendanceCounts = <String, int>{};
    final totalDaysPerMonth = <String, int>{};

    // Generate data for the past 6 months
    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final monthName = DateFormat('MMM').format(month);
      final rate = attendanceProvider.getMonthAttendanceRate(month);
      monthlyData[monthName] = rate;

      // Calculate days present and total days
      final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
      int daysPresent = 0;

      for (int day = 1; day <= daysInMonth; day++) {
        final date = DateTime(month.year, month.month, day);
        if (attendanceProvider.attendanceDays.containsKey(date)) {
          daysPresent++;
        }
      }

      attendanceCounts[monthName] = daysPresent;
      totalDaysPerMonth[monthName] = daysInMonth;
    }

    // Adjust chart height based on screen size
    final chartHeight = size.height < 700 ? 200.0 : 250.0;

    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.insert_chart,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Monthly Attendance Rate',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Your consistency over the last 6 months',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: chartHeight,
              child: LineChart(
                LineChartData(
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      // tooltipBgColor:
                      //     isDarkMode ? Colors.grey[800]! : Colors.white,
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          final month =
                              monthlyData.keys.elementAt(spot.x.toInt());
                          final present = attendanceCounts[month] ?? 0;
                          final total = totalDaysPerMonth[month] ?? 30;
                          return LineTooltipItem(
                            '$month: ${(spot.y * 100).toStringAsFixed(1)}%\n$present / $total days',
                            TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 0.2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    ),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value < 0 || value >= monthlyData.length) {
                            return const SizedBox();
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              monthlyData.keys.elementAt(value.toInt()),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${(value * 100).toInt()}%',
                            style: Theme.of(context).textTheme.bodySmall,
                          );
                        },
                        reservedSize: 35,
                      ),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: monthlyData.length - 1.0,
                  minY: 0,
                  maxY: 1,
                  lineBarsData: [
                    LineChartBarData(
                      spots: List.generate(
                        monthlyData.length,
                        (index) => FlSpot(
                          index.toDouble(),
                          monthlyData.values.elementAt(index),
                        ),
                      ),
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) =>
                            FlDotCirclePainter(
                          radius: 6,
                          color: Theme.of(context).colorScheme.primary,
                          strokeWidth: 2,
                          strokeColor: isDarkMode ? Colors.black : Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.15),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.05),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Monthly trend analysis
            _buildMonthlyTrendAnalysis(monthlyData),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyTrendAnalysis(Map<String, double> monthlyData) {
    // Calculate trend
    double trend = 0;
    if (monthlyData.length >= 2) {
      final values = monthlyData.values.toList();
      final latestMonth = values.last;
      final previousMonth = values[values.length - 2];
      trend = latestMonth - previousMonth;
    }

    // Get month names
    final latestMonthName =
        monthlyData.keys.isNotEmpty ? monthlyData.keys.last : '';

    // Determine icon and text
    IconData icon;
    String trendText;
    Color trendColor;

    if (trend > 0.1) {
      icon = Icons.trending_up;
      trendText = "Great improvement! You're going to the gym more frequently.";
      trendColor = Colors.green;
    } else if (trend > 0) {
      icon = Icons.trending_up;
      trendText = "Slight improvement in your gym attendance. Keep it up!";
      trendColor = Colors.green;
    } else if (trend == 0) {
      icon = Icons.trending_flat;
      trendText = "Your gym attendance is steady. Consistency is key!";
      trendColor = Colors.blue;
    } else if (trend > -0.1) {
      icon = Icons.trending_down;
      trendText = "Slight decrease in gym visits. Try to stay consistent!";
      trendColor = Colors.orange;
    } else {
      icon = Icons.trending_down;
      trendText = "Your gym attendance has decreased. Let's get back on track!";
      trendColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: trendColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: trendColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$latestMonthName Trend: ${(trend * 100).abs().toStringAsFixed(1)}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: trendColor,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  trendText,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black87,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDateRangePicker(bool isDarkMode, Size size) {
    // Adjust padding and styling based on screen size
    final buttonPadding = size.width < 360
        ? const EdgeInsets.symmetric(horizontal: 6, vertical: 8)
        : const EdgeInsets.symmetric(horizontal: 12, vertical: 10);

    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.date_range,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Custom Date Range',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Responsive date picker layout
            size.width < 400
                ? Column(
                    children: [
                      _buildDatePickerField(_rangeStart, 'Start Date', (date) {
                        setState(() {
                          _rangeStart = date;
                        });
                      }, isDarkMode),
                      const SizedBox(height: 16),
                      _buildDatePickerField(_rangeEnd, 'End Date', (date) {
                        setState(() {
                          _rangeEnd = date;
                        });
                      }, isDarkMode),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child:
                            _buildDatePickerField(_rangeStart, 'Start', (date) {
                          setState(() {
                            _rangeStart = date;
                          });
                        }, isDarkMode),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'to',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: _buildDatePickerField(_rangeEnd, 'End', (date) {
                          setState(() {
                            _rangeEnd = date;
                          });
                        }, isDarkMode),
                      ),
                    ],
                  ),
            const SizedBox(height: 16),
            // Quick date range selections - scrollable
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildQuickDateRangeButton('Last 7 days', 7, buttonPadding),
                  _buildQuickDateRangeButton('Last 30 days', 30, buttonPadding),
                  _buildQuickDateRangeButton(
                      'Last 3 months', 90, buttonPadding),
                  _buildQuickDateRangeButton(
                      'Last 6 months', 180, buttonPadding),
                  _buildQuickDateRangeButton('This year', 365, buttonPadding),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  final userId =
                      Provider.of<AuthProvider>(context, listen: false).userId;
                  if (userId != null) {
                    Provider.of<AttendanceProvider>(context, listen: false)
                        .fetchAttendanceHistory(int.parse(userId),
                            startDate: _rangeStart, endDate: _rangeEnd);

                    // Provide feedback
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Date range updated: ${DateFormat('MMM d').format(_rangeStart)} - ${DateFormat('MMM d').format(_rangeEnd)}',
                        ),
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Apply Date Range'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(DateTime initialDate, String label,
      Function(DateTime) onDateSelected, bool isDarkMode) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: ColorScheme.light(
                  primary: Theme.of(context).colorScheme.primary,
                  onPrimary: Colors.white,
                  surface: isDarkMode ? Colors.grey[800]! : Colors.white,
                  onSurface: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null && picked != initialDate) {
          onDateSelected(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 18,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('MMM d, yyyy').format(initialDate),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
            const Spacer(),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickDateRangeButton(
      String label, int days, EdgeInsets padding) {
    final now = DateTime.now();

    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            _rangeEnd = now;
            _rangeStart = now.subtract(Duration(days: days));
          });
        },
        style: OutlinedButton.styleFrom(
          padding: padding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }

  Widget _buildHistoryTab(
      AttendanceProvider attendanceProvider, bool isDarkMode, Size size) {
    final attendanceHistory = attendanceProvider.attendanceHistory;

    if (attendanceHistory.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: size.width * 0.2,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No attendance records found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try selecting a different date range',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _tabController.animateTo(1); // Switch to Stats tab
              },
              icon: const Icon(Icons.date_range),
              label: const Text('Change Date Range'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    // Group by month for section headers
    final Map<String, List<dynamic>> groupedData = {};

    for (final attendance in attendanceHistory) {
      final monthYear =
          DateFormat('MMMM yyyy').format(attendance.attendanceDate);

      if (!groupedData.containsKey(monthYear)) {
        groupedData[monthYear] = [];
      }

      groupedData[monthYear]!.add(attendance);
    }

    // Convert to list sorted by date (newest first)
    final groupedEntries = groupedData.entries.toList()
      ..sort((a, b) {
        final aDate = a.value[0].attendanceDate;
        final bDate = b.value[0].attendanceDate;
        return bDate.compareTo(aDate);
      });

    return RefreshIndicator(
      onRefresh: _fetchAttendanceData,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.04),
              child: _buildHistoryHeaderCard(attendanceHistory.length, size),
            ),
          ),
          ...groupedEntries.map((entry) {
            final monthYear = entry.key;
            final attendances = entry.value;

            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (index == 0) {
                    // Month header
                    return Padding(
                      padding: EdgeInsets.only(
                        left: size.width * 0.04,
                        right: size.width * 0.04,
                        top: 16.0,
                        bottom: 8.0,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              monthYear,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.5),
                              thickness: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${attendances.length} visits',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Attendance entry
                  final attendance = attendances[index - 1];
                  return _buildAttendanceHistoryCard(
                      attendance, isDarkMode, size);
                },
                childCount: attendances.length + 1, // +1 for the header
              ),
            );
          }),
          // Add some bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryHeaderCard(int totalEntries, Size size) {
    return Card(
      elevation: 4,
      shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attendance History',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your gym check-ins over time',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$totalEntries check-ins',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Search history...',
                hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceHistoryCard(
      dynamic attendance, bool isDarkMode, Size size) {
    final attendanceDate = attendance.attendanceDate;
    final formattedDate = DateFormat('EEEE, MMM d').format(attendanceDate);
    final formattedTime = DateFormat('hh:mm a').format(attendanceDate);

    // Adjust padding based on screen size
    final horizontalPadding = size.width * 0.04;
    const verticalPadding = 6.0;

    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: Card(
        elevation: 2,
        shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                Icons.fitness_center,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          title: Text(
            formattedDate,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                attendance.userInfo.fullName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black87,
                    ),
              ),
              // If gym location is available
              if (attendance.gymId != null)
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Gym #${attendance.gymId}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                  ],
                ),
            ],
          ),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              formattedTime,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
