import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
import 'package:gymify/utils/custom_button.dart';
import 'package:gymify/utils/custom_input.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymify/colors/custom_colors.dart';

// Username Page
class UserNamePage extends StatefulWidget {
  const UserNamePage({super.key});

  @override
  State<UserNamePage> createState() => _UserNamePageState();
}

class _UserNamePageState extends State<UserNamePage> {
  // Create a single controller instance for the username input field
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    // Dispose of the controller to prevent memory leaks
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text("How do you want us to  know you",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                CustomInput(
                  controller: _usernameController,
                  hintText: 'Username',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(0xFFF6F6F6),
                  errorText: provider.usernameError,
                  onChanged: provider.setUserName,
                ),
              ],
            ),
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (provider.usernameError == null &&
                    provider.userName.isNotEmpty) {
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

    return Scaffold(
      
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Full Name input section
            Column(
              children: [
                const Text(
                  "Tell us your full name",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                CustomInput(
                  controller: _fullNameController,
                  hintText: 'Full Name',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(0xFFF6F6F6),
                  onChanged: provider.setFullName,
                ),
              ],
            ),
            // Custom "Next" button
            CustomButton(
              text: 'NEXT',
              onPressed: () {
                if (provider.fullName.isNotEmpty) {
                  context.pushNamed('email'); // Navigate to the next screen
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

    return Scaffold(
      
      backgroundColor: Colors.white, // Custom background color

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text("Enter your email",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 32),
                // Custom Input widget
                CustomInput(
                  controller: _emailController, // Use the controller for email
                  hintText: 'email',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(0xFFF6F6F6),
                  errorText:
                      provider.emailError, // Bind error text from provider
                  onChanged: provider.setEmail, // Update email state on change
                ),
              ],
            ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (provider.emailError == null && provider.email.isNotEmpty) {
                  context.pushNamed(
                      'phonenumber'); // Navigate to the next screen
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

    return Scaffold(
      backgroundColor: Colors.white, // Custom background color
      
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Same padding as EmailPage
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  "Enter Phone Number to let us contact you",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                // Custom Input widget for phone number
                CustomInput(
                  controller:
                      _phoneNumberController, // Use the controller for phone number
                  hintText: 'Phone Number',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(0xFFF6F6F6),
                  errorText: provider
                      .phoneNumberError, // Bind error text from provider
                  onChanged: provider
                      .setPhoneNumber, // Update phone number state on change
                ),
              ],
            ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (provider.phoneNumberError == null &&
                    provider.phoneNumber.isNotEmpty) {
                  // Navigate to the password page
                      context.pushNamed(
                      'password'); 
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
  // Create a single controller instance for the password input field
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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

    // Password match validation only when "Next" button is clicked
    void validatePasswordMatch() {
      if (_passwordController.text != _confirmPasswordController.text) {
        //show error dialogue
        provider.passwordError = 'Passwords do not match';
      } else {
        provider.passwordError = null; // Clear error if passwords match
      }
    }

    return Scaffold(
      backgroundColor: CustomColors
          .white, // Set background color to white, matching other pages
      
      body: Padding(
        padding: const EdgeInsets.all(
            16.0), // Padding around the content, same as other pages
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text(
                  "Enter Password",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                // Custom Input widget for password
                CustomInput(
                  controller:
                      _passwordController, // Use the controller for password
                  hintText: 'Password',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(
                      0xFFF6F6F6), // Light gray background for input
                  errorText:
                      provider.passwordError, // Bind error text from provider
                  onChanged: (password) {
                    provider.setPassword(password);
                    // No validation here anymore
                  },
                  obscureText: true, // Obscure the password text
                ),
                const SizedBox(height: 16),
                // Custom Input widget for confirm password
                CustomInput(
                  controller:
                      _confirmPasswordController, // Use the controller for confirm password
                  hintText: 'Confirm Password',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(
                      0xFFF6F6F6), // Light gray background for input
                  errorText:
                      provider.passwordError, // Bind error text from provider
                  onChanged: (confirmPassword) {
                    // No validation here anymore
                  },
                  obscureText: true, // Obscure the password text
                ),
              ],
            ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                // Validate passwords on button press
                validatePasswordMatch(); // Check if passwords match

                // If passwords match and there is no error, navigate to the next page
                if (provider.passwordError == null &&
                    provider.password.isNotEmpty) {
                  
                      context.pushNamed(
                      'address');  // Navigate to the address page
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Address Page
class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);

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

    return Scaffold(
      
      backgroundColor: CustomColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text("Enter Address",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                CustomInput(
                  controller: _addressController,
                  hintText: 'Address',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(0xFFF6F6F6),
                  onChanged: provider.setAddress,
                ),
                const SizedBox(height: 16),
              ],
            ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (provider.address.isNotEmpty) {
                  
                  context.pushNamed(
                      'birthdate'); 
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Birthdate Page
class BirthDatePage extends StatelessWidget {
  const BirthDatePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      
      backgroundColor: CustomColors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Birthdate",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            
            TextButton(
                onPressed: () async {
                  DatePicker.showDatePicker(context,
                      showTitleActions: true,
                      minTime: DateTime(1990, 3, 5),
                      maxTime: DateTime(2011, 6, 7), onChanged: (date) {
                    print('change $date');
                  }, onConfirm: (date) {
                    final finalDate = DateFormat('yyyy-MM-dd').format(date);

                    provider.setBirthdate(finalDate);
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: const Text(
                  'show date time picker ',
                  style: TextStyle(color: CustomColors.primary, fontSize: 20),
                )),
            const SizedBox(height: 16),
            Text(provider.birthdate),
            ElevatedButton(
              onPressed: () {
                if (provider.birthdate.isNotEmpty) {
                  
                  context.pushNamed(
                      'height'); 
                }
              },
              child: const Text('Next'),
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

    return Scaffold(
      
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "What’s your fitness level?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Fitness Level Buttons
            FitnessLevelButton(
              level: "Beginner",
              isSelected: provider.fitnessLevel == "Beginner",
              onPressed: () {
                provider.setFitnessLevel("Beginner");
              },
            ),
            const SizedBox(height: 8),
            FitnessLevelButton(
              level: "Intermediate",
              isSelected: provider.fitnessLevel == "Intermediate",
              onPressed: () {
                provider.setFitnessLevel("Intermediate");
              },
            ),
            const SizedBox(height: 8),
            FitnessLevelButton(
              level: "Advanced",
              isSelected: provider.fitnessLevel == "Advanced",
              onPressed: () {
                provider.setFitnessLevel("Advanced");
              },
            ),
            const SizedBox(height: 8),
            FitnessLevelButton(
              level: "Athlete",
              isSelected: provider.fitnessLevel == "Athlete",
              onPressed: () {
                provider.setFitnessLevel("Athlete");
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Next',
              onPressed: () {
                
                    context.pushNamed(
                      'goaltype');  // Navigate to the goal type page
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
  final VoidCallback onPressed;

  const FitnessLevelButton({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 8), // Spacing between buttons
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.transparent
              : CustomColors.grey, // No background when selected
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? CustomColors.primary
                : Colors.transparent, // Add border when selected
            width: 2.0, // Border width
          ),
        ),
        child: Center(
          child: Text(
            level,
            style: TextStyle(
              color: isSelected
                  ? CustomColors.primary
                  : Colors.black, // Change text color when selected
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
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

    return Scaffold(
      
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Select Goal Type",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Goal Type Buttons
            GoalTypeButton(
              level: "Endurance",
              isSelected: provider.goalType == "Endurance",
              onPressed: () {
                provider.setGoalType("Endurance");
              },
            ),
            const SizedBox(height: 8),
            GoalTypeButton(
              level: "Muscle Gain",
              isSelected: provider.goalType == "Muscle_Gain",
              onPressed: () {
                provider.setGoalType("Muscle_Gain");
              },
            ),
            const SizedBox(height: 8),
            GoalTypeButton(
              level: "Maintain Weight",
              isSelected: provider.goalType == "Maintain_Weight",
              onPressed: () {
                provider.setGoalType("Maintain_Weight");
              },
            ),
            const SizedBox(height: 8),
            GoalTypeButton(
              level: "Maintenance",
              isSelected: provider.goalType == "Maintenance",
              onPressed: () {
                provider.setGoalType("Maintenance");
              },
            ),
            const SizedBox(height: 8),
            GoalTypeButton(
              level: "Flexibility",
              isSelected: provider.goalType == "Flexibility",
              onPressed: () {
                provider.setGoalType("Flexibility");
              },
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Next',
              onPressed: () {
                
                    context.pushNamed(
                      'caloriegoals');  // Navigate to the next page
              },
            ),
          ],
        ),
      ),
    );
  }
}

// GoalTypeButton widget for individual goal type buttons
class GoalTypeButton extends StatelessWidget {
  final String level;
  final bool isSelected;
  final VoidCallback onPressed;

  const GoalTypeButton({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        margin: const EdgeInsets.only(bottom: 8), // Spacing between buttons
        decoration: BoxDecoration(
          color: isSelected
              ? Colors.transparent
              : CustomColors.grey, // No background when selected
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? CustomColors.primary
                : Colors.transparent, // Add border when selected
            width: 2.0, // Border width
          ),
        ),
        child: Center(
          child: Text(
            level,
            style: TextStyle(
              color: isSelected
                  ? CustomColors.primary
                  : Colors.black, // Change text color when selected
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Calorie Goals Page
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

    return Scaffold(
      
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text("Enter Calorie Goals",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                CustomInput(
                  controller: _calorieGoalsController,
                  hintText: 'Calorie Goals',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(0xFFF6F6F6),
                  onChanged: provider.setCalorieGoals,
                ),
                const SizedBox(height: 16),
              ],
            ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                if (provider.calorieGoals.isNotEmpty) {
                  
                  context.pushNamed(
                      'allergies'); 
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Allergies Page
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

    return Scaffold(
      
      backgroundColor: CustomColors.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text("Enter Allergies",
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                CustomInput(
                  hintText: 'Allergies',
                  fontSize: 14,
                  textColor: Colors.black,
                  backgroundColor: const Color(0xFFF6F6F6),
                  onChanged: provider.setAllergies,
                  controller: _allergiesController,
                ),
                const SizedBox(height: 16),
              ],
            ),
            CustomButton(
              text: 'Next',
              onPressed: () {
                
                context.pushNamed(
                      'confirm'); 
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp,
              color: CustomColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: CustomColors.backgroundColor,
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
                    ? const Icon(Icons.camera_alt, size: 40, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 16),

            // Welcome Text
            Text(
              'Hi ${provider.userName}, Ready to build your body?',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: CustomColors.secondary,
              ),
            ),
            const SizedBox(height: 16),

            // Register Button
            CustomButton(
              text: 'Register',
              onPressed: () async {
                final result = await provider.submitRegistration();
                if (result['success']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registration Successful!')),
                  );
                  context.go('/login');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                            Text(result['message'] ?? 'Registration Failed')),
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
