// //! with search bar
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';

// class AllWorkouts extends StatefulWidget {
//   const AllWorkouts({super.key});

//   @override
//   _AllWorkoutsState createState() => _AllWorkoutsState();
// }

// class _AllWorkoutsState extends State<AllWorkouts> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.backgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           'Workouts',
//           style: TextStyle(
//             color: CustomColors.primary,
//           ),
//         ),
//         backgroundColor: CustomColors.backgroundColor,
//       ),
//       body: ChangeNotifierProvider(
//         create: (_) => WorkoutProvider()..fetchAllWorkouts(),
//         child: Consumer<WorkoutProvider>(
//           builder: (context, workoutProvider, child) {
//             if (workoutProvider.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (workoutProvider.workouts.isEmpty) {
//               return const Center(child: Text('No workouts found.'));
//             }

//             // Filter workouts based on the search query
//             final filteredWorkouts = workoutProvider.workouts.where((workout) {
//               final workoutName = workout.workoutName.toLowerCase();
//               final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
//               return workoutName.contains(_searchQuery) ||
//                   targetMuscleGroup.contains(_searchQuery);
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
//                         _searchQuery = value.toLowerCase();
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search Workouts...',
//                       prefixIcon: const Icon(Icons.search),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),

//                 // Workout List
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
//                                 builder: (context) => WorkoutDetailScreen(
//                                     workoutId: workout.workoutId),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: workout.workoutImage.isNotEmpty
//                                     ? NetworkImage(workout.workoutImage)
//                                     : const AssetImage(
//                                             'assets/images/workout_image/defaultWorkoutImage.jpg')
//                                         as ImageProvider,
//                                 fit: BoxFit.cover,
//                                 colorFilter: ColorFilter.mode(
//                                   Colors.black.withOpacity(0.5),
//                                   BlendMode.darken,
//                                 ),
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.all(16),
//                               title: Text(
//                                 workout.workoutName,
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 workout.targetMuscleGroup,
//                                 style: const TextStyle(
//                                     color: Colors.white, fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () {
//                     context.pushNamed('customWorkout');
//                   },
//                   child: Text('Create Your own workout plan'),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// //! working at the moment
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';

// class AllWorkouts extends StatefulWidget {
//   const AllWorkouts({super.key});

//   @override
//   _AllWorkoutsState createState() => _AllWorkoutsState();
// }

// class _AllWorkoutsState extends State<AllWorkouts> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   // Sorting state
//   String? selectedFitnessLevel;
//   String? selectedGoalType;
//   String? selectedDifficulty;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.backgroundColor,
//       appBar: AppBar(
//         title: const Text(
//           'All Workouts',
//           style: TextStyle(
//             color: CustomColors.primary,
//           ),
//         ),
//         backgroundColor: CustomColors.backgroundColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_sharp,
//               color: Color(0xFFFF5E3A)),
//           onPressed: () {
//             context.pop();
//           },
//         ),
//       ),
//       body: ChangeNotifierProvider(
//         create: (_) => WorkoutProvider()..fetchAllWorkouts(),
//         child: Consumer<WorkoutProvider>(
//           builder: (context, workoutProvider, child) {
//             if (workoutProvider.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (workoutProvider.workouts.isEmpty) {
//               return const Center(child: Text('No workouts found.'));
//             }

//             // Filter and Sort Workouts
//             final filteredWorkouts = workoutProvider.workouts.where((workout) {
//               final workoutName = workout.workoutName.toLowerCase();
//               final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
//               final matchesSearch = workoutName.contains(_searchQuery) ||
//                   targetMuscleGroup.contains(_searchQuery);

//               final matchesFitnessLevel = selectedFitnessLevel == null ||
//                   workout.fitnessLevel == selectedFitnessLevel;

//               final matchesGoalType = selectedGoalType == null ||
//                   workout.goalType == selectedGoalType;

//               final matchesDifficulty = selectedDifficulty == null ||
//                   workout.difficulty == selectedDifficulty;

