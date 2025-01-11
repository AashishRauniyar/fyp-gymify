// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';

// class AllWorkouts extends StatefulWidget {
//   const AllWorkouts({super.key});

//   @override
//   _AllWorkoutsState createState() => _AllWorkoutsState();
// }

// class _AllWorkoutsState extends State<AllWorkouts> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';

//   String? selectedFitnessLevel;
//   String? selectedGoalType;
//   String? selectedDifficulty;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'All Workouts',
//           style: theme.textTheme.headlineSmall?.copyWith(
//             color: theme.colorScheme.onSurface,
//           ),
//         ),
//         backgroundColor: theme.colorScheme.surface,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new_sharp,
//               color: theme.colorScheme.primary),
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
//               return Center(
//                 child: CircularProgressIndicator(
//                   color: theme.colorScheme.primary,
//                 ),
//               );
//             }

//             if (workoutProvider.workouts.isEmpty) {
//               return Center(
//                 child: Text(
//                   'No workouts found.',
//                   style: theme.textTheme.bodyLarge,
//                 ),
//               );
//             }

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
//                       fillColor: theme.colorScheme.surface,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       hintStyle: theme.textTheme.bodyMedium?.copyWith(
//                         color: theme.colorScheme.onSurface.withOpacity(0.5),
//                       ),
//                     ),
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                 ),

//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       // Fitness Level Dropdown
//                       _buildDropdown(
//                         hint: 'Fitness Level',
//                         value: selectedFitnessLevel,
//                         items: [
//                           'Beginner',
//                           'Intermediate',
//                           'Advanced',
//                           'Athlete',
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             selectedFitnessLevel = value;
//                           });
//                         },
//                       ),
//                       // Goal Type Dropdown
//                       _buildDropdown(
//                         hint: 'Goal Type',
//                         value: selectedGoalType,
//                         items: [
//                           'Weight Loss',
//                           'Muscle Gain',
//                           'Endurance',
//                           'Maintenance',
//                           'Flexibility',
//                         ],
//                         onChanged: (value) {
//                           setState(() {
//                             selectedGoalType = value;
//                           });
//                         },
//                       ),
//                       // Difficulty Dropdown
//                       _buildDropdown(
//                         hint: 'Difficulty',
//                         value: selectedDifficulty,
//                         items: ['Easy', 'Intermediate', 'Hard'],
//                         onChanged: (value) {
//                           setState(() {
//                             selectedDifficulty = value;
//                           });
//                         },
//                       ),
//                       // Clear Icon
//                       IconButton(
//                         icon: Icon(Icons.clear, color: theme.colorScheme.error),
//                         onPressed: () {
//                           setState(() {
//                             selectedFitnessLevel = null;
//                             selectedGoalType = null;
//                             selectedDifficulty = null;
//                             _searchController.clear();
//                             _searchQuery = '';
//                           });
//                         },
//                         tooltip: 'Clear Filters',
//                       ),
//                     ],
//                   ),
//                 ),

//                 const SizedBox(height: 10),

