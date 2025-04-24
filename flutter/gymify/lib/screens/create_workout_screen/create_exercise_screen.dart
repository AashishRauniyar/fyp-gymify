import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CreateExerciseScreen extends StatefulWidget {
  const CreateExerciseScreen({super.key});

  @override
  _CreateExerciseScreenState createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  late String exerciseName;
  late String description;
  String targetMuscleGroup = '';
  late String caloriesBurnedPerMinute;

  File? exerciseImage;
  File? exerciseVideo;
  VideoPlayerController? _videoController;

  // Added error state variables for media files
  bool showImageError = false;
  bool showVideoError = false;

  final List<String> muscleGroups = [
    'Chest',
    'Back',
    'Arms',
    'Legs',
    'Core',
    'Shoulders',
    'Glutes',
    'Full Body',
  ];

  @override
  void initState() {
    super.initState();
    exerciseName = '';
    description = '';
    caloriesBurnedPerMinute = '';
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        exerciseImage = File(pickedFile.path);
        showImageError = false;
      });
    }
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        exerciseVideo = File(result.files.single.path!);
        showVideoError = false;
        _videoController = VideoPlayerController.file(exerciseVideo!)
          ..initialize().then((_) {
            setState(() {});
          });
      });
    }
  }

  // Check if all required fields are valid
  bool validateForm() {
    bool isValid = _formKey.currentState?.validate() ?? false;

    // Validate exercise image
    if (exerciseImage == null) {
      setState(() {
        showImageError = true;
      });
      isValid = false;
    }

    // Validate exercise video
    if (exerciseVideo == null) {
      setState(() {
        showVideoError = true;
      });
      isValid = false;
    }

    return isValid;
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CustomAppBar(title: "Create Exercise"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Exercise Name
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Exercise Name *',
                  helperText: 'Enter a unique name for the exercise.',
                ),
                onSaved: (value) => exerciseName = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Description
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description *',
                  helperText: 'Provide a brief description of the exercise.',
                ),
                onSaved: (value) => description = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Target Muscle Group Dropdown
              DropdownButtonFormField<String>(
                style: theme.textTheme.bodyMedium,
                decoration: const InputDecoration(
                  labelText: 'Target Muscle Group *',
                  helperText: 'Select the target muscle group.',
                ),
                value: targetMuscleGroup.isNotEmpty ? targetMuscleGroup : null,
                onChanged: (String? newValue) {
                  setState(() {
                    targetMuscleGroup = newValue!;
                  });
                },
                items:
                    muscleGroups.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a target muscle group';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Calories Burned Per Minute
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Calories Burned per Min *',
                  helperMaxLines: 2,
                  helperText:
                      'Enter the calories burned per minute (max 999.99).',
                ),
                keyboardType: TextInputType.number,
                onSaved: (value) => caloriesBurnedPerMinute = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories burned per minute';
                  }
                  final calories = double.tryParse(value);
                  if (calories == null || calories <= 0) {
                    return 'Please enter a valid number';
                  }
                  if (calories > 999.99) {
                    return 'Calories burned per minute cannot exceed 999.99';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Pick Exercise Image Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Exercise Image *",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (showImageError)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Required",
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: showImageError
                                    ? Colors.red
                                    : theme.colorScheme.primary,
                                width: 2),
                            color: exerciseImage == null
                                ? theme.colorScheme.secondary.withOpacity(0.1)
                                : null,
                          ),
                          child: exerciseImage == null
                              ? Icon(Icons.image,
                                  color: showImageError
                                      ? Colors.red
                                      : theme.colorScheme.primary,
                                  size: 40)
                              : ClipOval(
                                  child: Image.file(
                                    exerciseImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        if (exerciseImage != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  exerciseImage = null;
                                  showImageError = true;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Pick Exercise Video Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Exercise Video *",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      if (showVideoError)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Required",
                            style:
                                TextStyle(color: Colors.red[700], fontSize: 12),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickVideo,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: showVideoError
                                    ? Colors.red
                                    : theme.colorScheme.primary,
                                width: 2),
                            color: exerciseVideo == null
                                ? theme.colorScheme.secondary.withOpacity(0.1)
                                : null,
                          ),
                          child: exerciseVideo == null
                              ? Icon(Icons.videocam,
                                  color: showVideoError
                                      ? Colors.red
                                      : theme.colorScheme.primary,
                                  size: 40)
                              : ClipOval(
                                  child: _videoController != null &&
                                          _videoController!.value.isInitialized
                                      ? AspectRatio(
                                          aspectRatio: _videoController!
                                              .value.aspectRatio,
                                          child: VideoPlayer(_videoController!),
                                        )
                                      : const CircularProgressIndicator(),
                                ),
                        ),
                        if (exerciseVideo != null)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  exerciseVideo = null;
                                  showVideoError = true;
                                  _videoController?.dispose();
                                  _videoController = null;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Create Exercise Button
              exerciseProvider.isLoading
                  ? const Center(child: CustomLoadingAnimation())
                  : ElevatedButton(
                      onPressed: () async {
                        if (validateForm()) {
                          _formKey.currentState?.save();
                          try {
                            await exerciseProvider.createExercise(
                              context: context,
                              exerciseName: exerciseName,
                              description: description,
                              targetMuscleGroup: targetMuscleGroup,
                              caloriesBurnedPerMinute: caloriesBurnedPerMinute,
                              exerciseImage: exerciseImage,
                              exerciseVideo: exerciseVideo,
                            );

                            if (context.mounted) {
                              Navigator.pop(
                                  context); // Return to previous screen after successful creation
                              showCoolSnackBar(context,
                                  "Exercise Created Successfully", true);
                            }
                          } catch (e) {
                            if (context.mounted) {
                              showCoolSnackBar(context,
                                  "Error creating exercise: $e", false);
                            }
                          }
                        }
                      },
                      child: const Text('Create Exercise'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
