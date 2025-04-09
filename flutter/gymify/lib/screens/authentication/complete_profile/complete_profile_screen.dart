// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
// import 'package:gymify/utils/custom_appbar.dart';
// import 'package:gymify/utils/custom_button.dart';
// import 'package:gymify/utils/custom_input.dart';
// import 'package:gymify/utils/custom_loader.dart';
// import 'package:gymify/utils/custom_snackbar.dart';
// import 'package:gymify/utils/workout_utils.dart/profile_input.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// class ProfileCompletionScreen extends StatefulWidget {
//   final String email;

//   const ProfileCompletionScreen({super.key, required this.email});

//   @override
//   State<ProfileCompletionScreen> createState() =>
//       _ProfileCompletionScreenState();
// }

// class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // Form controllers
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _allergiesController = TextEditingController();

//   // Selected values
//   String _selectedGender = 'Male';
//   DateTime _selectedDate = DateTime.now()
//       .subtract(const Duration(days: 365 * 20)); // Default to 20 years ago
//   double _height = 170.0; // Default height in cm
//   double _weight = 70.0; // Default weight in kg
//   String _selectedFitnessLevel = 'Beginner';
//   String _selectedGoalType = 'Weight_Loss';
//   int _calorieGoals = 2000; // Default calorie goal

//   File? _profileImage;
//   bool _isUsernameAvailable = true;
//   bool _isPhoneAvailable = true;

//   // Lists for dropdowns
//   final List<String> _genders = ['Male', 'Female', 'Other'];
//   final List<String> _fitnessLevels = [
//     'Beginner',
//     'Intermediate',
//     'Advanced',
//     'Athlete'
//   ];
//   final List<String> _goalTypes = [
//     'Weight_Loss',
//     'Muscle_Gain',
//     'Maintenance',
//     'Endurance',
//     'Flexibility'
//   ];

//   @override
//   void dispose() {
//     _userNameController.dispose();
//     _fullNameController.dispose();
//     _phoneController.dispose();
//     _addressController.dispose();
//     _allergiesController.dispose();
//     super.dispose();
//   }

//   Future<void> _pickImage() async {
//     try {
//       final pickedFile =
//           await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (pickedFile != null) {
//         setState(() {
//           _profileImage = File(pickedFile.path);
//         });
//       }
//     } catch (e) {
//       showCoolSnackBar(context, "Error picking image: $e", false);
//     }
//   }

//   Future<void> _checkUsername(SignupProvider provider) async {
//     if (_userNameController.text.isEmpty) return;

//     setState(() => _isUsernameAvailable =
//         false); // Assume it's not available until confirmed

//     final isAvailable = await provider.checkUsername(_userNameController.text);

//     setState(() {
//       _isUsernameAvailable = isAvailable;
//     });

//     if (!_isUsernameAvailable && mounted) {
//       showCoolSnackBar(context, "Username is already taken", false);
//     }
//   }

//   Future<void> _checkPhoneNumber(SignupProvider provider) async {
//     if (_phoneController.text.isEmpty) return;

//     setState(() =>
//         _isPhoneAvailable = false); // Assume it's not available until confirmed

//     final isAvailable = await provider.checkPhoneNumber(_phoneController.text);

//     print("Phone number availability: $isAvailable"); // Debugging log

//     setState(() {
//       _isPhoneAvailable = isAvailable;
//     });

//     if (!_isPhoneAvailable && mounted) {
//       showCoolSnackBar(context, "Phone number is already registered", false);
//     }
//   }

//   Future<void> _submitForm(SignupProvider provider) async {
//     if (!_formKey.currentState!.validate()) return;
//     if (!_isUsernameAvailable || !_isPhoneAvailable) {
//       showCoolSnackBar(
//           context, "Please fix the errors before submitting", false);
//       return;
//     }

//     final success = await provider.completeProfile(
//       email: widget.email,
//       userName: _userNameController.text,
//       fullName: _fullNameController.text,
//       phoneNumber: _phoneController.text,
//       address: _addressController.text,
//       gender: _selectedGender,
//       birthdate: DateFormat('yyyy-MM-dd').format(_selectedDate),
//       height: _height,
//       currentWeight: _weight,
//       fitnessLevel: _selectedFitnessLevel,
//       goalType: _selectedGoalType,
//       allergies: _allergiesController.text,
//       calorieGoals: _calorieGoals,
//       profileImage: _profileImage,
//     );

//     if (success && mounted) {
//       showCoolSnackBar(context,
//           "Profile completed successfully! Please log in to continue.", true);

//       // Redirect to login page
//       await Future.delayed(const Duration(milliseconds: 1000));
//       if (mounted) {
//         context.go('/login');
//       }
//     } else if (mounted) {
//       showCoolSnackBar(context, provider.error, false);
//     }
//   }

