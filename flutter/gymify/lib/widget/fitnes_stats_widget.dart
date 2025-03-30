// import 'package:flutter/material.dart';
// import 'package:gymify/providers/pedometer_provider/pedometer_provider.dart';
// import 'package:percent_indicator/percent_indicator.dart';
// import 'package:provider/provider.dart';

// class FitnessStatsCard extends StatelessWidget {
//   final VoidCallback onTap;

//   const FitnessStatsCard({
//     super.key,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<PedometerProvider>(
//       builder: (context, provider, _) {
//         final progress = provider.goalProgress;
//         final isActive = provider.status == 'walking';

//         return GestureDetector(
//           onTap: onTap,
//           child: Container(
//             margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 colors: [
//                   Theme.of(context).primaryColor,
//                   Theme.of(context).primaryColor.withOpacity(0.8),
//                   isActive
//                     ? Colors.greenAccent.withOpacity(0.5)
//                     : Theme.of(context).colorScheme.secondary.withOpacity(0.5),
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Theme.of(context).primaryColor.withOpacity(0.3),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Header section with title and icon
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text(
//                         'Today\'s Activity',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 18,
//                         ),
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withOpacity(0.2),
//                           shape: BoxShape.circle,
//                         ),
//                         child: const Icon(
//                           Icons.directions_walk,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Steps and status
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.end,
//                     children: [
//                       Text(
//                         provider.steps,
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 40,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Padding(
//                         padding: const EdgeInsets.only(bottom: 8),
//                         child: Text(
//                           'steps',
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.8),
//                             fontSize: 16,
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       _buildStatusIndicator(context, provider),
//                     ],
//                   ),
//                 ),

//                 // Progress indicator
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: LinearPercentIndicator(
//                           lineHeight: 8.0,
//                           percent: progress,
//                           backgroundColor: Colors.white.withOpacity(0.2),
//                           progressColor: provider.goalAchieved
//                               ? Colors.greenAccent
//                               : Colors.white,
//                           barRadius: const Radius.circular(4),
//                           padding: EdgeInsets.zero,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Text(
//                         '${(progress * 100).toInt()}%',
//                         style: TextStyle(
//                           color: Colors.white.withOpacity(0.8),
//                           fontSize: 14,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Goal text
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
//                   child: Text(
//                     'Goal: ${provider.dailyGoal} steps',
//                     style: TextStyle(
//                       color: Colors.white.withOpacity(0.8),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ),

//                 // Divider
//                 Divider(
//                   height: 1,
//                   thickness: 1,
//                   color: Colors.white.withOpacity(0.1),
//                 ),

//                 // Stats section
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildStatItem(
//                         context,
//                         '${provider.caloriesBurned.toStringAsFixed(1)}',
//                         'CALORIES',
//                         Icons.local_fire_department,
//                       ),
//                       _buildDivider(),
//                       _buildStatItem(
//                         context,
//                         '${provider.distanceWalked.toStringAsFixed(2)}',
//                         'KM',
//                         Icons.straighten,
//                       ),
//                       _buildDivider(),
//                       _buildStatItem(
//                         context,
//                         _formatDuration(provider.elapsedTime),
//                         'TIME',
//                         Icons.timer,
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Status indicator widget
//   Widget _buildStatusIndicator(BuildContext context, PedometerProvider provider) {
//     Color color;
//     String text;

//     switch (provider.status) {
//       case 'walking':
//         color = Colors.greenAccent;
//         text = 'ACTIVE';
//         break;
//       case 'stopped':
//         color = Colors.orange;
//         text = 'IDLE';
//         break;
//       default:
//         color = Colors.grey;
//         text = 'UNKNOWN';
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: color, width: 1),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 8,
//             height: 8,
//             decoration: BoxDecoration(
//               color: color,
//               shape: BoxShape.circle,
//             ),
//           ),
//           const SizedBox(width: 6),
//           Text(
//             text,
//             style: TextStyle(
//               color: color,
//               fontWeight: FontWeight.bold,
//               fontSize: 12,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // Individual stat item
//   Widget _buildStatItem(BuildContext context, String value, String label, IconData icon) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: Colors.white,
//           size: 20,
//         ),
//         const SizedBox(height: 6),
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: 16,
//           ),
//         ),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.white.withOpacity(0.8),
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }

//   // Vertical divider for stats section
//   Widget _buildDivider() {
//     return Container(
//       height: 30,
//       width: 1,
//       color: Colors.white.withOpacity(0.2),
//     );
//   }

//   // Format duration as HH:MM:SS
//   String _formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return '${twoDigits(duration.inHours)}:$twoDigitMinutes';
//   }
// }

import 'package:flutter/material.dart';
import 'package:gymify/providers/pedometer_provider/pedometer_provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class FitnessStatsCard extends StatelessWidget {
  final VoidCallback onTap;

  const FitnessStatsCard({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<PedometerProvider>(
      builder: (context, provider, _) {
        final progress = provider.goalProgress;
        final isActive = provider.status == 'walking';

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.8),
                  isActive
                      ? Colors.greenAccent.withOpacity(0.5)
                      : Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with title and icon
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today\'s Activity',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.directions_walk,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // Steps and status
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        provider.steps,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          'steps',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Spacer(),
                      _buildStatusIndicator(context, provider),
                    ],
                  ),
                ),

                // Progress indicator
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: LinearPercentIndicator(
                          lineHeight: 8.0,
                          percent: progress,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          progressColor: provider.goalAchieved
                              ? Colors.greenAccent
                              : Colors.white,
                          barRadius: const Radius.circular(4),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Goal text
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 10),
                  child: Text(
                    'Goal: ${provider.dailyGoal} steps',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),

                // Divider
                Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.white.withOpacity(0.1),
                ),

                // Stats section
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem(
                        context,
                        provider.caloriesBurned.toStringAsFixed(1),
                        'CALORIES',
                        Icons.local_fire_department,
                      ),
                      _buildDivider(),
                      _buildStatItem(
                        context,
                        provider.distanceWalked.toStringAsFixed(2),
                        'KM',
                        Icons.straighten,
                      ),
                      _buildDivider(),
                      _buildStatItem(
                        context,
                        _formatDuration(provider.elapsedTime),
                        'TIME',
                        Icons.timer,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Status indicator widget
  Widget _buildStatusIndicator(
      BuildContext context, PedometerProvider provider) {
    Color color;
    String text;

    switch (provider.status) {
      case 'walking':
        color = Colors.greenAccent;
        text = 'ACTIVE';
        break;
      case 'stopped':
        color = Colors.orange;
        text = 'IDLE';
        break;
      default:
        color = Colors.grey;
        text = 'UNKNOWN';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // Individual stat item
  Widget _buildStatItem(
      BuildContext context, String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  // Vertical divider for stats section
  Widget _buildDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.white.withOpacity(0.2),
    );
  }

  // Format duration as HH:MM
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes';
  }
}