//               return matchesSearch &&
//                   matchesFitnessLevel &&
//                   matchesGoalType &&
//                   matchesDifficulty;
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
//                         _searchQuery = value.toLowerCase();
//                       });
//                     },
//                     decoration: InputDecoration(
//                       hintText: 'Search Workouts...',
//                       prefixIcon: const Icon(Icons.search),
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                     ),
//                   ),
//                 ),

//                 // Sort Bar
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // Fitness Level Dropdown
//                         DropdownButton<String>(
//                           hint: const Text('Fitness Level'),
//                           value: selectedFitnessLevel,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedFitnessLevel = value;
//                             });
//                           },
//                           items: [
//                             'Beginner',
//                             'Intermediate',
//                             'Advanced',
//                             'Athlete',
//                           ].map((level) {
//                             return DropdownMenuItem(
//                               value: level,
//                               child: Text(level),
//                             );
//                           }).toList(),
//                         ),
//                         // Goal Type Dropdown
//                         DropdownButton<String>(
//                           hint: const Text('Goal Type'),
//                           value: selectedGoalType,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedGoalType = value;
//                             });
//                           },
//                           items: [
//                             'Weight Loss',
//                             'Muscle Gain',
//                             'Endurance',
//                             'Maintenance',
//                             'Flexibility',
//                           ].map((goal) {
//                             return DropdownMenuItem(
//                               value: goal,
//                               child: Text(goal),
//                             );
//                           }).toList(),
//                         ),
//                         // Difficulty Dropdown
//                         DropdownButton<String>(
//                           hint: const Text('Difficulty'),
//                           value: selectedDifficulty,
//                           onChanged: (value) {
//                             setState(() {
//                               selectedDifficulty = value;
//                             });
//                           },
//                           items: ['Easy', 'Intermediate', 'Hard'].map((level) {
//                             return DropdownMenuItem(
//                               value: level,
//                               child: Text(level),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 // Workout List
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
//                                 builder: (context) => WorkoutDetailScreen(
//                                     workoutId: workout.workoutId),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: workout.workoutImage.isNotEmpty
//                                     ? NetworkImage(workout.workoutImage)
//                                     : const AssetImage(
//                                             'assets/images/workout_image/defaultWorkoutImage.jpg')
//                                         as ImageProvider,
//                                 fit: BoxFit.cover,
//                                 colorFilter: ColorFilter.mode(
//                                   Colors.black.withOpacity(0.5),
//                                   BlendMode.darken,
//                                 ),
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: ListTile(
//                               contentPadding: const EdgeInsets.all(16),
//                               title: Text(
//                                 workout.workoutName,
//                                 style: const TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 22,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               subtitle: Text(
//                                 workout.targetMuscleGroup,
//                                 style: const TextStyle(
//                                     color: Colors.white, fontSize: 16),
//                               ),
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//                 // TextButton(
//                 //   onPressed: () {
//                 //     context.pushNamed('customWorkout');
//                 //   },
//                 //   child: const Text('Create Your Own Workout Plan'),
//                 // ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// //!trying
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class AllWorkouts extends StatefulWidget {
  const AllWorkouts({super.key});

  @override
  _AllWorkoutsState createState() => _AllWorkoutsState();
}

class _AllWorkoutsState extends State<AllWorkouts> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // Sorting state
  String? selectedFitnessLevel;
  String? selectedGoalType;
  String? selectedDifficulty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'All Workouts',
          style: TextStyle(
            color: CustomColors.primary,
          ),
        ),
        backgroundColor: CustomColors.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp,
              color: Color(0xFFFF5E3A)),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => WorkoutProvider()..fetchAllWorkouts(),
        child: Consumer<WorkoutProvider>(
          builder: (context, workoutProvider, child) {
            if (workoutProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (workoutProvider.workouts.isEmpty) {
              return const Center(child: Text('No workouts found.'));
            }

            // Filter and Sort Workouts
            final filteredWorkouts = workoutProvider.workouts.where((workout) {
              final workoutName = workout.workoutName.toLowerCase();
              final targetMuscleGroup = workout.targetMuscleGroup.toLowerCase();
              final matchesSearch = workoutName.contains(_searchQuery) ||
                  targetMuscleGroup.contains(_searchQuery);

              final matchesFitnessLevel = selectedFitnessLevel == null ||
                  workout.fitnessLevel == selectedFitnessLevel;

              final matchesGoalType = selectedGoalType == null ||
                  workout.goalType == selectedGoalType;

              final matchesDifficulty = selectedDifficulty == null ||
                  workout.difficulty == selectedDifficulty;

              return matchesSearch &&
                  matchesFitnessLevel &&
                  matchesGoalType &&
                  matchesDifficulty;
            }).toList();

            return Column(
              children: [
                // Search Bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Workouts...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                // Sort Bar
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 16),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       // Fitness Level Dropdown
                //       _buildDropdown(
                //         hint: 'Fitness Level',
                //         value: selectedFitnessLevel,
                //         items: [
                //           'Beginner',
                //           'Intermediate',
                //           'Advanced',
                //           'Athlete'
                //         ],
                //         onChanged: (value) {
                //           setState(() {
                //             selectedFitnessLevel = value;
                //           });
                //         },
                //       ),
                //       // Goal Type Dropdown
                //       _buildDropdown(
                //         hint: 'Goal Type',
                //         value: selectedGoalType,
                //         items: [
                //           'Weight Loss',
                //           'Muscle Gain',
                //           'Endurance',
                //           'Maintenance',
                //           'Flexibility'
                //         ],
                //         onChanged: (value) {
                //           setState(() {
                //             selectedGoalType = value;
                //           });
                //         },
                //       ),
                //       // Difficulty Dropdown
                //       _buildDropdown(
                //         hint: 'Difficulty',
                //         value: selectedDifficulty,
                //         items: ['Easy', 'Intermediate', 'Hard'],
                //         onChanged: (value) {
                //           setState(() {
                //             selectedDifficulty = value;
                //           });
                //         },
                //       ),
                //     ],
                //   ),
                // ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Fitness Level Dropdown
                      _buildDropdown(
                        hint: 'Fitness Level',
                        value: selectedFitnessLevel,
                        items: [
                          'Beginner',
                          'Intermediate',
                          'Advanced',
                          'Athlete',
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedFitnessLevel = value;
                          });
                        },
                      ),
                      // Goal Type Dropdown
                      _buildDropdown(
                        hint: 'Goal Type',
                        value: selectedGoalType,
                        items: [
                          'Weight Loss',
                          'Muscle Gain',
                          'Endurance',
                          'Maintenance',
                          'Flexibility',
                        ],
                        onChanged: (value) {
                          setState(() {
                            selectedGoalType = value;
                          });
                        },
                      ),
                      // Difficulty Dropdown
                      _buildDropdown(
                        hint: 'Difficulty',
                        value: selectedDifficulty,
                        items: ['Easy', 'Intermediate', 'Hard'],
                        onChanged: (value) {
                          setState(() {
                            selectedDifficulty = value;
                          });
                        },
                      ),
                      // Clear Icon
                      IconButton(
                        icon: const Icon(Icons.clear,
                            color: CustomColors.secondary),
                        onPressed: () {
                          setState(() {
                            selectedFitnessLevel = null;
                            selectedGoalType = null;
                            selectedDifficulty = null;
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                        tooltip: 'Clear Filters',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: ListView.separated(
                    itemCount: filteredWorkouts.length,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.grey, // Divider color
                        thickness: 0.5, // Divider thickness
                        indent: 16, // Indent for left margin
                        endIndent: 16, // Indent for right margin
                      );
                    },
                    itemBuilder: (context, index) {
                      final workout = filteredWorkouts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0, // Slight elevation for better depth
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              workout.workoutImage.isNotEmpty
                                  ? workout.workoutImage
                                  : 'https://via.placeholder.com/70',
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            workout.workoutName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            '${workout.targetMuscleGroup} • ${workout.fitnessLevel}',
                            style: const TextStyle(
                              color: CustomColors.lightText,
                              fontSize: 14,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: CustomColors.black,
                            size: 20,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetailScreen(
                                  workoutId: workout.workoutId,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      hint: Text(hint),
      value: value,
      onChanged: onChanged,
      underline: const SizedBox(),
      style: const TextStyle(fontSize: 14, color: Colors.black),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }
}
