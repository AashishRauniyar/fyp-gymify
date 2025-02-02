// import 'package:flutter/material.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/providers/diet_provider/diet_provider.dart';
// import 'package:provider/provider.dart';

// class DietScreen extends StatefulWidget {
//   const DietScreen({super.key});

//   @override
//   State<DietScreen> createState() => _DietScreenState();
// }

// class _DietScreenState extends State<DietScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: CustomColors.backgroundColor,
//       appBar: AppBar(
//         toolbarHeight: 80,
//         backgroundColor: CustomColors.backgroundColor,
//         title: const Text(
//           'Diet',
//           style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: CustomColors.secondary),
//         ),
//       ),
//       body: Text("this is the diet screen"),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:gymify/colors/custom_colors.dart';
// import 'package:gymify/providers/diet_provider/diet_provider.dart';
// import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart';
// import 'package:gymify/colors/app_colors.dart'; // Make sure to import your colors and theme.

// class DietScreen extends StatefulWidget {
//   const DietScreen({super.key});

//   @override
//   State<DietScreen> createState() => _DietScreenState();
// }

// class _DietScreenState extends State<DietScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Accessing the DietProvider for fetching data
//     final dietProvider = Provider.of<DietProvider>(context);

//     return Scaffold(
//       backgroundColor: CustomColors.backgroundColor,
//       appBar: AppBar(
//         toolbarHeight: 80,
//         backgroundColor: CustomColors.backgroundColor,
//         title: const Text(
//           'Diet Plans',
//           style: TextStyle(
//               fontSize: 32,
//               fontWeight: FontWeight.bold,
//               color: CustomColors.secondary),
//         ),
//       ),
//       body: dietProvider.isLoading
//           ? const Center(
//               child: CustomLoadingAnimation()) // Show loading indicator
//           : dietProvider.hasError
//               ? const Center(
//                   child: Text('Failed to load diet plans')) // Error state
//               : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: ListView.builder(
//                     itemCount: dietProvider.diets.length,
//                     itemBuilder: (context, index) {
//                       final dietPlan = dietProvider.diets[index];
//                       return DietCard(dietPlan: dietPlan);
//                     },
//                   ),
//                 ),
//     );
//   }
// }

// class DietCard extends StatelessWidget {
//   final DietPlan dietPlan;

//   const DietCard({super.key, required this.dietPlan});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       color: AppColors.lightSurface,
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               dietPlan.name,
//               style: Theme.of(context).textTheme.headlineMedium?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: AppColors.darkPrimary,
//                   ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'Calorie Goal: ${dietPlan.calorieGoal} kcal',
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: AppColors.onsi.withOpacity(0.7),
//                   ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               'Goal Type: ${dietPlan.goalType}',
//               style: Theme.of(context).textTheme.bodyLarge?.copyWith(
//                     color: AppColors.darkOnSurface.withOpacity(0.7),
//                   ),
//             ),
//             const SizedBox(height: 8),
//             Text(
//               dietPlan.description,
//               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                     color: AppColors.darkOnSurface.withOpacity(0.6),
//                   ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     // You can navigate to the meal details or diet plan detail screen
//                     // Example:
//                     // Navigator.pushNamed(context, '/diet-plan-details', arguments: dietPlan);
//                   },
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 12, horizontal: 28),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   child: Text(
//                     'View Details',
//                     style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                           color: AppColors.lightOnPrimary,
//                         ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:gymify/providers/diet_provider/diet_provider.dart';
// import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:provider/provider.dart'; // Make sure to import your colors and theme.

// class DietScreen extends StatefulWidget {
//   const DietScreen({super.key});

//   @override
//   State<DietScreen> createState() => _DietScreenState();
// }

// class _DietScreenState extends State<DietScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _searchController = TextEditingController();
//   String _searchQuery = '';
//   String? selectedGoalType; // Holds the selected goal type filter
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: true,
//         title: Text(
//           "Diet Plans",
//           style: theme.textTheme.headlineSmall,
//         ),
//         backgroundColor: theme.colorScheme.surface,
//         elevation: 0,
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list, color: theme.colorScheme.primary),
//             onPressed: () => _openFilterDrawer(context),
//           ),
//         ],
//         bottom: TabBar(
//           controller: _tabController,
//           labelColor: theme.colorScheme.primary,
//           unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
//           indicatorColor: theme.colorScheme.primary,
//           tabs: const [
//             Tab(text: "Weight Loss"),
//             Tab(text: "Muscle Gain"),
//             Tab(text: "Maintenance"),
//           ],
//         ),
//       ),
//       body: ChangeNotifierProvider(
//         create: (_) => DietProvider()..fetchAllDietPlans(),
//         child: Consumer<DietProvider>(
//           builder: (context, dietProvider, child) {
//             if (dietProvider.isLoading) {
//               return const Center(child: CustomLoadingAnimation());
//             }

