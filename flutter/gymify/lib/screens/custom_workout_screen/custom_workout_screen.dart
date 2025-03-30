// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
// import 'package:gymify/screens/custom_workout_screen/custom_workout_detail_screen.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart';

// class CustomWorkoutListScreen extends StatefulWidget {
//   const CustomWorkoutListScreen({super.key});

//   @override
//   _CustomWorkoutListScreenState createState() =>
//       _CustomWorkoutListScreenState();
// }

// class _CustomWorkoutListScreenState extends State<CustomWorkoutListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   late ThemeData theme;

//   @override
//   Widget build(BuildContext context) {
//     theme = Theme.of(context);
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'Custom Workout Plan',
//         showBackButton: true,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.add, color: theme.colorScheme.primary),
//             onPressed: () {
//               context.pushNamed('createCustomWorkout');
//             },
//           ),
//         ],
//       ),
//       body: ChangeNotifierProvider(
//         create: (_) => CustomWorkoutProvider()..fetchCustomWorkouts(),
//         child: Consumer<CustomWorkoutProvider>(
//           builder: (context, customWorkoutProvider, child) {
//             if (customWorkoutProvider.isLoading) {
//               return const Center(child: CustomLoadingAnimation());
//             }

//             if (customWorkoutProvider.customWorkouts.isEmpty) {
//               return const Center(child: Text('No custom workouts found.'));
//             }

//             // Filter workouts based on the search query
//             final filteredWorkouts =
//                 customWorkoutProvider.customWorkouts.where((workout) {
//               return workout.customWorkoutName
//                   .toLowerCase()
//                   .contains(_searchQuery.toLowerCase());
//             }).toList();

//             return Column(
//               children: [
//                 // Search Bar
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                   child: TextField(
//                     controller: _searchController,
//                     onChanged: (value) {
//                       setState(() {
//                         _searchQuery = value;
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search Custom Workouts...',
//                       prefixIcon: const Icon(Icons.search),
//                       // fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),

//                 // Custom Workout List
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: filteredWorkouts.length,
//                     itemBuilder: (context, index) {
//                       final workout = filteredWorkouts[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 15),
//                         elevation: 5,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => CustomWorkoutDetailScreen(
//                                     customWorkoutId: workout.customWorkoutId),
//                               ),
//                             );
//                           },
//                           child: ListTile(
//                             leading: Icon(
//                               Icons.fitness_center,
//                               color: theme.colorScheme.primary,
//                             ),
//                             title: Text(
//                               workout.customWorkoutName,
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
// import 'package:gymify/screens/custom_workout_screen/custom_workout_detail_screen.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart';

// class CustomWorkoutListScreen extends StatefulWidget {
//   const CustomWorkoutListScreen({super.key});

//   @override
//   _CustomWorkoutListScreenState createState() =>
//       _CustomWorkoutListScreenState();
// }

// class _CustomWorkoutListScreenState extends State<CustomWorkoutListScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   late ThemeData theme;

//   @override
//   void initState() {
//     super.initState();
//     // Set system UI overlay style for immersive experience
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     theme = Theme.of(context);

//     return Scaffold(
//       body: ChangeNotifierProvider(
//         create: (_) => CustomWorkoutProvider()..fetchCustomWorkouts(),
//         child: Consumer<CustomWorkoutProvider>(
//           builder: (context, customWorkoutProvider, child) {
//             if (customWorkoutProvider.isLoading) {
//               return const Center(child: CustomLoadingAnimation());
//             }

//             if (customWorkoutProvider.customWorkouts.isEmpty) {
//               return _buildEmptyState();
//             }

//             // Filter workouts based on the search query
//             final filteredWorkouts =
//                 customWorkoutProvider.customWorkouts.where((workout) {
//               return workout.customWorkoutName
//                   .toLowerCase()
//                   .contains(_searchQuery.toLowerCase());
//             }).toList();

//             return Stack(
//               children: [
//                 CustomScrollView(
//                   slivers: [
//                     // Header with title and search
//                     SliverAppBar(
//                       expandedHeight: 180,
//                       pinned: true,
//                       stretch: true,
//                       backgroundColor: theme.colorScheme.primary,
//                       leading: GestureDetector(
//                         onTap: () => Navigator.pop(context),
//                         child: Container(
//                           margin: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.3),
//                             shape: BoxShape.circle,
//                           ),
//                           child: const Icon(
//                             Icons.arrow_back_ios,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       flexibleSpace: FlexibleSpaceBar(
//                         background: Stack(
//                           fit: StackFit.expand,
//                           children: [
//                             // Background gradient
//                             Container(
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topLeft,
//                                   end: Alignment.bottomRight,
//                                   colors: [
//                                     theme.colorScheme.primary,
//                                     theme.colorScheme.primary.withBlue(
//                                         (theme.colorScheme.primary.blue + 40)
//                                             .clamp(0, 255)),
//                                   ],
//                                 ),
//                               ),
//                             ),

//                             // Background pattern (optional)
//                             Opacity(
//                               opacity: 0.1,
//                               child: Image.network(
//                                 'https://www.transparenttextures.com/patterns/cubes.png',
//                                 repeat: ImageRepeat.repeat,
//                               ),
//                             ),

//                             // Title and subtitle
//                             Positioned(
//                               top: 60,
//                               left: 20,
//                               right: 20,
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Custom Workouts',
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 28,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     'Your personalized workout collection',
//                                     style: GoogleFonts.roboto(
//                                       fontSize: 14,
//                                       color: Colors.white.withOpacity(0.8),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       bottom: PreferredSize(
//                         preferredSize: const Size.fromHeight(60),
//                         child: Container(
//                           height: 60,
//                           padding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 10),
//                           child: TextField(
//                             controller: _searchController,
//                             onChanged: (value) {
//                               setState(() {
//                                 _searchQuery = value;
//                               });
//                             },
//                             decoration: InputDecoration(
//                               hintText: 'Search custom workouts...',
//                               prefixIcon:
//                                   const Icon(Icons.search, color: Colors.grey),
//                               suffixIcon: _searchQuery.isNotEmpty
//                                   ? IconButton(
//                                       icon: const Icon(Icons.clear,
//                                           color: Colors.grey),
//                                       onPressed: () {
//                                         setState(() {
//                                           _searchController.clear();
//                                           _searchQuery = '';
//                                         });
//                                       },
//                                     )
//                                   : null,
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(30),
//                                 borderSide: BorderSide.none,
//                               ),
//                               contentPadding:
//                                   const EdgeInsets.symmetric(vertical: 0),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     // Workouts section header
//                     SliverToBoxAdapter(
//                       child: Padding(
//                         padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Your Workouts',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                                 color: theme.colorScheme.onSurface,
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 12, vertical: 6),
//                               decoration: BoxDecoration(
//                                 color: theme.colorScheme.primaryContainer,
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 '${filteredWorkouts.length} total',
//                                 style: TextStyle(
//                                   color: theme.colorScheme.onPrimaryContainer,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     // Custom workout list
//                     SliverPadding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 20, vertical: 10),
//                       sliver: SliverList(
//                         delegate: SliverChildBuilderDelegate(
//                           (context, index) {
//                             final workout = filteredWorkouts[index];
//                             return _buildWorkoutCard(workout);
//                           },
//                           childCount: filteredWorkouts.length,
//                         ),
//                       ),
//                     ),

