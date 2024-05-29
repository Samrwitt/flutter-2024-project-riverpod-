import 'package:flutter/material.dart';

class AdminLoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  // Predefined admin credentials
  static const String _adminEmail = 'admin@example.com';
  static const String _adminPassword = 'password';

  void login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate a delay for demonstration purposes
    await Future.delayed(const Duration(seconds: 2), () {
      if (email == _adminEmail && password == _adminPassword) {
        _isLoading = false;
        _hasError = false;
        _errorMessage = null; // Clear any previous error message
      } else {
        _isLoading = false;
        _errorMessage = 'Invalid credentials';
      }
      notifyListeners();
    });
  }
}
