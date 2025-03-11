// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/models/exercise_model.dart';
// import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
// import 'package:gymify/screens/exercise_screens/exercise_detail_screen.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';

// class ExerciseScreen extends StatefulWidget {
//   const ExerciseScreen({super.key});

//   @override
//   State<ExerciseScreen> createState() => _ExerciseScreenState();
// }

// class _ExerciseScreenState extends State<ExerciseScreen> {
//   final TextEditingController _searchController = TextEditingController();
//   List<Exercise> _filteredExercises = [];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<ExerciseProvider>().fetchAllExercises();
//     });
//     _searchController.addListener(_filterExercises);
//   }

//   void _filterExercises() {
//     final query = _searchController.text.toLowerCase();
//     setState(() {
//       _filteredExercises = context
//           .read<ExerciseProvider>()
//           .exercises
//           .where(
//               (exercise) => exercise.exerciseName.toLowerCase().contains(query))
//           .toList();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: CustomAppBar(
//         title: "Exercises",
//         showBackButton: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: () {
//               context.read<ExerciseProvider>().fetchAllExercises();
//             },
//           ),
//         ],
//       ),
//       body: Consumer<ExerciseProvider>(
//         builder: (context, exerciseProvider, child) {
//           if (exerciseProvider.exercises.isEmpty) {
//             return _buildShimmerLoading();
//           }

//           final exercisesToDisplay = _filteredExercises.isEmpty
//               ? exerciseProvider.exercises
//               : _filteredExercises;

//           return Column(
//             children: [
//               _buildSearchBar(),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: exercisesToDisplay.length,
//                   itemBuilder: (context, index) {
//                     final exercise = exercisesToDisplay[index];
//                     return ExerciseTile(exercise: exercise);
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
//       child: TextField(
//         controller: _searchController,
//         decoration: InputDecoration(
//           labelText: 'Search Exercises',
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//             borderSide: BorderSide(color: Colors.grey[400]!),
//           ),
//           prefixIcon: const Icon(Icons.search),
//         ),
//       ),
//     );
//   }

//   Widget _buildShimmerLoading() {
//     return ListView.builder(
//       itemCount: 5, // Show 5 loading placeholders
//       itemBuilder: (context, index) {
//         return Shimmer.fromColors(
//           baseColor: Colors.grey[300]!,
//           highlightColor: Colors.grey[100]!,
//           child: const ExerciseTileShimmer(),
//         );
//       },
//     );
//   }
// }

