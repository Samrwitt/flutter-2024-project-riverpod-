import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_provider.dart'; // Ensure you import the user_provider

final authProviderProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref));

class AuthProvider extends ChangeNotifier {
  final ChangeNotifierProviderRef ref;

  AuthProvider(this.ref);

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

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  Future<void> loginUser(String email, String password) async {
    _isLoading = true;
    _hasError = false;
    _error = null;
    notifyListeners();

    // Simulate a network request
    await Future.delayed(const Duration(seconds: 2));

    if (email == '' && password == '') {
      // Save user data to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userEmail', email);
      await prefs.setString('userPassword', password);

      // Update the userProvider with the logged-in user information
      ref.read(userProvider.notifier).setUser(
            User(id: '1', username: 'User', email: email, password: password),
          );

      _isLoading = false;
      _hasError = false;
      _error = null;
      notifyListeners();
    } else {
      _isLoading = false;
      _hasError = true;
      _error = 'Invalid email or password';
      notifyListeners();
    }
  }

  Future<void> signupUser(
      String username, String email, String password) async {
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _hasError = true;
      _error = 'Invalid email';
      notifyListeners();
      return;
    }

    if (username.isEmpty) {
      _hasError = true;
      _error = 'Username cannot be empty';
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

    // Simulate a network request
    await Future.delayed(const Duration(seconds: 2));

    // Simulate successful signup
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('userEmail', email);
    await prefs.setString('userPassword', password);

    // Update the userProvider with the signed-up user information
    ref.read(userProvider.notifier).setUser(
          User(id: '1', username: username, email: email, password: password),
        );

    _isLoading = false;
    _hasError = false;
    _error = null;
    notifyListeners();
  }
}
