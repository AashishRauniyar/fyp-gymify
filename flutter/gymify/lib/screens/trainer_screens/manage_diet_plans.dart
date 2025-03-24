// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:gymify/screens/diet_screens/create_diet_plan_screen.dart';
// import 'package:gymify/screens/diet_screens/create_meal_screen.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/providers/diet_provider/diet_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:go_router/go_router.dart';

// class ManageDietPlans extends StatefulWidget {
//   const ManageDietPlans({super.key});

//   @override
//   State<ManageDietPlans> createState() => _ManageDietPlansState();
// }

// class _ManageDietPlansState extends State<ManageDietPlans> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch the diet plans when the page is loaded.
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       appBar: const CustomAppBar(title: "Diet Plans"),
//       body: Consumer<DietProvider>(
//         builder: (context, dietProvider, child) {
//           if (dietProvider.isLoading) {
//             return const Center(child: CustomLoadingAnimation());
//           }

//           if (dietProvider.hasError) {
//             return Center(
//               child: Text(
//                 "Error loading diet plans.",
//                 style: theme.textTheme.headlineSmall
//                     ?.copyWith(color: theme.colorScheme.error),
//               ),
//             );
//           }

//           if (dietProvider.diets.isEmpty) {
//             return Center(
//               child: Text(
//                 "No diet plans available.",
//                 style: theme.textTheme.headlineSmall,
//               ),
//             );
//           }

//           return ListView.separated(
//             itemCount: dietProvider.diets.length,
//             separatorBuilder: (context, index) => Divider(
//               color: theme.colorScheme.onSurface.withOpacity(0.2),
//               thickness: 0.5,
//               indent: 16,
//               endIndent: 16,
//             ),
//             itemBuilder: (context, index) {
//               final diet = dietProvider.diets[index];
//               return Container(
//                 margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.surface,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: theme.colorScheme.onSurface.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Diet Plan Image
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(16),
//                       // child: Image.network(
//                       //   diet.image.isNotEmpty
//                       //       ? diet.image
//                       //       : 'https://via.placeholder.com/150', // Placeholder for missing image
//                       //   width: 90,
//                       //   height: 90,
//                       //   fit: BoxFit.cover,
//                       // ),
//                       child: CachedNetworkImage(
//                         imageUrl: diet.image.isNotEmpty
//                             ? diet.image
//                             : 'https://via.placeholder.com/150', // Placeholder for missing image
//                         width: 90,
//                         height: 90,
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                     const SizedBox(width: 12),

//                     // Diet Plan Details (Name + Calorie Goal)
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             diet.name,
//                             style: theme.textTheme.bodyLarge?.copyWith(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             "${diet.calorieGoal} kcal • ${diet.goalType}",
//                             style: theme.textTheme.bodySmall?.copyWith(
//                               color:
//                                   theme.colorScheme.onSurface.withOpacity(0.6),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     // Edit Icon
//                     IconButton(
//                       icon: const Icon(Icons.edit),
//                       onPressed: () {
//                         // Navigate to the Diet Plan Detail/Edit screen
//                         context.pushNamed(
//                           'dietDetail',
//                           extra: diet, // Passing the diet plan as extra
//                         );
//                       },
//                     ),

//                     // Add Meal Icon
//                     IconButton(
//                       icon: const Icon(Icons.add),
//                       onPressed: () {
//                         // Navigate to the Create Meal screen
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                             builder: (context) =>
//                                 CreateMealScreen(dietPlanId: diet.dietPlanId),
//                           ),
//                         );
//                       },
//                     ),
//                     const SizedBox(width: 12),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Navigate to the Create Diet Plan screen.
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (context) => const CreateDietPlanScreen(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gymify/screens/diet_screens/create_diet_plan_screen.dart';
import 'package:gymify/screens/diet_screens/create_meal_screen.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:go_router/go_router.dart';

class ManageDietPlans extends StatefulWidget {
  const ManageDietPlans({super.key});

  @override
  State<ManageDietPlans> createState() => _ManageDietPlansState();
}

class _ManageDietPlansState extends State<ManageDietPlans> {
  @override
  void initState() {
    super.initState();
    // Fetch the diet plans when the page is loaded.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
    });
  }

  // method to fetch data initially

  Future<void> _showDeleteConfirmationDialog(int dietId) async {
    final theme = Theme.of(context);

    bool? deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Confirm Deletion",
            style: theme.textTheme.titleLarge,
          ),
          content: Text(
            "Are you sure you want to delete this diet plan?",
            style: theme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                "Cancel",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                "Delete",
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
          ],
        );
      },
    );

    // If delete is confirmed, delete the diet plan
    if (deleteConfirmed == true) {
      await Provider.of<DietProvider>(context, listen: false)
          .deleteDietPlan(dietId);
      showCoolSnackBar(context, "Diet Deleted Successfully", true);
      Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CustomAppBar(title: "Manage Diet Plans"),
      body: Consumer<DietProvider>(
        builder: (context, dietProvider, child) {
          if (dietProvider.isLoading) {
            return const Center(child: CustomLoadingAnimation());
          }

          if (dietProvider.hasError) {
            return Center(
              child: Text(
                "Error loading diet plans.",
                style: theme.textTheme.headlineSmall
                    ?.copyWith(color: theme.colorScheme.error),
              ),
            );
          }

          if (dietProvider.diets.isEmpty) {
            return Center(
              child: Text(
                "No diet plans available.",
                style: theme.textTheme.headlineSmall,
              ),
            );
          }

          return ListView.separated(
            itemCount: dietProvider.diets.length,
            separatorBuilder: (context, index) => Divider(
              color: theme.colorScheme.onSurface.withOpacity(0.2),
              thickness: 0.5,
              indent: 16,
              endIndent: 16,
            ),
            itemBuilder: (context, index) {
              final diet = dietProvider.diets[index];
              return Slidable(
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (context) {
                      _showDeleteConfirmationDialog(diet.dietPlanId);
                    },
                    borderRadius: BorderRadius.circular(16),
                    icon: Icons.delete,
                    label: 'Delete',
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ]),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: CachedNetworkImage(
                          imageUrl: diet.image.isNotEmpty
                              ? diet.image
                              : 'https://via.placeholder.com/150',
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              diet.name,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${diet.calorieGoal} kcal • ${diet.goalType}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.pushNamed(
                            'dietDetail',
                            extra: diet,
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  CreateMealScreen(dietPlanId: diet.dietPlanId),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CreateDietPlanScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