// class ExerciseTileShimmer extends StatelessWidget {
//   const ExerciseTileShimmer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//         decoration: BoxDecoration(
//           color: Colors.grey[200],
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: Colors.grey.withOpacity(0.1),
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Shimmer loading for image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Container(
//                 width: 90,
//                 height: 90,
//                 color: Colors.grey[300],
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Shimmer loading for text
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 16,
//                     color: Colors.grey[300],
//                   ),
//                   const SizedBox(height: 4),
//                   Container(
//                     width: 80,
//                     height: 14,
//                     color: Colors.grey[300],
//                   ),
//                 ],
//               ),
//             ),

//             // Shimmer loading for icon
//             const SizedBox(width: 12),
//             Container(
//               width: 22,
//               height: 22,
//               color: Colors.grey[300],
//             ),
//             const SizedBox(width: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ExerciseTile extends StatelessWidget {
//   final Exercise exercise;

//   const ExerciseTile({super.key, required this.exercise});

//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     final theme = Theme.of(context);

//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ExerciseDetailScreen(exercise: exercise),
//           ),
//         );
//       },
//       child: Container(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//         decoration: BoxDecoration(
//           color: isDarkMode
//               ? theme.colorScheme.surface
//               : theme.colorScheme.surface,
//           borderRadius: BorderRadius.circular(16),
//           border: Border.all(
//             color: isDarkMode
//                 ? theme.colorScheme.onSurface.withOpacity(0.1)
//                 : theme.colorScheme.onSurface.withOpacity(0.1),
//             width: 1.5,
//           ),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Exercise Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Image.network(
//                 exercise.imageUrl.isNotEmpty
//                     ? exercise.imageUrl
//                     : 'https://via.placeholder.com/150', // Placeholder for missing image
//                 width: 90,
//                 height: 90,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(width: 12),

//             // Exercise Details (Title + Target Muscle Group)
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     exercise.exerciseName,
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     "Target: ${exercise.targetMuscleGroup}",
//                     style: GoogleFonts.poppins(
//                       fontSize: 14,
//                       color: isDarkMode
//                           ? Colors.white.withOpacity(0.6)
//                           : Colors.black.withOpacity(0.6),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Icon for Visual Accent
//             Icon(
//               FontAwesomeIcons.clone, // Icon related to exercise
//               color: theme
//                   .colorScheme.primary, // Change to your custom primary color
//               size: 22,
//             ),
//             const SizedBox(width: 12),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/screens/exercise_screens/exercise_detail_screen.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  State<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Exercise> _filteredExercises = [];
  String _selectedMuscleGroup = 'All';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ExerciseProvider>().fetchAllExercises();
    });
    _searchController.addListener(_filterExercises);
  }

  void _filterExercises() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredExercises = context
          .read<ExerciseProvider>()
          .exercises
          .where(
              (exercise) => exercise.exerciseName.toLowerCase().contains(query))
          .toList();
    });
  }

  void _sortExercises() {
    setState(() {
      if (_selectedMuscleGroup == 'All') {
        // Sort exercises by muscle group alphabetically
        context
            .read<ExerciseProvider>()
            .exercises
            .sort((a, b) => a.targetMuscleGroup.compareTo(b.targetMuscleGroup));
      } else {
        // Filter exercises by the selected muscle group
        _filteredExercises = context
            .read<ExerciseProvider>()
            .exercises
            .where((exercise) =>
                exercise.targetMuscleGroup == _selectedMuscleGroup)
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: "Exercises",
        showBackButton: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<ExerciseProvider>().fetchAllExercises();
            },
          ),
        ],
      ),
      body: Consumer<ExerciseProvider>(
        builder: (context, exerciseProvider, child) {
          if (exerciseProvider.exercises.isEmpty) {
            return _buildShimmerLoading();
          }

          final exercisesToDisplay = _filteredExercises.isEmpty
              ? exerciseProvider.exercises
              : _filteredExercises;

          return Column(
            children: [
              _buildSearchBar(),
              _buildSortDropdown(),
              Expanded(
                child: ListView.builder(
                  itemCount: exercisesToDisplay.length,
                  itemBuilder: (context, index) {
                    final exercise = exercisesToDisplay[index];
                    return ExerciseTile(exercise: exercise);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          labelText: 'Search Exercises',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey[400]!),
          ),
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: const InputDecoration(labelText: 'Sort by Muscle Group'),
        value: _selectedMuscleGroup,
        onChanged: (value) {
          setState(() {
            _selectedMuscleGroup = value!;
          });
          _sortExercises();
        },
        items: [
          'All',
          'Chest',
          'Back',
          'Arms',
          'Legs',
          'Core',
          'Shoulders',
          'Glutes',
          'Full Body'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      itemCount: 5, // Show 5 loading placeholders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: const ExerciseTileShimmer(),
        );
      },
    );
  }
}

class ExerciseTileShimmer extends StatelessWidget {
  const ExerciseTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.grey.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Shimmer loading for image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 90,
                height: 90,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(width: 12),

            // Shimmer loading for text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 100,
                    height: 16,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 80,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                ],
              ),
            ),

            // Shimmer loading for icon
            const SizedBox(width: 12),
            Container(
              width: 22,
              height: 22,
              color: Colors.grey[300],
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final Exercise exercise;

  const ExerciseTile({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExerciseDetailScreen(exercise: exercise),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
        decoration: BoxDecoration(
          color: isDarkMode
              ? theme.colorScheme.surface
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDarkMode
                ? theme.colorScheme.onSurface.withOpacity(0.1)
                : theme.colorScheme.onSurface.withOpacity(0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Exercise Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                exercise.imageUrl.isNotEmpty
                    ? exercise.imageUrl
                    : 'https://via.placeholder.com/150', // Placeholder for missing image
                width: 90,
                height: 90,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            // Exercise Details (Title + Target Muscle Group)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.exerciseName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Target: ${exercise.targetMuscleGroup}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: isDarkMode
                          ? Colors.white.withOpacity(0.6)
                          : Colors.black.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // Icon for Visual Accent
            Icon(
              FontAwesomeIcons.clone, // Icon related to exercise
              color: theme
                  .colorScheme.primary, // Change to your custom primary color
              size: 22,
            ),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}