//   Future<void> _selectDate() async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate,
//       firstDate: DateTime(1920),
//       lastDate: DateTime.now(),
//     );

//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final provider = Provider.of<SignupProvider>(context);

//     return Scaffold(
//       appBar: const CustomAppBar(
//         title: 'Complete Your Profile',
//         // showBackButton: true,
//       ),
//       body: provider.isLoading
//           ? const Center(child: CustomLoadingAnimation())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Profile image picker
//                     GestureDetector(
//                       onTap: _pickImage,
//                       child: CircleAvatar(
//                         radius: 60,
//                         backgroundColor:
//                             theme.colorScheme.primary.withOpacity(0.2),
//                         backgroundImage: _profileImage != null
//                             ? FileImage(_profileImage!)
//                             : null,
//                         child: _profileImage == null
//                             ? Icon(
//                                 Icons.add_a_photo,
//                                 size: 40,
//                                 color: theme.colorScheme.primary,
//                               )
//                             : null,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       'Add Profile Picture',
//                       style: theme.textTheme.bodyLarge,
//                     ),
//                     const SizedBox(height: 24),

//                     // Username field with availability check
//                     ProfileInput(
//                       controller: _userNameController,
//                       labelText: 'Username',
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Username is required';
//                         }
//                         if (!_isUsernameAvailable) {
//                           return 'Username is already taken';
//                         }
//                         return null;
//                       },
//                       onChanged: (_) {
//                         // Reset availability when typing
//                         setState(() => _isUsernameAvailable = true);
//                       },
//                       onFieldSubmitted: (_) => _checkUsername(provider),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _isUsernameAvailable
//                               ? Icons.check_circle_outline
//                               : Icons.error_outline,
//                           color:
//                               _isUsernameAvailable ? Colors.green : Colors.red,
//                         ),
//                         onPressed: () => _checkUsername(provider),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Full Name field
//                     ProfileInput(
//                       controller: _fullNameController,
//                       labelText: 'Full Name',
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Full name is required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Phone Number field with availability check
//                     ProfileInput(
//                       controller: _phoneController,
//                       labelText: 'Phone Number',
//                       keyboardType: TextInputType.phone,
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Phone number is required';
//                         }
//                         if (!_isPhoneAvailable) {
//                           return 'Phone number already registered';
//                         }
//                         return null;
//                       },
//                       onChanged: (_) {
//                         // Reset availability when typing
//                         setState(() => _isPhoneAvailable = true);
//                       },
//                       onFieldSubmitted: (_) => _checkPhoneNumber(provider),
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           _isPhoneAvailable
//                               ? Icons.check_circle_outline
//                               : Icons.error_outline,
//                           color: _isPhoneAvailable ? Colors.green : Colors.red,
//                         ),
//                         onPressed: () => _checkPhoneNumber(provider),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Address field
//                     ProfileInput(
//                       controller: _addressController,
//                       labelText: 'Address',
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Address is required';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Gender dropdown
//                     DropdownButtonFormField<String>(
//                       value: _selectedGender,
//                       decoration: InputDecoration(
//                         labelText: 'Gender',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         filled: true,
//                         fillColor: theme.colorScheme.surface,
//                       ),
//                       items: _genders.map((gender) {
//                         return DropdownMenuItem<String>(
//                           value: gender,
//                           child: Text(gender),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           setState(() {
//                             _selectedGender = value;
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Date of Birth picker
//                     GestureDetector(
//                       onTap: _selectDate,
//                       child: AbsorbPointer(
//                         child: ProfileInput(
//                           controller: TextEditingController(
//                             text:
//                                 DateFormat('dd/MM/yyyy').format(_selectedDate),
//                           ),
//                           labelText: 'Date of Birth',
//                           suffixIcon: const Icon(Icons.calendar_today),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),

//                     // Height slider
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Height: ${_height.toStringAsFixed(1)} cm',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                         Slider(
//                           value: _height,
//                           min: 100.0,
//                           max: 220.0,
//                           divisions: 120,
//                           label: _height.toStringAsFixed(1),
//                           onChanged: (value) {
//                             setState(() {
//                               _height = value;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),

//                     // Weight slider
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Weight: ${_weight.toStringAsFixed(1)} kg',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                         Slider(
//                           value: _weight,
//                           min: 30.0,
//                           max: 150.0,
//                           divisions: 120,
//                           label: _weight.toStringAsFixed(1),
//                           onChanged: (value) {
//                             setState(() {
//                               _weight = value;
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 16),

