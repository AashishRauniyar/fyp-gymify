import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Workouts'),
      ),
      body: ChangeNotifierProvider(
        create: (_) => CustomWorkoutProvider()..fetchCustomWorkouts(),
        child: Consumer<CustomWorkoutProvider>(
          builder: (context, customWorkoutProvider, child) {
            if (customWorkoutProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (customWorkoutProvider.customWorkouts.isEmpty) {
              return const Center(child: Text('No custom workouts found.'));
            }

            // Filter workouts based on the search query
            final filteredWorkouts =
                customWorkoutProvider.customWorkouts.where((workout) {
              return workout.customWorkoutName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
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
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search Custom Workouts...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),

                // Custom Workout List
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = filteredWorkouts[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomWorkoutDetailScreen(
                                    customWorkoutId: workout.customWorkoutId),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(
                              workout.customWorkoutName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                                'Created on: ${workout.createdAt.toLocal()}'),
                          ),
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
}
