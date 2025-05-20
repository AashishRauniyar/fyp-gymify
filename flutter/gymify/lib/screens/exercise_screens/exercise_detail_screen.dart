import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gymify/models/exercise_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _showVideo = false;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    // Set system UI overlay style for immersive experience
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _initializeVideo();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Update system UI colors after dependencies are available
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
    ));
  }

  Future<void> _initializeVideo() async {
    if (widget.exercise.videoUrl.isNotEmpty) {
      try {
        _videoController = VideoPlayerController.networkUrl(
            Uri.parse(widget.exercise.videoUrl));

        await _videoController!.initialize();

        // Create the controller after the context is fully built
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            final theme = Theme.of(context);
            final chewieController = ChewieController(
              videoPlayerController: _videoController!,
              // Don't force a specific aspect ratio
              autoPlay: false,
              looping: false,
              allowMuting: true,
              allowFullScreen: true,
              deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
              allowPlaybackSpeedChanging: true,
              placeholder: const Center(
                child: CircularProgressIndicator(),
              ),
              materialProgressColors: ChewieProgressColors(
                playedColor: theme.colorScheme.primary,
                handleColor: theme.colorScheme.primary,
                backgroundColor: Colors.grey.shade300,
                bufferedColor: theme.colorScheme.primary.withOpacity(0.5),
              ),
              // Make the controls larger and more visible
              showControlsOnInitialize: true,
              controlsSafeAreaMinimum: const EdgeInsets.all(20),
            );

            setState(() {
              _chewieController = chewieController;
              _isVideoInitialized = true;
            });
          }
        });
      } catch (e) {
        print('Error initializing video: $e');
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    // Reset system UI overlay style
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Header with image and title
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                stretch: true,
                backgroundColor: theme.colorScheme.primary,
                leading: GestureDetector(
                  onTap: () => context.pop(),
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
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
                      // Exercise image
                      CachedNetworkImage(
                        imageUrl: widget.exercise.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: theme.colorScheme.primary.withOpacity(0.2),
                          child:
                              const Icon(Icons.image_not_supported, size: 50),
                        ),
                      ),
                      // Gradient overlay for better text visibility
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                      // Exercise information overlay
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Level badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.secondary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.exercise.targetMuscleGroup
                                      .toUpperCase(),
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Exercise title
                              Text(
                                widget.exercise.exerciseName,
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              // Exercise metadata
                              Row(
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.fire,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${widget.exercise.caloriesBurnedPerMinute} kcal/min",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Exercise content
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quick info bar
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInfoElement(
                            'MUSCLE',
                            widget.exercise.targetMuscleGroup,
                            FontAwesomeIcons.dumbbell,
                            theme,
                          ),
                          _buildInfoElement(
                            'CALORIES',
                            "${widget.exercise.caloriesBurnedPerMinute}/min",
                            FontAwesomeIcons.fire,
                            theme,
                          ),
                          //   _buildInfoElement(
                          //     'ADDED',
                          //     _formatDate(widget.exercise.createdAt),
                          //     FontAwesomeIcons.calendar,
                          //     theme,
                          //   ),
                          // ],
                        ],
                      ),
                    ),

                    // Exercise description
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About This Exercise',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.exercise.description,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              height: 1.6,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Divider
                    Divider(
                        color: theme.colorScheme.onSurface.withOpacity(0.1)),

                    // Video section
                    if (widget.exercise.videoUrl.isNotEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Text(
                          'Tutorial Video',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),

                      if (!_showVideo) ...[
                        // Video placeholder with play button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showVideo = true;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(widget.exercise.imageUrl),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.3),
                                  BlendMode.darken,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  FontAwesomeIcons.play,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ] else if (_isVideoInitialized &&
                          _chewieController != null) ...[
                        // Chewie video player
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final aspectRatio =
                                  _videoController?.value.aspectRatio ??
                                      (16 / 9);
                              return Container(
                                width: double.infinity,
                                height: 250, // fixed height for consistency
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.black,
                                  border: Border.all(
                                    color: theme.colorScheme.onSurface
                                        .withOpacity(0.1),
                                    width: 1.5,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: AspectRatio(
                                    aspectRatio: aspectRatio,
                                    child:
                                        Chewie(controller: _chewieController!),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ] else ...[
                        // Loading indicator
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          child: Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: theme.colorScheme.onSurface
                                    .withOpacity(0.1),
                                width: 1.5,
                              ),
                            ),
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Safety tips section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.colorScheme.primary.withOpacity(0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.shieldHalved,
                                    size: 16,
                                    color: theme.colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Safety Tips',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildSafetyTip(
                                  'Always warm up before performing this exercise',
                                  theme),
                              _buildSafetyTip(
                                  'Maintain proper form to prevent injuries',
                                  theme),
                              _buildSafetyTip(
                                  'Start with lighter weights if you\'re a beginner',
                                  theme),
                              _buildSafetyTip(
                                  'Focus on controlled movements rather than speed',
                                  theme),
                              _buildSafetyTip(
                                  'If you feel pain (not muscle fatigue), stop immediately',
                                  theme),
                            ],
                          ),
                        ),
                      ),
                    ],

                    // Extra space at the bottom
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoElement(
      String label, String value, IconData icon, ThemeData theme) {
    return Column(
      children: [
        Icon(
          icon,
          size: 22,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSafetyTip(String tip, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            FontAwesomeIcons.circleCheck,
            size: 14,
            color: theme.colorScheme.primary.withOpacity(0.8),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');
    return '$month/$day/${date.year}';
  }
}
