import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/exercise_provider/exercise_provider.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateExerciseScreen extends StatefulWidget {
  const CreateExerciseScreen({super.key});

  @override
  _CreateExerciseScreenState createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  final _formKey = GlobalKey<FormState>();
  late String exerciseName;
  late String description;
  String targetMuscleGroup = ''; // Initialize with an empty string
  late String caloriesBurnedPerMinute;
  late String videoUrl;

  File? exerciseImage;
  File? exerciseVideo; // Declare the video file variable

  // List for muscle groups (You can customize this list as needed)
  final List<String> muscleGroups = [
    'Chest',
    'Back',
    'Arms',
    'Legs',
    'Core',
    'Shoulders',
    'Glutes',
    'Full Body'
  ];

  @override
  void initState() {
    super.initState();
    // Initializing default values
    exerciseName = '';
    description = '';
    caloriesBurnedPerMinute = '';
    videoUrl = '';
  }

  // Function to pick a video
  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video, // Set file type to video
    );

    if (result != null) {
      setState(() {
        exerciseVideo = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Exercise'),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Exercise Name
              TextFormField(
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                onSaved: (value) => exerciseName = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an exercise name';
                  }
                  return null;
                },
              ),
              // Description
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value ?? '',
              ),
              // Target Muscle Group Dropdown
              DropdownButtonFormField<String>(
                decoration:
                    const InputDecoration(labelText: 'Target Muscle Group'),
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
              // Calories Burned Per Minute
              TextFormField(
                decoration:
                    const InputDecoration(labelText: 'Calories Burned per Min'),
                keyboardType: TextInputType.number,
                onSaved: (value) => caloriesBurnedPerMinute = value ?? '',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter calories burned per minute';
                  }
                  return null;
                },
              ),
              // Video URL
              // TextFormField(
              //   decoration: const InputDecoration(labelText: 'Video URL'),
              //   onSaved: (value) => videoUrl = value ?? '',
              // ),
              const SizedBox(height: 20),
              // Pick Exercise Image
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final pickedFile =
                      await picker.pickImage(source: ImageSource.gallery);

                  if (pickedFile != null) {
                    setState(() {
                      exerciseImage = File(pickedFile.path);
                    });
                  }
                },
                child: const Text('Pick Exercise Image'),
              ),
              if (exerciseImage != null)
                Image.file(exerciseImage!, height: 100, width: 100),
              const SizedBox(height: 20),
              // Pick Exercise Video
              ElevatedButton(
                onPressed: _pickVideo, // Use the video picker
                child: const Text('Pick Exercise Video'),
              ),
              if (exerciseVideo != null)
                Text('Video selected: ${exerciseVideo!.path}'),
              const SizedBox(height: 20),
              // Create Exercise Button
              ElevatedButton(
                onPressed: () async {
                  // Save form and create exercise
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    try {
                      await exerciseProvider.createExercise(
                        context: context,
                        exerciseName: exerciseName,
                        description: description,
                        targetMuscleGroup: targetMuscleGroup,
                        caloriesBurnedPerMinute: caloriesBurnedPerMinute,
                        videoUrl: videoUrl,
                        exerciseImage: exerciseImage,
                        exerciseVideo:
                            exerciseVideo, // Pass the video to provider
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Exercise created successfully')),
                      );
                      // Optionally, you can clear the form or navigate to another page.
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error creating exercise: $e')),
                      );
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
