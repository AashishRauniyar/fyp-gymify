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
  String? usernameError;
  String? emailError;
  String? phoneNumberError;
  String? passwordError;

  // Setters
  void setUserName(String value) {
    _userName = value;
    _validateUsername();
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    _validateEmail();
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    _validatePassword();
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    _validatePhoneNumber();
    notifyListeners();
  }

  void setFullName(String value) {
    _fullName = value;
    notifyListeners();
  }

  void setAddress(String value) {
    _address = value;
    notifyListeners();
  }

  void setGender(String value) {
    _gender = value;
    notifyListeners();
  }

  void setRole(String value) {
    _role = value;
    notifyListeners();
  }

  void setFitnessLevel(String value) {
    _fitnessLevel = value;
    notifyListeners();
  }

  void setGoalType(String value) {
    _goalType = value;
    notifyListeners();
  }

  void setBirthdate(String value) {
    _birthdate = value;
    notifyListeners();
  }

  void setHeight(double value) {
    _height = value;
    notifyListeners();
  }

  void setWeight(double value) {
    _weight = value;
    notifyListeners();
  }

  void setCalorieGoals(String value) {
    _calorieGoals = value;
    notifyListeners();
  }

  void setCardNumber(String value) {
    _cardNumber = value;
    notifyListeners();
  }

  void setAllergies(String value) {
    _allergies = value;
    notifyListeners();
  }

  void setProfilePicture(File? value) {
    _profilePicture = value;
    notifyListeners();
  }

  // Getters
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

  // Validation
  Future<void> _validateUsername() async {
    if (_userName.isEmpty) {
      usernameError = 'Username cannot be empty';
    } else {
      bool isAvailable = await _authService.checkUsername(_userName);
      usernameError = isAvailable ? null : 'Username is already taken';
    }
  }

  Future<void> _validateEmail() async {
    if (_email.isEmpty || !_email.contains('@')) {
      emailError = 'Enter a valid email';
    } else {
      bool isAvailable = await _authService.checkEmail(_email);
      emailError = isAvailable ? null : 'Email is already registered';
    }
  }

  Future<void> _validatePhoneNumber() async {
    if (_phoneNumber.isEmpty) {
      phoneNumberError = 'Phone number cannot be empty';
    } else {
      bool isAvailable = await _authService.checkPhoneNumber(_phoneNumber);
      phoneNumberError =
          isAvailable ? null : 'Phone number is already registered';
    }
  }

  void _validatePassword() {
    if (_password.length < 8) {
      passwordError = 'Password must be at least 8 characters';
    } else {
      passwordError = null;
    }
  }

  // Submit registration data
  Future<Map<String, dynamic>> submitRegistration() async {
    // print all before register

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