//                 Expanded(
//                   child: ListView.separated(
//                     itemCount: filteredWorkouts.length,
//                     separatorBuilder: (context, index) {
//                       return Divider(
//                         color: theme.colorScheme.onSurface.withOpacity(0.2),
//                         thickness: 0.5,
//                         indent: 16,
//                         endIndent: 16,
//                       );
//                     },
//                     itemBuilder: (context, index) {
//                       final workout = filteredWorkouts[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 2, horizontal: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         elevation: 0,
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.all(12),
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.network(
//                               workout.workoutImage.isNotEmpty
//                                   ? workout.workoutImage
//                                   : 'https://via.placeholder.com/70',
//                               width: 70,
//                               height: 70,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                           title: Text(
//                             workout.workoutName,
//                             style: theme.textTheme.bodyLarge?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           subtitle: Text(
//                             '${workout.targetMuscleGroup} • ${workout.fitnessLevel}',
//                             style: theme.textTheme.bodySmall?.copyWith(
//                               color:
//                                   theme.colorScheme.onSurface.withOpacity(0.6),
//                             ),
//                           ),
//                           trailing: Icon(
//                             Icons.arrow_forward_ios,
//                             color: theme.colorScheme.primary,
//                             size: 20,
//                           ),
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => WorkoutDetailScreen(
//                                   workoutId: workout.workoutId,
//                                 ),
//                               ),
//                             );
//                           },
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

//   Widget _buildDropdown({
//     required String hint,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     final theme = Theme.of(context);
//     return DropdownButton<String>(
//       hint: Text(hint, style: theme.textTheme.bodySmall),
//       value: value,
//       onChanged: onChanged,
//       underline: const SizedBox(),
//       style: theme.textTheme.bodySmall
//           ?.copyWith(color: theme.colorScheme.onSurface),
//       items: items.map((item) {
//         return DropdownMenuItem(
//           value: item,
//           child: Text(item, style: theme.textTheme.bodySmall),
//         );
//       }).toList(),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';

class AllWorkouts extends StatefulWidget {
  const AllWorkouts({super.key});

  @override
  State<AllWorkouts> createState() => _AllWorkoutsState();
}

class _AllWorkoutsState extends State<AllWorkouts>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? selectedFitnessLevel;
  String? selectedGoalType;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Workouts",
          style: theme.textTheme.headlineSmall,
        ),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
            onPressed: () => _openFilterDrawer(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
          indicatorColor: theme.colorScheme.primary,
          tabs: const [
            Tab(text: "Easy"),
            Tab(text: "Intermediate"),
            Tab(text: "Hard"),
          ],
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
              return _buildEmptyState(theme);
            }

            final filteredWorkouts =
                _getFilteredWorkouts(workoutProvider.workouts);

            return Column(
              children: [
                _buildSearchBar(theme),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildWorkoutList(filteredWorkouts, "Easy", theme),
                      _buildWorkoutList(
                          filteredWorkouts, "Intermediate", theme),
                      _buildWorkoutList(filteredWorkouts, "Hard", theme),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          fillColor: theme.colorScheme.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutList(List workouts, String difficulty, ThemeData theme) {
    final filteredByDifficulty =
        workouts.where((workout) => workout.difficulty == difficulty).toList();

    if (filteredByDifficulty.isEmpty) {
      return Center(
        child: Text(
          "No $difficulty workouts available.",
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredByDifficulty.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: theme.colorScheme.onSurface.withOpacity(0.2),
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        );
      },
      itemBuilder: (context, index) {
        final workout = filteredByDifficulty[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
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
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${workout.targetMuscleGroup} • ${workout.fitnessLevel}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.primary,
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
    );
  }

  List _getFilteredWorkouts(List workouts) {
    return workouts.where((workout) {
      final matchesSearch =
          workout.workoutName.toLowerCase().contains(_searchQuery);
      final matchesFitnessLevel = selectedFitnessLevel == null ||
          workout.fitnessLevel == selectedFitnessLevel;
      final matchesGoalType =
          selectedGoalType == null || workout.goalType == selectedGoalType;
      return matchesSearch && matchesFitnessLevel && matchesGoalType;
    }).toList();
  }

  void _openFilterDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildFilterDrawer(context),
    );
  }

  Widget _buildFilterDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDropdown(
            hint: "Fitness Level",
            value: selectedFitnessLevel,
            items: ['Beginner', 'Intermediate', 'Advanced', 'Athlete'],
            onChanged: (value) {
              setState(() {
                selectedFitnessLevel = value;
              });
            },
            theme: theme,
          ),
          _buildDropdown(
            hint: "Goal Type",
            value: selectedGoalType,
            items: ['Weight Loss', 'Muscle Gain', 'Endurance', 'Maintenance'],
            onChanged: (value) {
              setState(() {
                selectedGoalType = value;
              });
            },
            theme: theme,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  _resetFilters();
                  Navigator.pop(context);
                },
                child: Text(
                  "Reset Filters",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.error,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Apply Filters"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required ThemeData theme,
  }) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      decoration: InputDecoration(
        fillColor: theme.colorScheme.surface,
        filled: true,
        labelText: hint,
        labelStyle: theme.textTheme.bodyMedium,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: value,
      onChanged: onChanged,
      items: items
          .map((item) => DropdownMenuItem(
              value: item,
              child: Text(item, style: theme.textTheme.bodyMedium)))
          .toList(),
    );
  }

  void _resetFilters() {
    setState(() {
      selectedFitnessLevel = null;
      selectedGoalType = null;
      _searchController.clear();
      _searchQuery = '';
    });
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            "No workouts found.",
            style: theme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 10),
          Text(
            "Try adjusting your filters or search query.",
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/screens/main_screens/workout_screens/workout_details_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/workout_provider/workout_provider.dart';

// class AllWorkouts extends StatefulWidget {
//   const AllWorkouts({super.key});

//   @override
//   State<AllWorkouts> createState() => _AllWorkoutsState();
// }

// class _AllWorkoutsState extends State<AllWorkouts> {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   String? selectedFitnessLevel;
//   String? selectedGoalType;
//   String? selectedDifficulty;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("All Workouts"),
//         backgroundColor: theme.colorScheme.surface,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.filter_list),
//             onPressed: () => _openFilterDrawer(context),
//           ),
//         ],
//       ),
//       body: ChangeNotifierProvider(
//         create: (_) => WorkoutProvider()..fetchAllWorkouts(),
//         child: Consumer<WorkoutProvider>(
//           builder: (context, workoutProvider, child) {
//             if (workoutProvider.isLoading) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (workoutProvider.workouts.isEmpty) {
//               return _buildEmptyState(theme);
//             }

//             final filteredWorkouts =
//                 _getFilteredWorkouts(workoutProvider.workouts);

//             return Column(
//               children: [
//                 _buildSearchBar(),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: GridView.builder(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 2,
//                       crossAxisSpacing: 16, // Increased spacing
//                       mainAxisSpacing: 16, // Increased spacing
//                       childAspectRatio:
//                           0.75, // Adjusted aspect ratio for better fit
//                     ),
//                     itemCount: filteredWorkouts.length,
//                     itemBuilder: (context, index) {
//                       final workout = filteredWorkouts[index];
//                       return _buildWorkoutCard(workout, theme);
//                     },
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _resetFilters();
//         },
//         backgroundColor: theme.colorScheme.primary,
//         child: const Icon(Icons.refresh),
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//       child: TextField(
//         controller: _searchController,
//         onChanged: (value) {
//           setState(() {
//             _searchQuery = value.toLowerCase();
//           });
//         },
//         decoration: InputDecoration(
//           hintText: 'Search Workouts...',
//           prefixIcon: const Icon(Icons.search),
//           filled: true,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildWorkoutCard(workout, ThemeData theme) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 2,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Workout Image
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
//             child: Image.network(
//               workout.workoutImage.isNotEmpty
//                   ? workout.workoutImage
//                   : 'https://via.placeholder.com/150',
//               height: 120, // Adjust the height to avoid overflow
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),

//           // Workout Name and Details
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   workout.workoutName,
//                   style: theme.textTheme.headlineSmall,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${workout.targetMuscleGroup} • ${workout.difficulty}',
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.secondary,
//                   ),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),

//           // Button Section
//           const Spacer(), // Ensure spacing for the button
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => WorkoutDetailScreen(
//                       workoutId: workout.workoutId,
//                     ),
//                   ),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(20), // Adjust height
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               child: const Text("Details"),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List _getFilteredWorkouts(List workouts) {
//     return workouts.where((workout) {
//       final matchesSearch =
//           workout.workoutName.toLowerCase().contains(_searchQuery);
//       final matchesFitnessLevel = selectedFitnessLevel == null ||
//           workout.fitnessLevel == selectedFitnessLevel;
//       final matchesGoalType =
//           selectedGoalType == null || workout.goalType == selectedGoalType;
//       final matchesDifficulty = selectedDifficulty == null ||
//           workout.difficulty == selectedDifficulty;
//       return matchesSearch &&
//           matchesFitnessLevel &&
//           matchesGoalType &&
//           matchesDifficulty;
//     }).toList();
//   }

//   void _openFilterDrawer(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => _buildFilterDrawer(context),
//     );
//   }

//   Widget _buildFilterDrawer(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildDropdown(
//             hint: "Fitness Level",
//             value: selectedFitnessLevel,
//             items: ['Beginner', 'Intermediate', 'Advanced', 'Athlete'],
//             onChanged: (value) {
//               setState(() {
//                 selectedFitnessLevel = value;
//               });
//             },
//           ),
//           _buildDropdown(
//             hint: "Goal Type",
//             value: selectedGoalType,
//             items: ['Weight Loss', 'Muscle Gain', 'Endurance', 'Maintenance'],
//             onChanged: (value) {
//               setState(() {
//                 selectedGoalType = value;
//               });
//             },
//           ),
//           _buildDropdown(
//             hint: "Difficulty",
//             value: selectedDifficulty,
//             items: ['Easy', 'Intermediate', 'Hard'],
//             onChanged: (value) {
//               setState(() {
//                 selectedDifficulty = value;
//               });
//             },
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             child: const Text("Apply Filters"),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildDropdown({
//     required String hint,
//     required String? value,
//     required List<String> items,
//     required ValueChanged<String?> onChanged,
//   }) {
//     return DropdownButton<String>(
//       isExpanded: true,
//       hint: Text(hint),
//       value: value,
//       onChanged: onChanged,
//       items: items
//           .map((item) => DropdownMenuItem(value: item, child: Text(item)))
//           .toList(),
//     );
//   }

//   void _resetFilters() {
//     setState(() {
//       selectedFitnessLevel = null;
//       selectedGoalType = null;
//       selectedDifficulty = null;
//       _searchController.clear();
//       _searchQuery = '';
//     });
//   }

//   Widget _buildEmptyState(ThemeData theme) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const Icon(Icons.search_off, size: 80, color: Colors.grey),
//           const SizedBox(height: 20),
//           Text(
//             "No workouts found.",
//             style: theme.textTheme.headlineSmall,
//           ),
//           const SizedBox(height: 10),
//           Text(
//             "Try adjusting your filters or search query.",
//             style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
//           ),
//         ],
//       ),
//     );
//   }
// }
