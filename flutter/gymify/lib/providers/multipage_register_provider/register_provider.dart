// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:gymify/services/register_service.dart';

// class RegistrationProvider with ChangeNotifier {
//   final AuthService _authService = AuthService();

//   // Fields
//   String _userName = '';
//   String _email = '';
//   String _password = '';
//   String _phoneNumber = '';
//   String _fullName = '';
//   String _address = '';
//   String _gender = 'Male';
//   String _role = 'Member';
//   String _fitnessLevel = 'Beginner';
//   String _goalType = 'Muscle_Gain';
//   String _birthdate = '';
//   double _height = 0.0;
//   double _weight = 0.0;
//   String _calorieGoals = '';
//   String _cardNumber = '1';
//   String _allergies = '';
//   File? _profilePicture;

//   // Errors
//   String? _usernameError;
//   String? emailError;
//   String? phoneNumberError;
//   String? passwordError;

//   String? get usernameError => _usernameError;

//   // setter for usernameError
//   set usernameError(String? value) {
//     _usernameError = value;
//     notifyListeners();
//   }

//   Timer? _debounce;

//   void setUserName(String value) {
//     _userName = value.trim();
//     if (_debounce?.isActive ?? false) _debounce?.cancel();
//     _debounce = Timer(const Duration(milliseconds: 500), _validateUsername);
//     notifyListeners();
//   }

//   Future<void> _validateUsername() async {
//     if (_userName.isEmpty) {
//       _usernameError = 'Username cannot be empty';
//     } else {
//       try {
//         bool isAvailable = await _authService.checkUsername(_userName);
//         _usernameError = isAvailable ? null : 'Username is already taken';
//       } catch (e) {
//         _usernameError = 'Error validating username';
//       }
//     }
//     notifyListeners();
//   }

//   void setEmail(String value) {
//     _email = value.trim();
//     _validateEmail();
//     notifyListeners();
//     print(_email);
//   }

//   void setPassword(String value) {
//     _password = value.trim();
//     _validatePassword();
//     notifyListeners();
//     print(_password);
//   }

//   void setPhoneNumber(String value) {
//     _phoneNumber = value.trim();
//     _validatePhoneNumber();
//     notifyListeners();
//     print(_phoneNumber);
//   }

//   void setFullName(String value) {
//     _fullName = value.trim();
//     notifyListeners();
//     print(_fullName);
//   }

//   void setAddress(String value) {
//     _address = value.trim();
//     notifyListeners();
//     print(_address);
//   }

//   void setGender(String value) {
//     _gender = value;
//     notifyListeners();

//     print(_gender);
//   }

//   void setRole(String value) {
//     _role = value;
//     notifyListeners();
//   }

//   void setFitnessLevel(String value) {
//     _fitnessLevel = value;
//     notifyListeners();
//     print(_fitnessLevel);
//   }

//   void setGoalType(String value) {
//     _goalType = value;
//     notifyListeners();
//     print(_goalType);
//   }

//   void setBirthdate(String value) {
//     _birthdate = value;
//     notifyListeners();
//     print(_birthdate);
//   }

//   void setHeight(double value) {
//     _height = value;
//     notifyListeners();
//     print(_height);
//   }

//   void setWeight(double value) {
//     _weight = value;
//     notifyListeners();
//     print(_weight);
//   }

//   void setCalorieGoals(String value) {
//     _calorieGoals = value;
//     notifyListeners();
//     print(_calorieGoals);
//   }

//   void setCardNumber(String value) {
//     _cardNumber = value;
//     notifyListeners();
//   }

//   void setAllergies(String value) {
//     _allergies = value.trim();
//     notifyListeners();
//     print(_allergies);
//   }

//   void setProfilePicture(File? value) {
//     _profilePicture = value;
//     notifyListeners();
//     print(_profilePicture);
//   }

//   // Getters
//   String get userName => _userName;
//   String get email => _email;
//   String get password => _password;
//   String get phoneNumber => _phoneNumber;
//   String get fullName => _fullName;
//   String get address => _address;
//   String get gender => _gender;
//   String get role => _role;
//   String get fitnessLevel => _fitnessLevel;
//   String get goalType => _goalType;
//   String get birthdate => _birthdate;
//   double get height => _height;
//   double get weight => _weight;
//   String get calorieGoals => _calorieGoals;
//   String get cardNumber => _cardNumber;
//   String get allergies => _allergies;
//   File? get profilePicture => _profilePicture;

//   Future<void> _validateEmail() async {
//     if (_email.isEmpty || !_email.contains('@')) {
//       emailError = 'Enter a valid email';
//     } else {
//       bool isAvailable = await _authService.checkEmail(_email);
//       emailError = isAvailable ? null : 'Email is already registered';
//     }
//   }

