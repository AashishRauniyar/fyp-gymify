import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  // Dummy data - replace with actual data from your backend
  final Map<String, dynamic> _fitnessData = {
    'currentWeight': 75.5,
    'personalBests': {
      'Squat': {'weight': 120, 'reps': 5},
      'Bench Press': {'weight': 80, 'reps': 8},
      'Deadlift': {'weight': 150, 'reps': 3},
    },
    'todayProgress': {
      'caloriesBurned': 420,
      'workoutDuration': 45,
      'completedWorkouts': 2,
    }
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(LineAwesomeIcons.bell, color: colorScheme.onSurface),
            onPressed: () => GoRouter.of(context).go('/notifications'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildOfferBanner(),
            const SizedBox(height: 24),
            _buildPersonalBests(),
            const SizedBox(height: 24),
            _buildWeightSection(),
            const SizedBox(height: 24),
            _buildProgressSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome Back',
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6))),
            const SizedBox(height: 4),
            const Text('Aashish',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        const CircleAvatar(
          radius: 28,
          backgroundImage:
              AssetImage('assets/images/profile/default_avatar.jpg'),
        ),
      ],
    );
  }

  Widget _buildOfferBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A3298), Color(0xFF2A1B4D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Premium Membership',
                        style: TextStyle(color: Colors.white, fontSize: 18)),
                    GestureDetector(
                      onTap: () {
                        _showBottomSheet();
                      },
                      child: const Icon(LineAwesomeIcons.info_circle_solid,
                          color: Colors.white, size: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text('Get you gym membership\ntarting at Rs 1500',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF4A3298),
                  ),
                  onPressed: () => GoRouter.of(context).go('/membership'),
                  child: const Text('Apply Now 💪'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Today's Progress",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildProgressCard(
                '🔥 ${_fitnessData['todayProgress']['caloriesBurned']}',
                'Calories'),
            const SizedBox(width: 16),
            _buildProgressCard(
                '⏱ ${_fitnessData['todayProgress']['workoutDuration']} min',
                'Duration'),
            const SizedBox(width: 16),
            _buildProgressCard(
                '🏋️ ${_fitnessData['todayProgress']['completedWorkouts']}',
                'Workouts'),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6))),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalBests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Personal Bests',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          children: [
            _buildPBItem('Squat', _fitnessData['personalBests']['Squat']),
            _buildPBItem('Bench', _fitnessData['personalBests']['Bench Press']),
            _buildPBItem('Deadlift', _fitnessData['personalBests']['Deadlift']),
          ],
        ),
      ],
    );
  }

  Widget _buildPBItem(String exercise, Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary.withOpacity(0.2),
            Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(exercise,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface)),
          const SizedBox(height: 4),
          Text('${data['weight']} kg',
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text('${data['reps']} reps',
              style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.6))),
        ],
      ),
    );
  }

  Widget _buildWeightSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            Theme.of(context).colorScheme.secondary.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Current Weight',
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6))),
              const SizedBox(height: 8),
              Text('${_fitnessData['currentWeight']} kg',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          ElevatedButton.icon(
            icon: const Icon(LineAwesomeIcons.play_circle),
            label: const Text('Log Weight'),
            onPressed: () => GoRouter.of(context).go('/weight-log'),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: colorScheme.outline.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Choose Your Plan',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    )),
                const SizedBox(height: 16),
                Text('Get full access to GYMIFY facilities',
                    style: TextStyle(
                      color: colorScheme.onSurface.withOpacity(0.6),
                      fontSize: 16,
                    )),
                const SizedBox(height: 32),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final plans = [
                      {
                        'title': 'Monthly',
                        'price': 'Rs 1550',
                        'duration': 'per month',
                        'features': [
                          'All basic equipment',
                          'Locker access',
                          'Group classes'
                        ]
                      },
                      {
                        'title': 'Quarterly',
                        'price': 'Rs 4000',
                        'duration': '3 months',
                        'features': [
                          'Monthly benefits',
                          'Sauna access',
                          '1 PT session'
                        ]
                      },
                      {
                        'title': 'Annual',
                        'price': 'Rs 12000',
                        'duration': '1 year',
                        'features': [
                          'All premium benefits',
                          'Unlimited classes',
                          'Diet plan'
                        ]
                      }
                    ];

                    final plan = plans[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            colorScheme.primary.withOpacity(0.1),
                            colorScheme.surface,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: colorScheme.outline.withOpacity(0.1),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(plan['title'] as String,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.primary,
                                  )),
                              Icon(Icons.fitness_center,
                                  color: colorScheme.primary),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(plan['price'] as String,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: colorScheme.onSurface,
                              )),
                          Text(plan['duration'] as String,
                              style: TextStyle(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              )),
                          const SizedBox(height: 16),
                          ...(plan['features'] as List<String>)
                              .map((feature) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.check_circle_outline,
                                            size: 16,
                                            color: colorScheme.primary),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(feature,
                                              style: TextStyle(
                                                color: colorScheme.onSurface
                                                    .withOpacity(0.8),
                                              )),
                                        ),
                                      ],
                                    ),
                                  )),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4A3298),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                // Add navigation to payment screen
                                context.pushNamed('membership', extra: plan);
                              },
                              child: const Text('Select Plan'),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    );
  }
}
