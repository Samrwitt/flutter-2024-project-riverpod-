import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Define the state provider for authentication
final authProviderProvider = ChangeNotifierProvider((ref) => AuthProvider());

// Define the state provider for admin login
// final adminLoginProvider = ChangeNotifierProvider((ref) => AdminLoginProvider());

class AuthProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';
  String? _error;
  bool _hasError = false;
  bool _isLoading = false;

  String get email => _email;
  String get password => _password;
  String? get error => _error;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<void> loginUser(String email, String password) async {
    try {
      // Implement your login logic here
      // For example, make an API call to authenticate the user
      // and update the _hasError and _error properties accordingly
      _hasError = false;
      _error = null;
    } catch (e) {
      _hasError = true;
      _error = 'Error logging in: $e';
    }
    notifyListeners();
  }


Future<void> signupUser(String email, String password) async {
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
