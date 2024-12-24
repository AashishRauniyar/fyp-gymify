import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymify/providers/multipage_register_provider/register_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gymify/colors/custom_colors.dart';

// Username Page
class UserNamePage extends StatelessWidget {
  const UserNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Username",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Username',
                errorText: provider.usernameError,
              ),
              onChanged: provider.setUserName,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.usernameError == null &&
                    provider.userName.isNotEmpty) {
                  context.go('/register/fullname');
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

// Full Name Page
class FullNamePage extends StatelessWidget {
  const FullNamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Full Name",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Full Name',
              ),
              onChanged: provider.setFullName,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.fullName.isNotEmpty) {
                  context.go('/register/email');
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

// Email Page
class EmailPage extends StatelessWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Email",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Email',
                errorText: provider.emailError,
              ),
              onChanged: provider.setEmail,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.emailError == null && provider.email.isNotEmpty) {
                  context.go('/register/phonenumber');
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

class PhoneNumberPage extends StatelessWidget {
  const PhoneNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);
    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Phone Number to let us contact you",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Phone Number',
                errorText: provider.phoneNumberError,
              ),
              onChanged: provider.setPhoneNumber,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.phoneNumberError == null &&
                    provider.phoneNumber.isNotEmpty) {
                  context.go('/register/password');
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

// Password Page
class PasswordPage extends StatelessWidget {
  const PasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Password",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
                errorText: provider.passwordError,
              ),
              onChanged: provider.setPassword,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.passwordError == null &&
                    provider.password.isNotEmpty) {
                  context.go('/register/address');
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

// Address Page
class AddressPage extends StatelessWidget {
  const AddressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Address",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Address',
              ),
              onChanged: provider.setAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.address.isNotEmpty) {
                  context.go('/register/birthdate');
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

// Birthdate Page
class BirthDatePage extends StatelessWidget {
  const BirthDatePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Birthdate",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  final finalDate = DateFormat('yyyy-MM-dd').format(date);
                  provider.setBirthdate(finalDate);
                }
              },
              child: const Text('Pick Birthdate'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.birthdate.isNotEmpty) {
                  context.go('/register/height');
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

// Height Page
class HeightPage extends StatelessWidget {
  const HeightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Height",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Height (cm)',
              ),
              onChanged: (value) {
                provider.setHeight(double.tryParse(value) ?? 0.0);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.height > 0) {
                  context.go('/register/weight');
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

// Weight Page
class WeightPage extends StatelessWidget {
  const WeightPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Weight",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Weight (kg)',
              ),
              onChanged: (value) {
                provider.setWeight(double.tryParse(value) ?? 0.0);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.weight > 0) {
                  context.go('/register/fitnesslevel');
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

// Fitness Level Page
class FitnessLevelPage extends StatelessWidget {
  const FitnessLevelPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Select Fitness Level",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: provider.fitnessLevel,
              items: ["Beginner", "Intermediate", "Advanced"]
                  .map((level) =>
                      DropdownMenuItem(value: level, child: Text(level)))
                  .toList(),
              onChanged: (value) {
                if (value != null) provider.setFitnessLevel(value);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/register/goaltype');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

// Goal Type Page
class GoalTypePage extends StatelessWidget {
  const GoalTypePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Select Goal Type",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: provider.goalType,
              items: ["Endurance", "Muscle_Gain", "Maintain Weight"]
                  .map((goal) =>
                      DropdownMenuItem(value: goal, child: Text(goal)))
                  .toList(),
              onChanged: (value) {
                if (value != null) provider.setGoalType(value);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/register/caloriegoals');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

// Calorie Goals Page
class CalorieGoalsPage extends StatelessWidget {
  const CalorieGoalsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Calorie Goals",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Calorie Goals',
              ),
              onChanged: provider.setCalorieGoals,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (provider.calorieGoals.isNotEmpty) {
                  context.go('/register/allergies');
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

// Allergies Page
class AllergiesPage extends StatelessWidget {
  const AllergiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RegistrationProvider>(context);

    return Scaffold(
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter Allergies",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Allergies',
              ),
              onChanged: provider.setAllergies,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.go('/register/confirm');
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

// // Confirm Registration Page
// class ConfirmRegistrationPage extends StatefulWidget {

//   const ConfirmRegistrationPage({super.key});

//   @override
//   State<ConfirmRegistrationPage> createState() => _ConfirmRegistrationPageState();
// }

// class _ConfirmRegistrationPageState extends State<ConfirmRegistrationPage> {

//   File? _profilePicture;
//   final ImagePicker _picker = ImagePicker();

//   // Function to pick profile picture
//   Future<void> _pickProfilePicture() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       // setState(() {
//         provide_profilePicture = File(pickedFile.path);
//       // });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<RegistrationProvider>(context);

//     return Scaffold(
//       backgroundColor: CustomColors.primary,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             GestureDetector(

//                 onTap: _pickProfilePicture,
//                 child: CircleAvatar(
//                   radius: 60,
//                   backgroundImage: _profilePicture != null
//                       ? FileImage(_profilePicture!)
//                       : null,
//                   child: _profilePicture == null
//                       ? const Icon(Icons.camera_alt, size: 50)
//                       : null,
//                 ),
//               ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () async {
//                 final result = await provider.submitRegistration();
//                 if (result['success']) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Registration Successful!')),
//                   );
//                   context.go('/home');
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text(result['message'] ?? 'Registration Failed')),
//                   );
//                 }
//               },
//               child: const Text('Register '),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ConfirmRegistrationPage extends StatefulWidget {
  const ConfirmRegistrationPage({Key? key}) : super(key: key);

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
      backgroundColor: CustomColors.primary,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                    ? const Icon(Icons.camera_alt, size: 50, color: Colors.grey)
                    : null,
              ),
            ),
            const SizedBox(height: 16),
            Text('Hi ${provider.userName}, Ready to build your body '),
            const SizedBox(height: 16),
            ElevatedButton(
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
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