//                     // Extra space for FAB
//                     const SliverToBoxAdapter(
//                       child: SizedBox(height: 100),
//                     ),
//                   ],
//                 ),

//                 // Create Workout button positioned at the bottom
//                 Positioned(
//                   left: 20,
//                   right: 20,
//                   bottom: 20,
//                   child: SafeArea(
//                     child: Container(
//                       height: 60,
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [
//                             theme.colorScheme.primary,
//                             theme.colorScheme.primary.withBlue(
//                               (theme.colorScheme.primary.blue + 40)
//                                   .clamp(0, 255),
//                             ),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.3),
//                             blurRadius: 12,
//                             offset: const Offset(0, 4),
//                             spreadRadius: 2,
//                           ),
//                         ],
//                       ),
//                       child: Material(
//                         color: Colors.transparent,
//                         child: InkWell(
//                           borderRadius: BorderRadius.circular(16),
//                           onTap: () {
//                             context.pushNamed('createCustomWorkout');
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(8),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.2),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 child: const Icon(
//                                   FontAwesomeIcons.plus,
//                                   color: Colors.white,
//                                   size: 18,
//                                 ),
//                               ),
//                               const SizedBox(width: 12),
//                               Text(
//                                 'CREATE WORKOUT',
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   letterSpacing: 1,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return SafeArea(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             FontAwesomeIcons.dumbbell,
//             size: 70,
//             color: theme.colorScheme.primary.withOpacity(0.5),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'No Custom Workouts',
//             style: GoogleFonts.poppins(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: theme.colorScheme.primary,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 32),
//             child: Text(
//               'Create your first custom workout to start building your personalized fitness routine.',
//               style: theme.textTheme.bodyLarge,
//               textAlign: TextAlign.center,
//             ),
//           ),
//           const SizedBox(height: 32),
//           ElevatedButton.icon(
//             onPressed: () => context.pushNamed('createCustomWorkout'),
//             icon: const Icon(Icons.add),
//             label: const Text('Create Workout'),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildWorkoutCard(dynamic workout) {
//     // Dummy data for demonstration - in real app, these would come from your workout object
//     final String difficulty =
//         ['Beginner', 'Intermediate', 'Advanced'][workout.hashCode % 3];
//     final String muscleGroup = _getRandomMuscleGroup(workout.hashCode);
//     final int exerciseCount =
//         5 + (workout.hashCode % 8); // Random number between 5-12
//     final String imageUrl = _getWorkoutImage(muscleGroup);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: theme.colorScheme.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => CustomWorkoutDetailScreen(
//                 customWorkoutId: workout.customWorkoutId,
//               ),
//             ),
//           );
//         },
//         child: Column(
//           children: [
//             // Workout image and title
//             Stack(
//               children: [
//                 // Workout image
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   child: SizedBox(
//                     height: 120,
//                     width: double.infinity,
//                     child: CachedNetworkImage(
//                       imageUrl: imageUrl,
//                       fit: BoxFit.cover,
//                       placeholder: (context, url) => Container(
//                         color: theme.colorScheme.primary.withOpacity(0.2),
//                       ),
//                       errorWidget: (context, url, error) => Container(
//                         color: theme.colorScheme.primary.withOpacity(0.2),
//                         child: const Icon(Icons.image_not_supported, size: 50),
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Gradient overlay
//                 ClipRRect(
//                   borderRadius: const BorderRadius.only(
//                     topLeft: Radius.circular(16),
//                     topRight: Radius.circular(16),
//                   ),
//                   child: Container(
//                     height: 120,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.7),
//                         ],
//                         stops: const [0.5, 1.0],
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Difficulty badge
//                 Positioned(
//                   top: 12,
//                   left: 12,
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: _getDifficultyColor(difficulty),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Text(
//                       difficulty.toUpperCase(),
//                       style: GoogleFonts.roboto(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 12,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),

//                 // Workout title and info
//                 Positioned(
//                   bottom: 12,
//                   left: 12,
//                   right: 12,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         workout.customWorkoutName,
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                         ),
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(
//                             FontAwesomeIcons.dumbbell,
//                             size: 12,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             muscleGroup,
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                           const SizedBox(width: 12),
//                           const Icon(
//                             FontAwesomeIcons.listCheck,
//                             size: 12,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             "$exerciseCount exercises",
//                             style: const TextStyle(
//                               fontSize: 12,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),

//             // Quick info bar
//             Padding(
//               padding: const EdgeInsets.all(12),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   _buildInfoElement(
//                     'GOAL',
//                     _getRandomGoal(workout.hashCode),
//                     FontAwesomeIcons.bullseye,
//                   ),
//                   _buildInfoElement(
//                     'LEVEL',
//                     difficulty,
//                     FontAwesomeIcons.userGroup,
//                   ),
//                   _buildInfoElement(
//                     'FOCUS',
//                     _getWorkoutFocus(muscleGroup),
//                     FontAwesomeIcons.crosshairs,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoElement(String label, String value, IconData icon) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           size: 16,
//           color: theme.colorScheme.primary,
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.w500,
//             color: theme.colorScheme.onSurface.withOpacity(0.6),
//           ),
//         ),
//         const SizedBox(height: 2),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.bold,
//             color: theme.colorScheme.onSurface,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   // Helper methods for generating sample data
//   Color _getDifficultyColor(String difficulty) {
//     switch (difficulty.toLowerCase()) {
//       case 'beginner':
//         return Colors.green;
//       case 'intermediate':
//         return Colors.orange;
//       case 'advanced':
//         return Colors.red;
//       case 'expert':
//         return Colors.purple;
//       default:
//         return Colors.blue;
//     }
//   }

//   String _getRandomMuscleGroup(int seed) {
//     final List<String> groups = [
//       'Chest',
//       'Back',
//       'Legs',
//       'Shoulders',
//       'Arms',
//       'Core',
//       'Full Body'
//     ];
//     return groups[seed % groups.length];
//   }

//   String _getRandomGoal(int seed) {
//     final List<String> goals = [
//       'Strength',
//       'Hypertrophy',
//       'Endurance',
//       'Power',
//       'Weight Loss'
//     ];
//     return goals[seed % goals.length];
//   }

//   String _getWorkoutFocus(String muscleGroup) {
//     final lowercaseMuscle = muscleGroup.toLowerCase();

//     if (lowercaseMuscle.contains('chest') || lowercaseMuscle.contains('pecs')) {
//       return 'Upper Body';
//     } else if (lowercaseMuscle.contains('leg') ||
//         lowercaseMuscle.contains('quad') ||
//         lowercaseMuscle.contains('hamstring') ||
//         lowercaseMuscle.contains('glute')) {
//       return 'Lower Body';
//     } else if (lowercaseMuscle.contains('back') ||
//         lowercaseMuscle.contains('lat')) {
//       return 'Back';
//     } else if (lowercaseMuscle.contains('arm') ||
//         lowercaseMuscle.contains('bicep') ||
//         lowercaseMuscle.contains('tricep')) {
//       return 'Arms';
//     } else if (lowercaseMuscle.contains('core') ||
//         lowercaseMuscle.contains('abs')) {
//       return 'Core';
//     } else if (lowercaseMuscle.contains('shoulder') ||
//         lowercaseMuscle.contains('delt')) {
//       return 'Shoulders';
//     } else if (lowercaseMuscle.contains('full') ||
//         lowercaseMuscle.contains('total')) {
//       return 'Full Body';
//     } else {
//       return 'Specialized';
//     }
//   }

//   String _getWorkoutImage(String muscleGroup) {
//     // You'd replace these with actual URLs from your app
//     final Map<String, String> imageMap = {
//       'Chest':
//           'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       'Back':
//           'https://images.unsplash.com/photo-1534368786749-9b47e517ed3a?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       'Legs':
//           'https://images.unsplash.com/photo-1434608519344-49d77a699e1d?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       'Shoulders':
//           'https://images.unsplash.com/photo-1580261450046-d0a30080dc9b?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       'Arms':
//           'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       'Core':
//           'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60',
//       'Full Body':
//           'https://images.unsplash.com/photo-1579126038374-6064e9370f0f?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'
//     };

//     return imageMap[muscleGroup] ??
//         'https://images.unsplash.com/photo-1526506118085-60ce8714f8c5?ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60';
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/providers/custom_workout_provider/custom_workout_provider.dart';
import 'package:gymify/screens/custom_workout_screen/custom_workout_detail_screen.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';

class CustomWorkoutListScreen extends StatefulWidget {
  const CustomWorkoutListScreen({super.key});

  @override
  _CustomWorkoutListScreenState createState() =>
      _CustomWorkoutListScreenState();
}

class _CustomWorkoutListScreenState extends State<CustomWorkoutListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    // Set system UI overlay style for immersive experience
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    theme = Theme.of(context);

    return Scaffold(
      body: ChangeNotifierProvider(
        create: (_) => CustomWorkoutProvider()..fetchCustomWorkouts(),
        child: Consumer<CustomWorkoutProvider>(
          builder: (context, customWorkoutProvider, child) {
            if (customWorkoutProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (customWorkoutProvider.customWorkouts.isEmpty) {
              return _buildEmptyState();
            }

            // Filter workouts based on the search query
            final filteredWorkouts =
                customWorkoutProvider.customWorkouts.where((workout) {
              return workout.customWorkoutName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
            }).toList();

            return Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    // Header with title and search
                    SliverAppBar(
                      expandedHeight: 180,
                      pinned: true,
                      stretch: true,
                      backgroundColor: theme.colorScheme.primary,
                      leading: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          margin: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Background gradient
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary.withBlue(
                                        (theme.colorScheme.primary.blue + 40)
                                            .clamp(0, 255)),
                                  ],
                                ),
                              ),
                            ),

                            // Background pattern (optional)
                            Opacity(
                              opacity: 0.1,
                              child: Image.network(
                                'https://www.transparenttextures.com/patterns/cubes.png',
                                repeat: ImageRepeat.repeat,
                              ),
                            ),

                            // Title and subtitle
                            Positioned(
                              top: 60,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Custom Workouts',
                                    style: GoogleFonts.poppins(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Your personalized workout collection',
                                    style: GoogleFonts.roboto(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              setState(() {
                                _searchQuery = value;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Search custom workouts...',
                              prefixIcon: Icon(Icons.search,
                                  color: Theme.of(context).colorScheme.primary),
                              suffixIcon: _searchQuery.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear,
                                          color: Colors.grey),
                                      onPressed: () {
                                        setState(() {
                                          _searchController.clear();
                                          _searchQuery = '';
                                        });
                                      },
                                    )
                                  : null,
                              // fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 0),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Workouts section header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Your Workouts',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${filteredWorkouts.length} total',
                                style: TextStyle(
                                  color: theme.colorScheme.onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Custom workout list
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final workout = filteredWorkouts[index];
                            return _buildWorkoutCard(workout);
                          },
                          childCount: filteredWorkouts.length,
                        ),
                      ),
                    ),

                    // Extra space for FAB
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 100),
                    ),
                  ],
                ),

                // Create Workout button positioned at the bottom
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: SafeArea(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withBlue(
                              (theme.colorScheme.primary.blue + 40)
                                  .clamp(0, 255),
                            ),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () {
                            context.pushNamed('createCustomWorkout');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'CREATE OWN WORKOUT',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.dumbbell,
            size: 70,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: 24),
          Text(
            'No Custom Workouts',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Create your first custom workout to start building your personalized fitness routine.',
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.pushNamed('createCustomWorkout'),
            icon: const Icon(Icons.add),
            label: const Text('Create Workout'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(dynamic workout) {
    // Get actual data from the workout model
    final String workoutName = workout.customWorkoutName;
    final DateTime createdAt = workout.createdAt;
    final int exerciseCount = workout.customworkoutexercises.length;

    // Extract unique target muscle groups from exercises
    final Set<String> muscleGroups = {};
    for (final exercise in workout.customworkoutexercises) {
      if (exercise.exercises != null &&
          exercise.exercises.targetMuscleGroup != null) {
        muscleGroups.add(exercise.exercises.targetMuscleGroup);
      }
    }

    // Create a display string for muscle groups
    final String muscleGroupsDisplay = _formatMuscleGroups(muscleGroups);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CustomWorkoutDetailScreen(
                customWorkoutId: workout.customWorkoutId,
              ),
            ),
          );
        },
        child: Column(
          children: [
            // Workout header with title
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.primary.withBlue(
                        (theme.colorScheme.primary.blue + 40).clamp(0, 255)),
                  ],
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'CUSTOM',
                      style: GoogleFonts.roboto(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Workout title
                  Text(
                    workoutName,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Workout info
                  Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.dumbbell,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        muscleGroupsDisplay,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        FontAwesomeIcons.listCheck,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "$exerciseCount exercises",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Quick info bar
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfoElement(
                    'CREATED',
                    _formatDate(createdAt),
                    FontAwesomeIcons.calendar,
                  ),
                  _buildInfoElement(
                    'EXERCISES',
                    exerciseCount.toString(),
                    FontAwesomeIcons.listCheck,
                  ),
                  _buildInfoElement(
                    'FOCUS',
                    _getWorkoutFocus(muscleGroupsDisplay),
                    FontAwesomeIcons.crosshairs,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoElement(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          size: 16,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Helper methods that work with actual data
  String _formatMuscleGroups(Set<String> muscleGroups) {
    if (muscleGroups.isEmpty) {
      return "Various";
    } else if (muscleGroups.length == 1) {
      return muscleGroups.first;
    } else if (muscleGroups.length <= 2) {
      return muscleGroups.join(' & ');
    } else {
      return 'Full Body';
    }
  }

  String _formatDate(DateTime date) {
    final today = DateTime.now();
    final difference = today.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '${date.year}-$month-$day';
    }
  }

  String _getWorkoutFocus(String muscleGroups) {
    final lowercaseMuscle = muscleGroups.toLowerCase();

    if (lowercaseMuscle.contains('chest') || lowercaseMuscle.contains('pecs')) {
      return 'Upper Body';
    } else if (lowercaseMuscle.contains('leg') ||
        lowercaseMuscle.contains('quad') ||
        lowercaseMuscle.contains('hamstring') ||
        lowercaseMuscle.contains('glute')) {
      return 'Lower Body';
    } else if (lowercaseMuscle.contains('back') ||
        lowercaseMuscle.contains('lat')) {
      return 'Back';
    } else if (lowercaseMuscle.contains('arm') ||
        lowercaseMuscle.contains('bicep') ||
        lowercaseMuscle.contains('tricep')) {
      return 'Arms';
    } else if (lowercaseMuscle.contains('core') ||
        lowercaseMuscle.contains('abs')) {
      return 'Core';
    } else if (lowercaseMuscle.contains('shoulder') ||
        lowercaseMuscle.contains('delt')) {
      return 'Shoulders';
    } else if (lowercaseMuscle.contains('full') ||
        lowercaseMuscle.contains('total') ||
        muscleGroups == 'Various') {
      return 'Full Body';
    } else {
      return 'Mixed';
    }
  }
}
