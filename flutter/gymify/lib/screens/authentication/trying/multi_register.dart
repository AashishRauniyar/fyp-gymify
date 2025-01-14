import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:gymify/utils/custom_loader.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymify/colors/custom_colors.dart';

class UserNamePage extends StatefulWidget {
  const UserNamePage({super.key});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final textTheme =
        Theme.of(context).textTheme; // Access text styles from the theme

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "How do you want us to know you?",
                  style: textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomInput(
                  controller: _usernameController,
                  hintText: 'Enter your username',
                  fontSize: textTheme.bodyMedium?.fontSize ?? 14,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  errorText: provider.usernameError,
                  onChanged: provider.setUserName,
                ),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (_usernameController.text.trim().isEmpty) {
                  provider.usernameError = 'Username cannot be empty';
                } else if (provider.usernameError == null) {
                  context.pushNamed('fullname');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Full Name Page
class FullNamePage extends StatefulWidget {
  const FullNamePage({super.key});

  @override
  State<FullNamePage> createState() => _FullNamePageState();
}

class _FullNamePageState extends State<FullNamePage> {
  final TextEditingController _fullNameController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller to prevent memory leaks
    _fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Tell us your full name",
                  style: textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                CustomInput(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  fontSize: textTheme.bodyMedium?.fontSize ?? 14,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  errorText: provider.fullName.isEmpty
                      ? 'Full name cannot be empty'
                      : null,
                  onChanged: provider.setFullName,
                ),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (_fullNameController.text.trim().isEmpty) {
                  provider.setFullName(''); // Trigger error message
                } else {
                  context.pushNamed('gender');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GenderSelectionPage extends StatefulWidget {
  const GenderSelectionPage({super.key});

  @override
  State<GenderSelectionPage> createState() => _GenderSelectionPageState();
}

class _GenderSelectionPageState extends State<GenderSelectionPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "What’s your gender?",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => provider.setGender('Male'),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: provider.gender == 'Male'
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: provider.gender == 'Male'
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/gender/male.png',
                              height: 120,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Male",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => provider.setGender('Female'),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                          color: provider.gender == 'Female'
                              ? theme.colorScheme.primary.withOpacity(0.2)
                              : theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: provider.gender == 'Female'
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/gender/female.png',
                              height: 120,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Female",
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (provider.gender.isNotEmpty) {
                  context.pushNamed('email'); // Update with the next route
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select your gender',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EmailPage extends StatefulWidget {
  const EmailPage({super.key});

  @override
  State<EmailPage> createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  // Create a single controller instance for the email input field
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller to prevent memory leaks
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Enter your email",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Custom Input widget
                CustomInput(
                  controller: _emailController,
                  hintText: 'Email',
                  fontSize: theme.textTheme.bodyMedium?.fontSize ?? 14,
                  backgroundColor: theme.colorScheme.surface,
                  errorText: provider.emailError ??
                      (_emailController.text.trim().isEmpty
                          ? 'Email cannot be empty'
                          : null),
                  onChanged: provider.setEmail,
                ),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (_emailController.text.trim().isEmpty) {
                  provider.emailError = 'Email cannot be empty';
                } else if (provider.emailError == null) {
                  context
                      .pushNamed('phonenumber'); // Navigate to the next screen
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  State<PhoneNumberPage> createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  // Create a single controller instance for the phone number input field
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller to prevent memory leaks
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Enter Phone Number to let us contact you",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Custom Input widget for phone number
                CustomInput(
                  controller: _phoneNumberController,
                  hintText: 'Phone Number',
                  fontSize: theme.textTheme.bodyMedium?.fontSize ?? 14,
                  backgroundColor: theme.colorScheme.surface,
                  errorText: provider.phoneNumberError ??
                      (_phoneNumberController.text.trim().isEmpty
                          ? 'Phone number cannot be empty'
                          : null),
                  onChanged: provider.setPhoneNumber,
                ),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (_phoneNumberController.text.trim().isEmpty) {
                  provider.phoneNumberError = 'Phone number cannot be empty';
                } else if (provider.phoneNumberError == null) {
                  context
                      .pushNamed('password'); // Navigate to the password page
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Password Page
class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  // Create controller instances for the password and confirm password input fields
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    // Dispose of the controllers to prevent memory leaks
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    // Password match validation only when "Next" button is clicked
    void validatePasswordMatch() {
      if (_passwordController.text != _confirmPasswordController.text) {
        provider.passwordError = 'Passwords do not match';
      } else {
        provider.passwordError = null; // Clear error if passwords match
      }
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Enter Password",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Custom Input widget for password
                CustomInput(
                  controller: _passwordController,
                  hintText: 'Password',
                  fontSize: theme.textTheme.bodyMedium?.fontSize ?? 14,
                  backgroundColor: theme.colorScheme.surface,
                  errorText: provider.passwordError,
                  onChanged: (password) {
                    provider.setPassword(password);
                  },
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: CustomColors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Custom Input widget for confirm password
                CustomInput(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  fontSize: theme.textTheme.bodyMedium?.fontSize ?? 14,
                  backgroundColor: theme.colorScheme.surface,
                  errorText: provider.passwordError,
                  onChanged: (confirmPassword) {},
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: CustomColors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                // Validate passwords on button press
                validatePasswordMatch();

                // If passwords match and there is no error, navigate to the next page
                if (provider.passwordError == null &&
                    provider.password.isNotEmpty) {
                  context.pushNamed('address'); // Navigate to the address page
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "Enter Address",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                CustomInput(
                  controller: _addressController,
                  hintText: 'Address',
                  fontSize: theme.textTheme.bodyMedium?.fontSize ?? 14,
                  backgroundColor: theme.colorScheme.surface,
                  errorText: _addressController.text.trim().isEmpty
                      ? 'Address cannot be empty'
                      : null,
                  onChanged: provider.setAddress,
                ),
                const SizedBox(height: 16),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (_addressController.text.trim().isEmpty) {
                  provider.setAddress(''); // Trigger validation
                } else {
                  context.pushNamed('birthdate');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BirthDatePage extends StatelessWidget {
  const BirthDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(
                  "When is your birthday?",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () async {
                    DatePicker.showDatePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(1990, 1, 1),
                      maxTime: DateTime(DateTime.now().year - 12, 12, 31),
                      onConfirm: (date) {
                        final formattedDate =
                            DateFormat('yyyy-MM-dd').format(date);
                        provider.setBirthdate(formattedDate);
                      },
                      currentTime: DateTime.now(),
                      locale: LocaleType.en,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      provider.birthdate.isEmpty
                          ? 'Tap to select your birthdate'
                          : 'Selected Date: ${provider.birthdate}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: provider.birthdate.isEmpty
                            ? theme.colorScheme.onSurface.withOpacity(0.6)
                            : theme.colorScheme.onSurface,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (provider.birthdate.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select your birthdate',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                } else {
                  context.pushNamed('height');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FitnessLevelPage extends StatefulWidget {
  const FitnessLevelPage({super.key});

  @override
  State<FitnessLevelPage> createState() => _FitnessLevelPageState();
}

class _FitnessLevelPageState extends State<FitnessLevelPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "What’s your fitness level?",
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FitnessLevelButton(
              level: "Beginner",
              isSelected: provider.fitnessLevel == "Beginner",
              theme: theme,
              onPressed: () {
                provider.setFitnessLevel("Beginner");
              },
            ),
            const SizedBox(height: 16),
            FitnessLevelButton(
              level: "Intermediate",
              isSelected: provider.fitnessLevel == "Intermediate",
              theme: theme,
              onPressed: () {
                provider.setFitnessLevel("Intermediate");
              },
            ),
            const SizedBox(height: 16),
            FitnessLevelButton(
              level: "Advanced",
              isSelected: provider.fitnessLevel == "Advanced",
              theme: theme,
              onPressed: () {
                provider.setFitnessLevel("Advanced");
              },
            ),
            const SizedBox(height: 16),
            FitnessLevelButton(
              level: "Athlete",
              isSelected: provider.fitnessLevel == "Athlete",
              theme: theme,
              onPressed: () {
                provider.setFitnessLevel("Athlete");
              },
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (provider.fitnessLevel.isNotEmpty) {
                  context
                      .pushNamed('goaltype'); // Navigate to the goal type page
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select your fitness level',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FitnessLevelButton extends StatelessWidget {
  final String level;
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onPressed;

  const FitnessLevelButton({
    super.key,
    required this.level,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          level,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}



class GoalTypePage extends StatelessWidget {
  const GoalTypePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Select your goal type",
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            GoalTypeButton(
              level: "Endurance",
              isSelected: provider.goalType == "Endurance",
              theme: theme,
              onPressed: () => provider.setGoalType("Endurance"),
            ),
            const SizedBox(height: 16),
            GoalTypeButton(
              level: "Muscle Gain",
              isSelected: provider.goalType == "Muscle_Gain",
              theme: theme,
              onPressed: () => provider.setGoalType("Muscle_Gain"),
            ),
            const SizedBox(height: 16),
            GoalTypeButton(
              level: "Maintain Weight",
              isSelected: provider.goalType == "Maintain_Weight",
              theme: theme,
              onPressed: () => provider.setGoalType("Maintain_Weight"),
            ),
            const SizedBox(height: 16),
            GoalTypeButton(
              level: "Flexibility",
              isSelected: provider.goalType == "Flexibility",
              theme: theme,
              onPressed: () => provider.setGoalType("Flexibility"),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (provider.goalType.isNotEmpty) {
                  context.pushNamed('caloriegoals');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please select a goal type',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class GoalTypeButton extends StatelessWidget {
  final String level;
  final bool isSelected;
  final ThemeData theme;
  final VoidCallback onPressed;

  const GoalTypeButton({
    super.key,
    required this.level,
    required this.isSelected,
    required this.theme,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.2)
              : theme.colorScheme.surfaceContainerHighest,
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.colorScheme.outline,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            level,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class CalorieGoalsPage extends StatefulWidget {
  const CalorieGoalsPage({super.key});

  @override
  State<CalorieGoalsPage> createState() => _CalorieGoalsPageState();
}

class _CalorieGoalsPageState extends State<CalorieGoalsPage> {
  final TextEditingController _calorieGoalsController = TextEditingController();

  @override
  void dispose() {
    _calorieGoalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      // appBar: AppBar(
      //   title: Text(
      //     "Calorie Goals",
      //     style: theme.textTheme.headlineSmall?.copyWith(
      //       color: theme.colorScheme.onPrimary,
      //     ),
      //   ),
      //   backgroundColor: theme.colorScheme.primary,
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Enter your calorie goals",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomInput(
                  controller: _calorieGoalsController,
                  hintText: 'Calorie Goals',
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  onChanged: provider.setCalorieGoals,
                ),
              ],
            ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (provider.calorieGoals.isNotEmpty) {
                  context.pushNamed('allergies');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter calorie goals',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AllergiesPage extends StatefulWidget {
  const AllergiesPage({super.key});

  @override
  State<AllergiesPage> createState() => _AllergiesPageState();
}

class _AllergiesPageState extends State<AllergiesPage> {
  final TextEditingController _allergiesController = TextEditingController();

  @override
  void dispose() {
    _allergiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      // appBar: AppBar(
      //   // title: Text(
      //   //   "Allergies",
      //   //   style: theme.textTheme.headlineSmall?.copyWith(
      //   //     color: theme.colorScheme.onPrimary,
      //   //   ),
      //   // ),
      //   // backgroundColor: theme.colorScheme.primary,
      //   centerTitle: true,
      //   elevation: 0,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  "Enter your allergies (if any)",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                CustomInput(
                  controller: _allergiesController,
                  hintText: 'Allergies',
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  onChanged: provider.setAllergies,
                ),
              ],
            ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (provider.allergies.isNotEmpty) {
                  context.pushNamed('confirm');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Please enter allergies or type "None"',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onError,
                        ),
                      ),
                      backgroundColor: theme.colorScheme.error,
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmRegistrationPage extends StatefulWidget {
  const ConfirmRegistrationPage({super.key});

  @override
  State<ConfirmRegistrationPage> createState() =>
      _ConfirmRegistrationPageState();
}

class _ConfirmRegistrationPageState extends State<ConfirmRegistrationPage> {
  File? _profilePicture;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;

  // Function to pick profile picture
  Future<void> _pickProfilePicture() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Profile Picture Section
            GestureDetector(
              onTap: () async {
                await _pickProfilePicture();
                provider.setProfilePicture(_profilePicture);
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profilePicture != null
                    ? FileImage(_profilePicture!)
                    : null,
                child: _profilePicture == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      )
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Welcome Text
            Text(
              'Hi ${provider.userName}, Ready to build your body?',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Register Button or Loading Spinner
            _isLoading
                ? const CustomLoadingAnimation()
                : CustomButton(
                    text: 'Register',
                    onPressed: () async {
                      if (_profilePicture == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Profile picture is required!',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onError,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      final result = await provider.submitRegistration();
                      setState(() {
                        _isLoading = false;
                      });

                      if (result['success']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Registration Successful!',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                          ),
                        );
                        context.go('/login');
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              result['message'] ?? 'Registration Failed',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onError,
                              ),
                            ),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      }
                    },
                  )
          ],
        ),
      ),
    );
  }
}
