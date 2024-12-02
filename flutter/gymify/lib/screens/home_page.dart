// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:go_router/go_router.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:gymify/screens/main_screens/chat_screen.dart';
import 'package:gymify/screens/main_screens/diet_screen.dart';
import 'package:gymify/screens/main_screens/home_screen.dart';
import 'package:gymify/screens/main_screens/profile_screen.dart';
import 'package:gymify/screens/workout_screen.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _index = 0;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Home')),
//       body: _getBody(_index),
//       bottomNavigationBar: CurvedNavigationBar(
//         backgroundColor: Colors.white,
//         color: Colors.blue,
//         items: const <Widget>[
//           Icon(Icons.home, size: 30),
//           Icon(Icons.fitness_center, size: 30),
//           Icon(Icons.fastfood, size: 30),
//           Icon(Icons.chat, size: 30),
//           Icon(Icons.person, size: 30),
//         ],
//         onTap: (index) {
//           setState(() {
//             _index = index;
//           });
//           _navigateToPage(index);
//         },
//       ),
//     );
//   }

//   Widget _getBody(int index) {
//     switch (index) {
//       case 0:
//         return const HomeScreen();
//       case 1:
//         return const WorkoutScreen();
//       case 2:
//         return const DietScreen();
//       case 3:
//         return const ChatScreen();
//       case 4:
//         return const ProfileScreen();
//       default:
//         return const HomeScreen();
//     }
//   }

//   void _navigateToPage(int index) {
//     switch (index) {
//       case 0:
//         context.go('/home');
//         break;
//       case 1:
//         context.go('/workouts');
//         break;
//       case 2:
//         context.go('/diet');
//         break;
//       case 3:
//         context.go('/chat');
//         break;
//       case 4:
//         context.go('/profile');
//         break;
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gymify/services/login_service.dart';
 // Add your login screen

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;
  bool _isLoggedIn = false;
  final LoginService _loginService = LoginService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check login status and navigate accordingly
  Future<void> _checkLoginStatus() async {
    final isValidToken = await _loginService.isTokenValid();
    setState(() {
      _isLoggedIn = isValidToken;
    });

    if (_isLoggedIn) {
      // Navigate to Home Screen directly if logged in
      context.go('/home');
    } else {
      // Navigate to Login Screen if not logged in
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoggedIn) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // Show loading while checking login status
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: _getBody(_index),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.blue,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.fitness_center, size: 30),
          Icon(Icons.fastfood, size: 30),
          Icon(Icons.chat, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (index) {
          setState(() {
            _index = index;
          });
          _navigateToPage(index);
        },
      ),
    );
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const HomeScreen();
      case 1:
        //return const WorkoutScreen();
      case 2:
        return const DietScreen();
      case 3:
        return const ChatScreen();
      case 4:
        return const ProfileScreen();
      default:
        return const HomeScreen();
    }
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/workouts');
        break;
      case 2:
        context.go('/diet');
        break;
      case 3:
        context.go('/chat');
        break;
      case 4:
        context.go('/profile');
        break;
    }
  }
}
