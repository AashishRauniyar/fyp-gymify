import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/models/exercise_model.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  VideoPlayerController? _videoController;
  bool _showVideo = false; // Toggle for video player visibility

  @override
  void initState() {
    super.initState();
    if (widget.exercise.videoUrl.isNotEmpty) {
      _videoController =
          VideoPlayerController.networkUrl(Uri.parse(widget.exercise.videoUrl))
            ..initialize().then((_) {
              setState(() {});
            });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      //

      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp, color: theme.primaryColor),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.exercise.imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Exercise Name
            Text(
              widget.exercise.exerciseName,
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),

            // Description
            Text(
              widget.exercise.description,
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),

            // Duration and Target Muscle
            _buildInfoRow(
              icon: Icons.timer,
              label:
                  "Calories Burned: ${widget.exercise.caloriesBurnedPerMinute} kcal/min",
              theme: theme,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.fitness_center,
              label: "Target Muscle: ${widget.exercise.targetMuscleGroup}",
              theme: theme,
            ),
            const SizedBox(height: 16),

            // Toggle Button for Tutorial/Video
            Text(
              "Tutorial Video",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),

            if (!_showVideo)
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: theme.colorScheme.primary, width: 1),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      "Learn the correct form and technique for ${widget.exercise.exerciseName}. Watch the video tutorial for detailed guidance.",
                      style: theme.textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _showVideo = true; // Show video player
                        });
                      },
                      icon: const Icon(Icons.play_circle_fill, size: 24),
                      label: const Text("Play Video"),
                    ),
                  ],
                ),
              ),
            if (_showVideo)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          VideoPlayer(_videoController!),
                          IconButton(
                            icon: Icon(
                              _videoController!.value.isPlaying
                                  ? Icons.pause_circle_filled
                                  : Icons.play_circle_fill,
                              color: Colors.white.withOpacity(0.9),
                              size: 64,
                            ),
                            onPressed: () {
                              setState(() {
                                if (_videoController!.value.isPlaying) {
                                  _videoController!.pause();
                                } else {
                                  _videoController!.play();
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required ThemeData theme,
  }) {
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
