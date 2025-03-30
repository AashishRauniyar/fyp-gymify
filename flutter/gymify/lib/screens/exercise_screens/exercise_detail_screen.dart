// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/models/exercise_model.dart';

// class ExerciseDetailScreen extends StatefulWidget {
//   final Exercise exercise;

//   const ExerciseDetailScreen({super.key, required this.exercise});

//   @override
//   State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
// }

// class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
//   VideoPlayerController? _videoController;
//   bool _showVideo = false; // Toggle for video player visibility

//   @override
//   void initState() {
//     super.initState();
//     if (widget.exercise.videoUrl.isNotEmpty) {
//       _videoController =
//           VideoPlayerController.networkUrl(Uri.parse(widget.exercise.videoUrl))
//             ..initialize().then((_) {
//               setState(() {});
//             });
//     }
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       //

//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: theme.scaffoldBackgroundColor,
//         scrolledUnderElevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new_sharp, color: theme.primaryColor),
//           onPressed: () {
//             context.pop();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.network(
//                 widget.exercise.imageUrl,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Exercise Name
//             Text(
//               widget.exercise.exerciseName,
//               style: theme.textTheme.headlineMedium,
//             ),
//             const SizedBox(height: 8),

//             // Description
//             Text(
//               widget.exercise.description,
//               style: theme.textTheme.bodyLarge,
//             ),
//             const SizedBox(height: 16),

//             // Duration and Target Muscle
//             _buildInfoRow(
//               icon: Icons.timer,
//               label:
//                   "Calories Burned: ${widget.exercise.caloriesBurnedPerMinute} kcal/min",
//               theme: theme,
//             ),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               icon: Icons.fitness_center,
//               label: "Target Muscle: ${widget.exercise.targetMuscleGroup}",
//               theme: theme,
//             ),
//             const SizedBox(height: 16),

//             // Toggle Button for Tutorial/Video
//             Text(
//               "Tutorial Video",
//               style: theme.textTheme.headlineSmall?.copyWith(
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//             const SizedBox(height: 8),

