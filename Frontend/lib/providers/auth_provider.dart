import 'package:flutter/material.dart';
//import 'package:digital_notebook/presentation/widgets/email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the state provider for authentication
final authProviderProvider = ChangeNotifierProvider((ref) => AuthProvider());

// Define the state provider for admin login
// final adminLoginProvider = ChangeNotifierProvider((ref) => AdminLoginProvider());

class AuthProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String _username = '';
  String? _error;
  bool _hasError = false;
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  String get username => _username;
  String? get error => _error;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setUsername(String value){
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<void> loginUser(String email, String password) async {
    // Login logic...
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _hasError = true;
      _error = 'invalid email';
      notifyListeners();
      return;
    }
  _isLoading = false;
    notifyListeners();
  }

  

  Future<void> signupUser(String email, String password) async {
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _hasError = true;
      _error = 'invalid email';
      notifyListeners();
      return;
    }

    if (username.isEmpty){
      _hasError=true;
      _error='username cannot be empty';
      notifyListeners();
      return;
    }

    if (password.length < 8) {
      _hasError = true;
      _error = 'Password must be at least 8 characters long';
      notifyListeners();
      return;
    }
    _isLoading = true;
    notifyListeners();
    try {
      // Implement your signup logic here
      // For example, make an API call to register the user
      // and update the _hasError and _error properties accordingly
      _hasError = false;
      _error = null;
    } catch (e) {
      _hasError = true;
      _error = 'Error signing up: $e';
    }
    _isLoading = false;
    notifyListeners();
  }


 bool _isValidEmail(String email) {
    // Email validation logic
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    // Password validation logic
    return password.length >= 8;
  }
}

// class AdminLoginProvider extends ChangeNotifier {
//   bool _isLoading = false;
//   String? _errorMessage;

//   bool get isLoading => _isLoading;
//   String? get errorMessage => _errorMessage;

//   void login() {
//     // Perform login logic here
//     _isLoading = true;
//     notifyListeners();

//     // Simulate a delay for demonstration purposes
//     Future.delayed(const Duration(seconds: 2), () {
//       _isLoading = false;
//       _errorMessage = 'Invalid credentials';
//       notifyListeners();
//     });
//   }
// }
