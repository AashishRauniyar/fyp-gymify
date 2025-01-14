import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/colors/custom_colors.dart';
import 'package:gymify/providers/log_provider/log_provider.dart';
import 'package:gymify/providers/workout_provider/workout_provider.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:provider/provider.dart';

class WorkoutHistoryScreen extends StatefulWidget {
  final String userId;

  const WorkoutHistoryScreen({super.key, required this.userId});

  @override
  State<WorkoutHistoryScreen> createState() => _WorkoutHistoryScreenState();
}

class _WorkoutHistoryScreenState extends State<WorkoutHistoryScreen> {
  @override
  void initState() {
    super.initState();

    // Fetch user logs when the screen is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WorkoutLogProvider>().fetchUserLogs(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutLogProvider = context.watch<WorkoutLogProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workout History",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: CustomColors.primary,
        centerTitle: true,
      ),
      body: workoutLogProvider.isLoading
          ? const Center(child: CustomLoadingAnimation())
          : workoutLogProvider.hasError
              ? const Center(
                  child: Text(
                    "Failed to fetch workout history. Please try again.",
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                )
              : workoutLogProvider.userLogs.isEmpty
                  ? const Center(
                      child: Text(
                        "No workout history available.",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: workoutLogProvider.userLogs.length,
                      itemBuilder: (context, index) {
                        final log = workoutLogProvider.userLogs[index];
                        return WorkoutLogTile(log: log);
                      },
                    ),
    );
  }
}

class WorkoutLogTile extends StatefulWidget {
  final Map<String, dynamic> log;

  const WorkoutLogTile({super.key, required this.log});

  @override
  State<WorkoutLogTile> createState() => _WorkoutLogTileState();
}

class _WorkoutLogTileState extends State<WorkoutLogTile> {
  String? _workoutName; // To store the fetched workout name
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWorkoutName(); // Fetch workout name when the tile is initialized
  }

  Future<void> _fetchWorkoutName() async {
    final workoutProvider = context.read<WorkoutProvider>();
    final workoutId = widget.log['workout_id'];

    // Check if workoutId is valid
    if (workoutId == null) {
      setState(() {
        _workoutName = "Unknown Workout";
        _isLoading = false;
      });
      return;
    }

    try {
      // Fetch workout by ID
      await workoutProvider.fetchWorkoutById(workoutId);
      final workout = workoutProvider.selectedWorkout;

      setState(() {
        _workoutName = workout?.workoutName ?? "Unknown Workout";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _workoutName = "Unknown Workout";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final workoutDate = widget.log['workout_date'] ?? 'N/A';
    final workoutNotes =
        widget.log['performance_notes'] ?? 'No notes available';
    final exercises = widget.log['workoutexerciseslogs'] ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 6,
      child: ExpansionTile(
        leading: Icon(Icons.fitness_center, color: CustomColors.primary),
        title: _isLoading
            ? const CustomLoadingAnimation()
            : Text(
                "${_formatDate(workoutDate)} - $_workoutName - $workoutNotes",
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
              ),
        children: exercises.map<Widget>((exerciseLog) {
          final exercise = exerciseLog['exercises'];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(exercise['image_url']),
            ),
            title: Text(
              exercise['exercise_name'],
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "Duration: ${exerciseLog['exercise_duration']} mins, Rest: ${exerciseLog['rest_duration']} mins",
              style: GoogleFonts.poppins(fontSize: 12),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.play_circle_fill, color: Colors.blue),
              onPressed: () {
                _playVideo(context, exercise['video_url']);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    return "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
  }

  void _playVideo(BuildContext context, String videoUrl) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          content: SizedBox(
            height: 300,
            width: 400,
            child: Center(
              child: Text("Video Player for URL: $videoUrl"),
            ),
          ),
        );
      },
    );
  }
}