//             if (!_showVideo)
//               Container(
//                 decoration: BoxDecoration(
//                   color: theme.colorScheme.surface.withOpacity(0.05),
//                   borderRadius: BorderRadius.circular(12),
//                   border:
//                       Border.all(color: theme.colorScheme.primary, width: 1),
//                 ),
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Learn the correct form and technique for ${widget.exercise.exerciseName}. Watch the video tutorial for detailed guidance.",
//                       style: theme.textTheme.bodyLarge,
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         setState(() {
//                           _showVideo = true; // Show video player
//                         });
//                       },
//                       icon: const Icon(Icons.play_circle_fill, size: 24),
//                       label: const Text("Play Video"),
//                     ),
//                   ],
//                 ),
//               ),
//             if (_showVideo)
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 8),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: Colors.black,
//                       borderRadius: BorderRadius.circular(12),
//                       boxShadow: const [
//                         BoxShadow(
//                           color: Colors.black26,
//                           blurRadius: 8,
//                           offset: Offset(0, 4),
//                         ),
//                       ],
//                     ),
//                     clipBehavior: Clip.hardEdge,
//                     child: AspectRatio(
//                       aspectRatio: _videoController!.value.aspectRatio,
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           VideoPlayer(_videoController!),
//                           IconButton(
//                             icon: Icon(
//                               _videoController!.value.isPlaying
//                                   ? Icons.pause_circle_filled
//                                   : Icons.play_circle_fill,
//                               color: Colors.white.withOpacity(0.9),
//                               size: 64,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 if (_videoController!.value.isPlaying) {
//                                   _videoController!.pause();
//                                 } else {
//                                   _videoController!.play();
//                                 }
//                               });
//                             },
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow({
//     required IconData icon,
//     required String label,
//     required ThemeData theme,
//   }) {
//     return Row(
//       children: [
//         Icon(icon, color: theme.colorScheme.primary),
//         const SizedBox(width: 8),
//         Text(
//           label,
//           style: theme.textTheme.bodyLarge?.copyWith(
//             color: theme.colorScheme.onSurface,
//           ),
//         ),
//       ],
//     );
//   }
// }

//!dsfds

// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:go_router/go_router.dart';
// import 'package:flutter/services.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:gymify/models/exercise_model.dart';

// class ExerciseDetailScreen extends StatefulWidget {
//   final Exercise exercise;

//   const ExerciseDetailScreen({super.key, required this.exercise});

//   @override
//   State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
// }

// class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
//   VideoPlayerController? _videoController;
//   ChewieController? _chewieController;
//   bool _showVideo = false;
//   bool _isVideoInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     // Set system UI overlay style for immersive experience
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.light,
//     ));

//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     if (widget.exercise.videoUrl.isNotEmpty) {
//       _videoController =
//           VideoPlayerController.networkUrl(Uri.parse(widget.exercise.videoUrl));

//       await _videoController!.initialize();

//       _chewieController = ChewieController(
//         videoPlayerController: _videoController!,
//         aspectRatio: _videoController!.value.aspectRatio,
//         autoPlay: false,
//         looping: false,
//         allowMuting: true,
//         allowPlaybackSpeedChanging: true,
//         placeholder: const Center(
//           child: CircularProgressIndicator(),
//         ),
//         materialProgressColors: ChewieProgressColors(
//           playedColor: Theme.of(context).colorScheme.primary,
//           handleColor: Theme.of(context).colorScheme.primary,
//           backgroundColor: Colors.grey.shade300,
//           bufferedColor: Theme.of(context).colorScheme.primary.withOpacity(0.5),
//         ),
//       );

//       if (mounted) {
//         setState(() {
//           _isVideoInitialized = true;
//         });
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _chewieController?.dispose();
//     _videoController?.dispose();
//     // Reset system UI overlay style
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           // Sliver app bar with hero image
//           SliverAppBar(
//             expandedHeight: 250,
//             pinned: true,
//             stretch: true,
//             backgroundColor: theme.scaffoldBackgroundColor,
//             leading: GestureDetector(
//               onTap: () => context.pop(),
//               child: Container(
//                 margin: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.3),
//                   shape: BoxShape.circle,
//                 ),
//                 child: const Icon(
//                   Icons.arrow_back_ios,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             flexibleSpace: FlexibleSpaceBar(
//               background: Stack(
//                 fit: StackFit.expand,
//                 children: [
//                   // Exercise image
//                   Hero(
//                     tag: 'exercise-image-${widget.exercise.exerciseId}',
//                     child: Image.network(
//                       widget.exercise.imageUrl,
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => Container(
//                         color: theme.colorScheme.primary.withOpacity(0.2),
//                         child: const Icon(Icons.image_not_supported, size: 50),
//                       ),
//                     ),
//                   ),
//                   // Gradient overlay for better text visibility
//                   Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topCenter,
//                         end: Alignment.bottomCenter,
//                         colors: [
//                           Colors.transparent,
//                           Colors.black.withOpacity(0.7),
//                         ],
//                         stops: const [0.6, 1.0],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),

//           // Exercise content
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Exercise name and target muscle badge
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: Text(
//                           widget.exercise.exerciseName,
//                           style: GoogleFonts.poppins(
//                             fontSize: 28,
//                             fontWeight: FontWeight.bold,
//                             color: theme.colorScheme.onSurface,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.primary,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           widget.exercise.targetMuscleGroup,
//                           style: GoogleFonts.roboto(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 16),

//                   // Quick info icons
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 16, horizontal: 12),
//                     decoration: BoxDecoration(
//                       color: isDarkMode
//                           ? theme.colorScheme.surface.withOpacity(0.3)
//                           : theme.colorScheme.primary.withOpacity(0.1),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: [
//                         _buildInfoColumn(
//                           icon: FontAwesomeIcons.fire,
//                           label: 'Calories',
//                           value:
//                               '${widget.exercise.caloriesBurnedPerMinute}/min',
//                           theme: theme,
//                         ),
//                         _buildInfoColumn(
//                           icon: FontAwesomeIcons.dumbbell,
//                           label: 'Target',
//                           value: widget.exercise.targetMuscleGroup,
//                           theme: theme,
//                         ),
//                         _buildInfoColumn(
//                           icon: FontAwesomeIcons.clock,
//                           label: 'Added',
//                           value: _formatDate(widget.exercise.createdAt),
//                           theme: theme,
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Description section
//                   Text(
//                     'Description',
//                     style: GoogleFonts.poppins(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: theme.colorScheme.onSurface,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     widget.exercise.description,
//                     style: theme.textTheme.bodyLarge?.copyWith(
//                       height: 1.6,
//                       color: theme.colorScheme.onSurface.withOpacity(0.8),
//                     ),
//                   ),

//                   const SizedBox(height: 24),

//                   // Video section
//                   if (widget.exercise.videoUrl.isNotEmpty) ...[
//                     Text(
//                       'Tutorial Video',
//                       style: GoogleFonts.poppins(
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         color: theme.colorScheme.onSurface,
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     if (!_showVideo) ...[
//                       // Video thumbnail with play button
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             _showVideo = true;
//                           });
//                         },
//                         child: Container(
//                           height: 200,
//                           width: double.infinity,
//                           decoration: BoxDecoration(
//                             color: theme.colorScheme.surface,
//                             borderRadius: BorderRadius.circular(12),
//                             image: DecorationImage(
//                               image: NetworkImage(widget.exercise.imageUrl),
//                               fit: BoxFit.cover,
//                               colorFilter: ColorFilter.mode(
//                                 Colors.black.withOpacity(0.3),
//                                 BlendMode.darken,
//                               ),
//                             ),
//                           ),
//                           child: Center(
//                             child: Container(
//                               padding: const EdgeInsets.all(16),
//                               decoration: BoxDecoration(
//                                 color: theme.colorScheme.primary,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Icon(
//                                 Icons.play_arrow,
//                                 color: Colors.white,
//                                 size: 40,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ] else if (_isVideoInitialized &&
//                         _chewieController != null) ...[
//                       // Chewie video player
//                       Container(
//                         height: 250,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(12),
//                           child: Chewie(controller: _chewieController!),
//                         ),
//                       ),
//                     ] else ...[
//                       // Loading indicator
//                       Container(
//                         height: 200,
//                         width: double.infinity,
//                         decoration: BoxDecoration(
//                           color: theme.colorScheme.surface,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Center(
//                           child: CircularProgressIndicator(),
//                         ),
//                       ),
//                     ],
//                   ],

//                   const SizedBox(height: 32),

//                   // Tips section
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: isDarkMode
//                           ? Colors.amber.shade900.withOpacity(0.2)
//                           : Colors.amber.shade50,
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: Colors.amber.shade800.withOpacity(0.5),
//                         width: 1,
//                       ),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Icon(
//                               Icons.lightbulb,
//                               color: Colors.amber.shade800,
//                             ),
//                             const SizedBox(width: 8),
//                             Text(
//                               'Tips & Safety',
//                               style: GoogleFonts.poppins(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.amber.shade800,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '• Always warm up before performing this exercise\n'
//                           '• Maintain proper form to prevent injuries\n'
//                           '• Start with lighter weights if you\'re a beginner\n'
//                           '• Focus on controlled movements rather than speed\n'
//                           '• Consult with a fitness professional if you\'re unsure about proper form',
//                           style: theme.textTheme.bodyMedium?.copyWith(
//                             height: 1.6,
//                             color: isDarkMode
//                                 ? Colors.amber.shade200
//                                 : Colors.amber.shade900,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoColumn({
//     required IconData icon,
//     required String label,
//     required String value,
//     required ThemeData theme,
//   }) {
//     return Column(
//       children: [
//         Icon(
//           icon,
//           color: theme.colorScheme.primary,
//           size: 22,
//         ),
//         const SizedBox(height: 8),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w500,
//             color: theme.colorScheme.onSurface.withOpacity(0.6),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           value,
//           style: TextStyle(
//             fontSize: 13,
//             fontWeight: FontWeight.bold,
//             color: theme.colorScheme.onSurface,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   String _formatDate(DateTime date) {
//     final month = date.month.toString().padLeft(2, '0');
//     final day = date.day.toString().padLeft(2, '0');
//     return '$month/$day/${date.year}';
//   }
// }
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
              customControls: const MaterialControls(
                showPlayButton: true,
              ),
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
                          _buildInfoElement(
                            'ADDED',
                            _formatDate(widget.exercise.createdAt),
                            FontAwesomeIcons.calendar,
                            theme,
                          ),
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
                          child: Container(
                            width: double.infinity,
                            height: 250, // Increased height
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
                              child: Center(
                                child: Chewie(controller: _chewieController!),
                              ),
                            ),
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
