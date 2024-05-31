import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/models/user_model.dart'; // Ensure the path is correct based on your project structure.

final storage = FlutterSecureStorage();

final authProviderProvider =
    ChangeNotifierProvider<AuthProvider>((ref) => AuthProvider(ref));

class AuthProvider extends ChangeNotifier {
  AuthProvider(this.ref) {
    _loadAuthToken();
    _loadUserId();
  }

  final Ref ref;

  String? _authToken;
  User? _currentUser;
  String _error = '';
  String? _errorMessage;
  bool _hasError = false;
  bool _isLoading = false;
  String? _userId;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _hasError;
  String? get authToken => _authToken;
  String? get errorMessage => _errorMessage;
  String? get userId => _userId;

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

Future<void> login(String email, String password) async {
  clearError();
  _isLoading = true;
  notifyListeners();

  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      print('Response Body: $responseBody');

      // Check if responseBody contains the expected fields
      if (responseBody['access_token'] != null && responseBody['user'] != null) {
        await storage.write(key: 'authToken', value: responseBody['access_token']);
        await storage.write(key: 'userId', value: responseBody['user']['_id']);
        _authToken = responseBody['access_token'];
        _userId = responseBody['user']['_id'];
        print('Stored Auth token: $_authToken');
        print('Stored User ID: $_userId');

        // Ensure User.fromJson correctly parses the user data
        _currentUser = User.fromJson(responseBody['user']);
        print('Current User: $_currentUser');
        notifyListeners();
      } else {
        setError('Invalid response data');
      }
    } else {
      setError('Failed to login. Status code: ${response.statusCode}');
    }
  } catch (e) {
    setError('Failed to login: $e');
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}


  Future<void> logout() async {
    clearError();
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users/logout'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_authToken'},
      );

      if (response.statusCode == 200) {
        await storage.delete(key: 'authToken');
        await storage.delete(key: 'userId');
        print('Deleted Auth token and User ID');
        _authToken = null;
        _userId = null;
        _currentUser = null;
        notifyListeners();
      } else {
        setError('Failed to logout. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setError('Failed to logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    clearError();
    _isLoading = true;
    notifyListeners();

    try {
      if (_authToken == null || _userId == null) {
        throw Exception('Auth token or User ID is missing');
      }

      final response = await http.delete(
        Uri.parse('http://localhost:3000/users/delete/$_userId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        await storage.delete(key: 'authToken');
        await storage.delete(key: 'userId');
        print('Deleted Auth token and User ID');
        _authToken = null;
        _userId = null;
        _currentUser = null;
        notifyListeners();
      } else {
        setError('Failed to delete account. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setError('Failed to delete account: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAccount(String username, String email, String password) async {
    clearError();
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.patch(
        Uri.parse('http://localhost:3000/users/update/$_userId'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_authToken'},
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = jsonDecode(response.body);
        _currentUser = User.fromJson(userData);
        print('Updated User: $_currentUser');
        notifyListeners();
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Unknown error';
        setError('Update failed: $message');
      }
    } catch (e) {
      setError('An error occurred during update: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<User?> register(String username, String email, String password) async {
    clearError();
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = jsonDecode(response.body);
        _currentUser = User.fromJson(userData);
        print('Registered User: $_currentUser');
        notifyListeners();
        return _currentUser;
      } else {
        final message = jsonDecode(response.body)['message'] ?? 'Unknown error';
        setError('Registration failed: $message');
        return null;
      }
    } catch (e) {
      setError('An error occurred during registration: $e');
      return null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> adminLogin(String email, String password) async {
    clearError();
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/admin/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseBody = jsonDecode(response.body);
        await storage.write(key: 'authToken', value: responseBody['access_token']);
        await storage.write(key: 'userId', value: responseBody['user']['_id']);
        _authToken = responseBody['access_token'];
        _userId = responseBody['user']['_id'];
        print('Stored Auth token: $_authToken');
        print('Stored User ID: $_userId');

        _currentUser = User.fromJson(responseBody['user']);
        print('Current User: $_currentUser');
        notifyListeners();
      } else {
        setError('Failed to login. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setError('Failed to login: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
    Future<void> adminLogout() async {
    clearError();
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/admin/logout'),
        headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_authToken'},
      );

      if (response.statusCode == 200) {
        await storage.delete(key: 'authToken');
        await storage.delete(key: 'userId');
        print('Deleted Auth token and User ID');
        _authToken = null;
        _userId = null;
        _currentUser = null;
        notifyListeners();
      } else {
        setError('Failed to logout. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setError('Failed to logout: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccountByAdmin(String adminUserId, String userIdToDelete) async {
    clearError();
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.delete(
        Uri.parse('http://localhost:3000/admin/delete/$userIdToDelete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_authToken',
        },
      );

      if (response.statusCode == 200) {
        print('Deleted user with ID: $userIdToDelete by admin with ID: $adminUserId');
        notifyListeners();
      } else {
        setError('Failed to delete user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setError('Failed to delete user: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadAuthToken() async {
    try {
      final token = await storage.read(key: 'authToken');
      if (token != null) {
        _authToken = token;
        print('Auth token retrieved: $token');
      } else {
        print('No auth token found');
      }
    } catch (e) {
      print('Error reading auth token: $e');
    }
    notifyListeners();
  }

  Future<void> _loadUserId() async {
    try {
      final userId = await storage.read(key: 'userId');
      if (userId != null) {
        _userId = userId;
        print('User ID retrieved: $userId');
      } else {
        print('No user ID found');
      }
    } catch (e) {
      print('Error reading user ID: $e');
    }
    notifyListeners();
  }
}
