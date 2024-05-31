import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import '../../data/models/user_model.dart';
import 'user_provider.dart';

final authProviderProvider = ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref));

class AuthProvider extends ChangeNotifier {
  final ChangeNotifierProviderRef ref;
  AuthProvider(this.ref);

  String _error = '';
  bool _hasError = false;
  bool _isLoading = false;

  String get error => _error;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;

  void setError(String error) {
    _error = error;
    _hasError = true;
    notifyListeners();
  }

  void clearError() {
    _error = '';
    _hasError = false;
    notifyListeners();
  }

  Future<void> registerUser(String name, String email, String password, BuildContext context) async {
    final String backendUrl = 'http://localhost:3000/users/register';

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      setError('Invalid email');
      return;
    }

    if (name.isEmpty) {
      setError('Username cannot be empty');
      return;
    }

    if (password.length < 8) {
      setError('Password must be at least 8 characters long');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users/register'),
        body: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final newUser = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          password: userData['password'],
        );
        ref.read(userProvider.notifier).setUser(newUser);
        context.go('/notes');
      } else {
        final responseData = json.decode(response.body);
        setError(responseData['message']);
      }
    } catch (error) {
      setError('An error occurred during registration');
      
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loginUser(String email, String password, BuildContext context) async {
    final String backendUrl = 'http://localhost:3000/users/login';

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users/login'),
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final newUser = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          password: userData['password'],
        );
        ref.read(userProvider.notifier).setUser(newUser);
        context.go('/notes');
      } else {
        final responseData = json.decode(response.body);
        setError(responseData['message']);
      }
    } catch (error) {
      setError('An error occurred during login');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