//                     // Fitness Level dropdown
//                     DropdownButtonFormField<String>(
//                       value: _selectedFitnessLevel,
//                       decoration: InputDecoration(
//                         labelText: 'Fitness Level',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         filled: true,
//                         fillColor: theme.colorScheme.surface,
//                       ),
//                       items: _fitnessLevels.map((level) {
//                         return DropdownMenuItem<String>(
//                           value: level,
//                           child: Text(level),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           setState(() {
//                             _selectedFitnessLevel = value;
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Goal Type dropdown
//                     DropdownButtonFormField<String>(
//                       value: _selectedGoalType,
//                       decoration: InputDecoration(
//                         labelText: 'Goal Type',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12.0),
//                         ),
//                         filled: true,
//                         fillColor: theme.colorScheme.surface,
//                       ),
//                       items: _goalTypes.map((goal) {
//                         return DropdownMenuItem<String>(
//                           value: goal,
//                           child: Text(goal),
//                         );
//                       }).toList(),
//                       onChanged: (value) {
//                         if (value != null) {
//                           setState(() {
//                             _selectedGoalType = value;
//                           });
//                         }
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Allergies field
//                     ProfileInput(
//                       controller: _allergiesController,
//                       labelText: 'Allergies (if any)',
//                     ),
//                     const SizedBox(height: 16),

//                     // Calorie Goals slider
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Daily Calorie Goal: $_calorieGoals',
//                           style: theme.textTheme.bodyLarge,
//                         ),
//                         Slider(
//                           value: _calorieGoals.toDouble(),
//                           min: 1200.0,
//                           max: 4000.0,
//                           divisions: 56,
//                           label: _calorieGoals.toString(),
//                           onChanged: (value) {
//                             setState(() {
//                               _calorieGoals = value.toInt();
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 24),

//                     // Submit button
//                     CustomButton(
//                       text: "Complete Profile",
//                       onPressed: () => _submitForm(provider),
//                     ),
//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/providers/multipage_register_provider/signup_provider.dart';
import 'package:gymify/utils/custom_appbar.dart';
import 'package:gymify/utils/custom_button.dart';
import 'dart:async'; //
import 'package:gymify/utils/custom_loader.dart';
import 'package:gymify/utils/custom_snackbar.dart';
import 'package:gymify/utils/workout_utils.dart/profile_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfileCompletionScreen extends StatefulWidget {
  final String email;

  const ProfileCompletionScreen({super.key, required this.email});

  @override
  State<ProfileCompletionScreen> createState() =>
      _ProfileCompletionScreenState();
}