//   Future<void> _validatePhoneNumber() async {
//     if (_phoneNumber.isEmpty) {
//       phoneNumberError = 'Phone number cannot be empty';
//     } else {
//       bool isAvailable = await _authService.checkPhoneNumber(_phoneNumber);
//       phoneNumberError =
//           isAvailable ? null : 'Phone number is already registered';
//     }
//   }

//   void _validatePassword() {
//     if (_password.length < 8) {
//       passwordError = 'Password must be at least 8 characters';
//     } else {
//       passwordError = null;
//     }
//   }

//   // Submit registration data
//   Future<Map<String, dynamic>> submitRegistration() async {
//     // print all before register

//     print(userName);
//     print(email);
//     print(password);
//     print(phoneNumber);
//     print(fullName);
//     print(address);
//     print(gender);
//     print(role);
//     print(fitnessLevel);
//     print(goalType);
//     print(birthdate);
//     print(height);
//     print(weight);
//     print(calorieGoals);
//     print(cardNumber);
//     print(allergies);
//     print(profilePicture);

//     return await _authService.registerUser(
//       userName: _userName,
//       fullName: _fullName,
//       email: _email,
//       password: _password,
//       phoneNumber: _phoneNumber,
//       address: _address,
//       gender: _gender,
//       role: _role,
//       fitnessLevel: _fitnessLevel,
//       goalType: _goalType,
//       birthdate: _birthdate,
//       height: _height,
//       weight: _weight,
//       calorieGoals: _calorieGoals,
//       cardNumber: _cardNumber,
//       allergies: _allergies,
//       profilePicture: _profilePicture,
//     );
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gymify/services/register_service.dart';

class RegistrationProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  // Fields
  String _userName = '';
  String _email = '';
  String _password = '';
  String _phoneNumber = '';
  String _fullName = '';
  String _address = '';
  String _gender = 'Male';
  String _role = 'Member';
  String _fitnessLevel = 'Beginner';
  String _goalType = 'Muscle_Gain';
  String _birthdate = '';
  double _height = 0.0;
  double _weight = 0.0;
  String _calorieGoals = '';
  String _cardNumber = '1';
  String _allergies = '';
  File? _profilePicture;

  // Errors
  String? _usernameError;
  String? _emailError;
  String? _phoneNumberError;
  String? _passwordError;

  Timer? _usernameDebounce;
  Timer? _emailDebounce;
  Timer? _phoneNumberDebounce;

  // Getters
  String? get usernameError => _usernameError;
  String? get emailError => _emailError;
  String? get phoneNumberError => _phoneNumberError;
  String? get passwordError => _passwordError;
  String get userName => _userName;
  String get email => _email;
  String get password => _password;
  String get phoneNumber => _phoneNumber;
  String get fullName => _fullName;
  String get address => _address;
  String get gender => _gender;
  String get role => _role;
  String get fitnessLevel => _fitnessLevel;
  String get goalType => _goalType;
  String get birthdate => _birthdate;
  double get height => _height;
  double get weight => _weight;
  String get calorieGoals => _calorieGoals;
  String get cardNumber => _cardNumber;
  String get allergies => _allergies;
  File? get profilePicture => _profilePicture;

  void setFullName(String value) {
    _fullName = value.trim();
    notifyListeners();
    print(_fullName);
  }

  void setAddress(String value) {
    _address = value.trim();
    notifyListeners();
    print(_address);
  }

  void setGender(String value) {
    _gender = value;
    notifyListeners();

    print(_gender);
  }

  void setRole(String value) {
    _role = value;
    notifyListeners();
  }

  void setFitnessLevel(String value) {
    _fitnessLevel = value;
    notifyListeners();
    print(_fitnessLevel);
  }

  void setGoalType(String value) {
    _goalType = value;
    notifyListeners();
    print(_goalType);
  }

  void setBirthdate(String value) {
    _birthdate = value;
    notifyListeners();
    print(_birthdate);
  }

  void setHeight(double value) {
    _height = value;
    notifyListeners();
    print(_height);
  }

  void setWeight(double value) {
    _weight = value;
    notifyListeners();
    print(_weight);
  }

  void setCalorieGoals(String value) {
    _calorieGoals = value;
    notifyListeners();
    print(_calorieGoals);
  }

  void setCardNumber(String value) {
    _cardNumber = value;
    notifyListeners();
  }

  void setAllergies(String value) {
    _allergies = value.trim();
    notifyListeners();
    print(_allergies);
  }

  void setProfilePicture(File? value) {
    _profilePicture = value;
    notifyListeners();
    print(_profilePicture);
  }

  // Setters
  set usernameError(String? value) {
    _usernameError = value;
    notifyListeners();
  }

  set emailError(String? value) {
    _emailError = value;
    notifyListeners();
  }

  set phoneNumberError(String? value) {
    _phoneNumberError = value;
    notifyListeners();
  }

  set passwordError(String? value) {
    _passwordError = value;
    notifyListeners();
  }

  void setUserName(String value) {
    _userName = value.trim();
    if (_usernameDebounce?.isActive ?? false) _usernameDebounce?.cancel();
    _usernameDebounce =
        Timer(const Duration(milliseconds: 500), _validateUsername);
    notifyListeners();
  }

  Future<void> _validateUsername() async {
    if (_userName.isEmpty) {
      usernameError = 'Username cannot be empty';
    } else {
      try {
        bool isAvailable = await _authService.checkUsername(_userName);
        usernameError = isAvailable ? null : 'Username is already taken';
      } catch (e) {
        usernameError = 'Error validating username';
      }
    }
  }

  void setEmail(String value) {
    _email = value.trim();
    if (_emailDebounce?.isActive ?? false) _emailDebounce?.cancel();
    _emailDebounce = Timer(const Duration(milliseconds: 500), _validateEmail);
    notifyListeners();
  }

  Future<void> _validateEmail() async {
    if (_email.isEmpty || !_email.contains('@')) {
      emailError = 'Enter a valid email';
    } else {
      try {
        bool isAvailable = await _authService.checkEmail(_email);
        emailError = isAvailable ? null : 'Email is already registered';
      } catch (e) {
        emailError = 'Error validating email';
      }
    }
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value.trim();
    if (_phoneNumberDebounce?.isActive ?? false) _phoneNumberDebounce?.cancel();
    _phoneNumberDebounce =
        Timer(const Duration(milliseconds: 500), _validatePhoneNumber);
    notifyListeners();
  }

  Future<void> _validatePhoneNumber() async {
    if (_phoneNumber.isEmpty) {
      phoneNumberError = 'Phone number cannot be empty';
    } else {
      try {
        bool isAvailable = await _authService.checkPhoneNumber(_phoneNumber);
        phoneNumberError =
            isAvailable ? null : 'Phone number is already registered';
      } catch (e) {
        phoneNumberError = 'Error validating phone number';
      }
    }
  }

  void setPassword(String value) {
    _password = value.trim();
    _validatePassword();
    notifyListeners();
  }

  // void _validatePassword() {
  //   if (_password.length < 8  ) {
  //     passwordError = 'Password must be at least 8 characters';
  //   } else {
  //     passwordError = null;
  //   }
  // }

  void _validatePassword() {
    final hasUpperCase = _password.contains(RegExp(r'[A-Z]'));
    final hasLowerCase = _password.contains(RegExp(r'[a-z]'));
    final hasDigit = _password.contains(RegExp(r'\d'));
    final hasSpecialCharacter =
        _password.contains(RegExp(r'[!@#\\$%^&*(),.?":{}|<>]'));

    if (_password.isEmpty) {
      passwordError = 'Password cannot be empty';
    } else if (_password.length < 8) {
      passwordError = 'Password must be at least 8 characters';
    } else if (!hasUpperCase) {
      passwordError = 'Password must contain at least one uppercase letter';
    } else if (!hasLowerCase) {
      passwordError = 'Password must contain at least one lowercase letter';
    } else if (!hasDigit) {
      passwordError = 'Password must contain at least one number';
    } else if (!hasSpecialCharacter) {
      passwordError = 'Password must contain at least one special character';
    } else {
      passwordError = null;
    }
  }

  // Other setters remain unchanged

  // Submit registration data
  Future<Map<String, dynamic>> submitRegistration() async {
    print(userName);
    print(email);
    print(password);
    print(phoneNumber);
    print(fullName);
    print(address);
    print(gender);
    print(role);
    print(fitnessLevel);
    print(goalType);
    print(birthdate);
    print(height);
    print(weight);
    print(calorieGoals);
    print(cardNumber);
    print(allergies);
    print(profilePicture);

    return await _authService.registerUser(
      userName: _userName,
      fullName: _fullName,
      email: _email,
      password: _password,
      phoneNumber: _phoneNumber,
      address: _address,
      gender: _gender,
      role: _role,
      fitnessLevel: _fitnessLevel,
      goalType: _goalType,
      birthdate: _birthdate,
      height: _height,
      weight: _weight,
      calorieGoals: _calorieGoals,
      cardNumber: _cardNumber,
      allergies: _allergies,
      profilePicture: _profilePicture,
    );
  }
}
