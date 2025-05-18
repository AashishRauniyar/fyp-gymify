import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/auth_provider/auth_provider.dart';
import 'package:gymify/providers/chat_provider/chat_service.dart';
import 'package:gymify/providers/membership_provider/membership_provider.dart';
import 'package:gymify/providers/profile_provider/profile_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

enum FitnessLevel {
  Beginner,
  Intermediate,
  Advanced,
  Athlete,
}

enum GoalType {
  Weight_Loss, // @map("Weight Loss")
  Muscle_Gain, // @map("Muscle Gain")
  Endurance,
  Maintenance,
  Flexibility,
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _fitnessLevelController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _goalTypeController = TextEditingController();

  FitnessLevel? _selectedFitnessLevel = FitnessLevel.Athlete;
  GoalType? _selectedGoalType = GoalType.Weight_Loss;

  File? _selectedImage;
  final ImagePicker _imagePicker = ImagePicker();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _pickImage() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _logout(BuildContext context) async {
    try {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final authProvider =
                        Provider.of<AuthProvider>(context, listen: false);

                    final socketService =
                        Provider.of<ChatProvider>(context, listen: false);
                    socketService.handleLogout();
                    await authProvider.logout();
                    if (context.mounted) {
                      context.go('/welcome');
                    }
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          });
    } catch (e) {
      if (context.mounted) {
        showCoolSnackBar(
          context,
          'Logout failed. Please try again.',
          false,
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.fetchProfile();
      final membershipProvider =
          Provider.of<MembershipProvider>(context, listen: false);
      membershipProvider.fetchMembershipStatus(context);
    });
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  String? _validateHeight(String? value) {
    if (value == null || value.isEmpty) {
      return 'Height is required';
    } else {
      final height = double.tryParse(value);
      if (height == null || height < 50 || height > 300) {
        return 'Please enter a valid height between 50 and 300 cm';
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileProvider = Provider.of<ProfileProvider>(context);

    if (profileProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CustomLoadingAnimation()),
      );
    }

    if (profileProvider.hasError && profileProvider.user == null) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: "Edit profile",
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Error: ${profileProvider.errorMessage}',
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => profileProvider.fetchProfile(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final user = profileProvider.user;

    if (user != null) {
      // Populate controllers if profile data exists
      _fullNameController.text = user.fullName ?? '';

      _phoneController.text = user.phoneNumber ?? '';
      _addressController.text = user.address ?? '';
      _heightController.text = user.height ?? '';
      _fitnessLevelController.text = user.fitnessLevel ?? '';
      _allergiesController.text = user.allergies ?? '';
      _goalTypeController.text = user.goalType ?? '';
    }

    return Scaffold(
      appBar: const CustomAppBar(
        title: "Edit profile",
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Profile Section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!) as ImageProvider
                              : user?.profileImage != null
                                  ? NetworkImage(user!.profileImage!)
                                  : const NetworkImage(
                                      'https://via.placeholder.com/150'),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.camera_alt,
                                size: 18,
                                color: theme.colorScheme.onPrimary,
                              ),
                              onPressed: _pickImage,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user?.fullName ?? 'No Name',
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      user?.email ?? 'No Email',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Personal Info Section
              Text('Personal Information',
                  style: theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              _buildTextField(context, 'Full Name', _fullNameController),
              const SizedBox(height: 10),

              const SizedBox(height: 10),
              _buildTextField(context, 'Phone Number', _phoneController,
                  validator: _validatePhone),
              const SizedBox(height: 10),
              _buildTextField(context, 'Address', _addressController),
              const SizedBox(height: 10),
              _buildTextField(context, 'Height', _heightController,
                  validator: _validateHeight),
              const SizedBox(height: 20),

              // Fitness Goals Section
              Text('Fitness Goals', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 10),
              _buildDropdownField(
                context,
                'Fitness Level',
                FitnessLevel.values,
                _selectedFitnessLevel,
                (value) => setState(() => _selectedFitnessLevel = value),
              ),
              const SizedBox(height: 10),
              _buildDropdownField(
                context,
                'Goal Type',
                GoalType.values,
                _selectedGoalType,
                (value) => setState(() => _selectedGoalType = value),
              ),
              const SizedBox(height: 20),

              // Save Profile Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final updatedData = {
                      'full_name': _fullNameController.text,
                      'phone_number': _phoneController.text,
                      'address': _addressController.text,
                      'height': _heightController.text,
                      'fitness_level':
                          _selectedFitnessLevel?.toString().split('.').last,
                      'goal_type':
                          _selectedGoalType?.toString().split('.').last,
                    };

                    await profileProvider.updateProfile(
                        updatedData, _selectedImage);

                    if (!profileProvider.hasError) {
                      showCoolSnackBar(
                        context,
                        'Profile updated successfully',
                        true,
                      );
                    } else {
                      showCoolSnackBar(
                        context,
                        profileProvider.errorMessage ??
                            'Error updating profile',
                        false,
                      );
                    }
                  }
                },
                child: const Text('Save Changes'),
              ),

              const SizedBox(height: 30),

              // Logout Section
              ListTile(
                leading: Icon(Icons.logout, color: theme.colorScheme.error),
                title: Text('Log Out',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.bold,
                    )),
                onTap: () {
                  _logout(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      BuildContext context, String label, TextEditingController controller,
      {bool enabled = true, String? Function(String?)? validator}) {
    final theme = Theme.of(context);
    return TextFormField(
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      controller: controller,
      validator: validator,
    );
  }

  Widget _buildDropdownField<T>(
    BuildContext context,
    String label,
    List<T> items,
    T? selectedItem,
    ValueChanged<T?> onChanged,
  ) {
    final theme = Theme.of(context);
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      value: selectedItem,
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(item.toString().split('.').last,
              style: theme.textTheme.bodyMedium),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