//             if (dietProvider.hasError) {
//               return _buildErrorState(theme);
//             }

//             if (dietProvider.diets.isEmpty) {
//               return _buildEmptyState(theme);
//             }

//             final filteredDietPlans = _getFilteredDietPlans(dietProvider.diets);

//             return Column(
//               children: [
//                 _buildSearchBar(theme),
//                 const SizedBox(height: 10),
//                 Expanded(
//                   child: TabBarView(
//                     controller: _tabController,
//                     children: [
//                       _buildDietPlanList(
//                           filteredDietPlans, "Weight_Loss", theme),
//                       _buildDietPlanList(
//                           filteredDietPlans, "Muscle_Gain", theme),
//                       _buildDietPlanList(
//                           filteredDietPlans, "Maintenance", theme),
//                     ],
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchBar(ThemeData theme) {
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
//           hintText: 'Search Diet Plans...',
//           prefixIcon: const Icon(Icons.search),
//           filled: true,
//           fillColor: theme.colorScheme.surface,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(12),
//             borderSide: BorderSide.none,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDietPlanList(
//       List<DietPlan> dietPlans, String goalType, ThemeData theme) {
//     final filteredByGoalType =
//         dietPlans.where((dietPlan) => dietPlan.goalType == goalType).toList();

//     if (filteredByGoalType.isEmpty) {
//       return Center(
//         child: Text(
//           "No $goalType diet plans available.",
//           style: theme.textTheme.bodyMedium
//               ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
//         ),
//       );
//     }

//     return ListView.separated(
//       itemCount: filteredByGoalType.length,
//       separatorBuilder: (context, index) {
//         return Divider(
//           color: theme.colorScheme.onSurface.withOpacity(0.2),
//           thickness: 0.5,
//           indent: 16,
//           endIndent: 16,
//         );
//       },
//       itemBuilder: (context, index) {
//         final dietPlan = filteredByGoalType[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           elevation: 0,
//           child: ListTile(
//             contentPadding: const EdgeInsets.all(12),
//             title: Text(
//               dietPlan.name,
//               style: theme.textTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Text(
//               '${dietPlan.calorieGoal} kcal • ${dietPlan.goalType}',
//               style: theme.textTheme.bodySmall?.copyWith(
//                 color: theme.colorScheme.onSurface.withOpacity(0.6),
//               ),
//             ),
//             trailing: Icon(
//               Icons.arrow_forward_ios,
//               color: theme.colorScheme.primary,
//               size: 20,
//             ),
//             onTap: () {
//               Navigator.pushNamed(context, '/diet-plan-details',
//                   arguments: dietPlan);
//             },
//           ),
//         );
//       },
//     );
//   }

//   List<DietPlan> _getFilteredDietPlans(List<DietPlan> dietPlans) {
//     return dietPlans.where((dietPlan) {
//       final matchesSearch = dietPlan.name.toLowerCase().contains(_searchQuery);
//       final matchesGoalType =
//           selectedGoalType == null || dietPlan.goalType == selectedGoalType;
//       return matchesSearch && matchesGoalType;
//     }).toList();
//   }

//   void _openFilterDrawer(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => _buildFilterDrawer(context),
//     );
//   }

//   Widget _buildFilterDrawer(BuildContext context) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           _buildDropdown(
//             hint: "Goal Type",
//             value: selectedGoalType,
//             items: ['Weight_Loss', 'Muscle_Gain', 'Maintenance'],
//             onChanged: (value) {
//               setState(() {
//                 selectedGoalType = value;
//               });
//             },
//             theme: theme,
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   _resetFilters();
//                   Navigator.pop(context);
//                 },
//                 child: Text(
//                   "Reset Filters",
//                   style: theme.textTheme.bodyMedium?.copyWith(
//                     color: theme.colorScheme.error,
//                   ),
//                 ),
//               ),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: theme.colorScheme.primary,
//                 ),
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 child: const Text("Apply Filters"),
//               ),
//             ],
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
//     required ThemeData theme,
//   }) {
//     return DropdownButtonFormField<String>(
//       isExpanded: true,
//       decoration: InputDecoration(
//         fillColor: theme.colorScheme.surface,
//         filled: true,
//         labelText: hint,
//         labelStyle: theme.textTheme.bodyMedium,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//       ),
//       value: value,
//       onChanged: onChanged,
//       items: items
//           .map((item) => DropdownMenuItem(
//               value: item,
//               child: Text(item, style: theme.textTheme.bodyMedium)))
//           .toList(),
//     );
//   }

//   void _resetFilters() {
//     setState(() {
//       selectedGoalType = null;
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
//             "No diet plans found.",
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

//   Widget _buildErrorState(ThemeData theme) {
//     return Center(
//       child: Text(
//         "Error loading diet plans.",
//         style: theme.textTheme.headlineSmall
//             ?.copyWith(color: theme.colorScheme.error),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/diet_provider/diet_provider.dart';
import 'package:gymify/models/deit_plan_models/diet_plan_model.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart'; // Make sure to import your colors and theme.

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? selectedGoalType; // Holds the selected goal type filter
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DietProvider>(context, listen: false).fetchAllDietPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Diet Plans",
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
            Tab(text: "Weight Loss", icon: Icon(Icons.fitness_center)),
            Tab(text: "Muscle Gain", icon: Icon(Icons.monitor_weight)),
            Tab(text: "Maintenance", icon: Icon(Icons.home)),
          ],
        ),
      ),
      body: ChangeNotifierProvider(
        create: (_) => DietProvider()..fetchAllDietPlans(),
        child: Consumer<DietProvider>(
          builder: (context, dietProvider, child) {
            if (dietProvider.isLoading) {
              return const Center(child: CustomLoadingAnimation());
            }

            if (dietProvider.hasError) {
              return _buildErrorState(theme);
            }

            if (dietProvider.diets.isEmpty) {
              return _buildEmptyState(theme);
            }

            final filteredDietPlans = _getFilteredDietPlans(dietProvider.diets);

            return Column(
              children: [
                _buildSearchBar(theme),
                const SizedBox(height: 10),
                _buildFilterChips(theme),
                const SizedBox(height: 10),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildDietPlanList(
                          filteredDietPlans, "Weight_Loss", theme),
                      _buildDietPlanList(
                          filteredDietPlans, "Muscle_Gain", theme),
                      _buildDietPlanList(
                          filteredDietPlans, "Maintenance", theme),
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
          hintText: 'Search Diet Plans...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchController.clear();
                      _searchQuery = '';
                    });
                  },
                )
              : null,
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

  Widget _buildFilterChips(ThemeData theme) {
    return Row(
      children: [
        if (selectedGoalType != null)
          Chip(
            label: Text(selectedGoalType!),
            onDeleted: () {
              setState(() {
                selectedGoalType = null;
              });
            },
          ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _openFilterDrawer(context),
          color: theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildDietPlanList(
      List<DietPlan> dietPlans, String goalType, ThemeData theme) {
    final filteredByGoalType =
        dietPlans.where((dietPlan) => dietPlan.goalType == goalType).toList();

    if (filteredByGoalType.isEmpty) {
      return Center(
        child: Text(
          "No $goalType diet plans available.",
          style: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
      );
    }

    return ListView.separated(
      itemCount: filteredByGoalType.length,
      separatorBuilder: (context, index) {
        return Divider(
          color: theme.colorScheme.onSurface.withOpacity(0.2),
          thickness: 0.5,
          indent: 16,
          endIndent: 16,
        );
      },
      itemBuilder: (context, index) {
        final dietPlan = filteredByGoalType[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            title: Text(
              dietPlan.name,
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${dietPlan.calorieGoal} kcal • ${dietPlan.goalType}',
              style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: theme.colorScheme.primary,
              size: 20,
            ),
            onTap: () {
              context.pushNamed(
                'dietDetail',
                extra: dietPlan, // Pass the dietPlan as extra
              );
            },
          ),
        );
      },
    );
  }

  List<DietPlan> _getFilteredDietPlans(List<DietPlan> dietPlans) {
    return dietPlans.where((dietPlan) {
      final matchesSearch = dietPlan.name.toLowerCase().contains(_searchQuery);
      final matchesGoalType =
          selectedGoalType == null || dietPlan.goalType == selectedGoalType;
      return matchesSearch && matchesGoalType;
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
            hint: "Goal Type",
            value: selectedGoalType,
            items: ['Weight_Loss', 'Muscle_Gain', 'Maintenance'],
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
            "No diet plans found.",
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

  Widget _buildErrorState(ThemeData theme) {
    return Center(
      child: Text(
        "Error loading diet plans.",
        style: theme.textTheme.headlineSmall
            ?.copyWith(color: theme.colorScheme.error),
      ),
    );
  }
}