class _ProfileCompletionScreenState extends State<ProfileCompletionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();

  // Selected values
  String _selectedGender = 'Male';
  DateTime _selectedDate = DateTime.now()
      .subtract(const Duration(days: 365 * 20)); // Default to 20 years ago
  double _height = 170.0; // Default height in cm
  double _weight = 70.0; // Default weight in kg
  String _selectedFitnessLevel = 'Beginner';
  String _selectedGoalType = 'Weight_Loss';
  int _calorieGoals = 2000; // Default calorie goal

  File? _profileImage;
  bool _isUsernameAvailable = true;
  bool _isPhoneAvailable = true;

  // Lists for dropdowns
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _fitnessLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Athlete'
  ];
  final List<String> _goalTypes = [
    'Weight_Loss',
    'Muscle_Gain',
    'Maintenance',
    'Endurance',
    'Flexibility'
  ];

  @override
  void dispose() {
    _userNameController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _allergiesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      showCoolSnackBar(context, "Error picking image: $e", false);
    }
  }

  Future<void> _checkUsername(SignupProvider provider) async {
    if (_userNameController.text.isEmpty) return;

    setState(() => _isUsernameAvailable =
        false); // Assume it's not available until confirmed

    final isAvailable = await provider.checkUsername(_userNameController.text);

    setState(() {
      _isUsernameAvailable = isAvailable;
    });

    if (!_isUsernameAvailable && mounted) {
      showCoolSnackBar(context, "Username is already taken", false);
    }
  }

  Future<void> _checkPhoneNumber(SignupProvider provider) async {
    if (_phoneController.text.isEmpty) return;

    setState(() =>
        _isPhoneAvailable = false); // Assume it's not available until confirmed

    final isAvailable = await provider.checkPhoneNumber(_phoneController.text);

    print("Phone number availability: $isAvailable"); // Debugging log

    setState(() {
      _isPhoneAvailable = isAvailable;
    });

    if (!_isPhoneAvailable && mounted) {
      showCoolSnackBar(context, "Phone number is already registered", false);
    }
  }

  Future<void> _submitForm(SignupProvider provider) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isUsernameAvailable || !_isPhoneAvailable) {
      showCoolSnackBar(
          context, "Please fix the errors before submitting", false);
      return;
    }

    final success = await provider.completeProfile(
      email: widget.email,
      userName: _userNameController.text,
      fullName: _fullNameController.text,
      phoneNumber: _phoneController.text,
      address: _addressController.text,
      gender: _selectedGender,
      birthdate: DateFormat('yyyy-MM-dd').format(_selectedDate),
      height: _height,
      currentWeight: _weight,
      fitnessLevel: _selectedFitnessLevel,
      goalType: _selectedGoalType,
      allergies: _allergiesController.text,
      calorieGoals: _calorieGoals,
      profileImage: _profileImage,
    );

    if (success && mounted) {
      showCoolSnackBar(context,
          "Profile completed successfully! Please log in to continue.", true);

      // Redirect to login page
      await Future.delayed(const Duration(milliseconds: 1000));
      if (mounted) {
        context.go('/login');
      }
    } else if (mounted) {
      showCoolSnackBar(context, provider.error, false);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = Provider.of<SignupProvider>(context);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Complete Your Profile',
        // showBackButton: true,
      ),
      body: provider.isLoading
          ? const Center(child: CustomLoadingAnimation())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Profile image picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.2),
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : null,
                        child: _profileImage == null
                            ? Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Add Profile Picture',
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),

                    // Username field with availability check
                    ProfileInput(
                      controller: _userNameController,
                      labelText: 'Username',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username is required';
                        }
                        if (!_isUsernameAvailable) {
                          return 'Username is already taken';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        // Reset availability when typing
                        setState(() => _isUsernameAvailable = true);
                      },
                      onFieldSubmitted: (_) => _checkUsername(provider),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isUsernameAvailable
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color:
                              _isUsernameAvailable ? Colors.green : Colors.red,
                        ),
                        onPressed: () => _checkUsername(provider),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Full Name field
                    ProfileInput(
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Full name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Phone Number field with availability check
                    ProfileInput(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        if (!_isPhoneAvailable) {
                          return 'Phone number already registered';
                        }
                        return null;
                      },
                      onChanged: (_) {
                        // Reset availability when typing
                        setState(() => _isPhoneAvailable = true);
                      },
                      onFieldSubmitted: (_) => _checkPhoneNumber(provider),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPhoneAvailable
                              ? Icons.check_circle_outline
                              : Icons.error_outline,
                          color: _isPhoneAvailable ? Colors.green : Colors.red,
                        ),
                        onPressed: () => _checkPhoneNumber(provider),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Address field
                    ProfileInput(
                      controller: _addressController,
                      labelText: 'Address',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Address is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Gender dropdown
                    DropdownButtonFormField<String>(
                      style: theme.textTheme.bodyLarge,
                      value: _selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      items: _genders.map((gender) {
                        return DropdownMenuItem<String>(
                          value: gender,
                          child: Text(gender),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedGender = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Date of Birth picker
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: ProfileInput(
                          controller: TextEditingController(
                            text:
                                DateFormat('dd/MM/yyyy').format(_selectedDate),
                          ),
                          labelText: 'Date of Birth',
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Height slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Height: ${_height.toStringAsFixed(1)} cm',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Slider(
                          value: _height,
                          min: 100.0,
                          max: 220.0,
                          divisions: 120,
                          label: _height.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              _height = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Weight slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Weight: ${_weight.toStringAsFixed(1)} kg',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Slider(
                          value: _weight,
                          min: 30.0,
                          max: 150.0,
                          divisions: 120,
                          label: _weight.toStringAsFixed(1),
                          onChanged: (value) {
                            setState(() {
                              _weight = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Fitness Level dropdown
                    DropdownButtonFormField<String>(
                      style: theme.textTheme.bodyLarge,
                      value: _selectedFitnessLevel,
                      decoration: InputDecoration(
                        labelText: 'Fitness Level',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      items: _fitnessLevels.map((level) {
                        return DropdownMenuItem<String>(
                          value: level,
                          child: Text(level),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedFitnessLevel = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Goal Type dropdown
                    DropdownButtonFormField<String>(
                      style: theme.textTheme.bodyLarge,
                      value: _selectedGoalType,
                      decoration: InputDecoration(
                        labelText: 'Goal Type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.surface,
                      ),
                      items: _goalTypes.map((goal) {
                        return DropdownMenuItem<String>(
                          value: goal,
                          child: Text(goal),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedGoalType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Allergies field
                    ProfileInput(
                      controller: _allergiesController,
                      labelText: 'Allergies (if any)',
                    ),
                    const SizedBox(height: 16),

                    // Calorie Goals slider
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Calorie Goal: $_calorieGoals',
                          style: theme.textTheme.bodyLarge,
                        ),
                        Slider(
                          value: _calorieGoals.toDouble(),
                          min: 1200.0,
                          max: 4000.0,
                          divisions: 56,
                          label: _calorieGoals.toString(),
                          onChanged: (value) {
                            setState(() {
                              _calorieGoals = value.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Submit button
                    CustomButton(
                      text: "Complete Profile",
                      onPressed: () => _submitForm(provider),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
}
