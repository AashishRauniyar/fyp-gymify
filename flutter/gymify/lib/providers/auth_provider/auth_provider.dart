import 'package:flutter/material.dart';
import 'package:gymify/services/login_service.dart';  // Import your LoginService

class AuthProvider extends ChangeNotifier {
  final LoginService _loginService = LoginService();

  bool _isLoggedIn = false;
  String? _userId;
  String? _role;

  bool get isLoggedIn => _isLoggedIn;
  String? get userId => _userId;
  String? get role => _role;

  /// Check if the user is logged in
  Future<void> checkLoginStatus() async {
    _isLoggedIn = await _loginService.isTokenValid();
    if (_isLoggedIn) {
      _userId = await _loginService.getUserId();
      _role = await _loginService.getRole();
    } else {
      _userId = null;
      _role = null;
    }
    notifyListeners(); // Notify listeners when state changes
  }

  /// Login the user
  Future<bool> login(String email, String password) async {
    final response = await _loginService.login(email: email, password: password);
    if (response['success']) {
      _isLoggedIn = true;
      _userId = response['user']['user_id'].toString();
      _role = response['user']['role'];
      notifyListeners(); // Notify listeners when state changes
      return true;
    } else {
      _isLoggedIn = false;
      _userId = null;
      _role = null;
      notifyListeners(); // Notify listeners when state changes
      return false;
    }
  }

  /// Logout the user
  Future<void> logout() async {
    await _loginService.logout();
    _isLoggedIn = false;
    _userId = null;
    _role = null;
    notifyListeners(); // Notify listeners when state changes
  }
}


  /**
   * to access token, user ID, and role in any screen, you can use the following code:
   * 
   * final authProvider = context.watch<AuthProvider>(); // Watch the provider for changes

    // Access the user role and user ID
    final userId = authProvider.userId;
    final role = authProvider.role;


    // If you are using an older version of Flutter, you can use the following code:
    final authProvider = context.read<AuthProvider>();

    // Access the user role and user ID
    final userId = authProvider.userId;
    final role = authProvider.role;
   */



/**
 * 
 * to access in stateful widget
 * 
 * class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String userId;
  late String role;

  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    userId = authProvider.userId ?? 'No user ID';
    role = authProvider.role ?? 'No role assigned';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: $userId'),
            Text('Role: $role'),
          ],
        ),
      ),
    );
  }
}

 */




/**
 * 
 * 
 * Accessing role and userId in non-UI classes (e.g., services)
If you need to access role or userId in a service or model (outside of UI widgets), you can do it by accessing the AuthProvider via the BuildContext in any widget and passing the values as arguments or using a method to fetch them.

For instance, inside a service, you might want to pass the AuthProvider as an argument:

dart
Copy code
class SomeService {
  final AuthProvider authProvider;

  SomeService({required this.authProvider});

  void someMethod() {
    final userId = authProvider.userId;
    final role = authProvider.role;
    // Do something with userId and role
  }
}
Then in your widget, you can pass the authProvider:

dart
Copy code
class SomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    final service = SomeService(authProvider: authProvider);

    // Now use service
    service.someMethod();

    return Scaffold(
      // Your widget UI
    );
  }
}
Summary:
Use context.watch<AuthProvider>() when you need to rebuild the widget when the AuthProvider changes.
Use context.read<AuthProvider>() when you don't need to rebuild the widget and just want to access the data once.
You can access role and userId directly from the AuthProvider wherever you need it, whether it's in UI screens, services, or models.
 */