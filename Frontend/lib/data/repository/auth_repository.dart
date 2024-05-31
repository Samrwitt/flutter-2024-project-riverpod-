// lib/data/repositories/auth_repository.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:digital_notebook/domain/models/user_model.dart';

class AuthRepository {
  final storage = FlutterSecureStorage();

  String? _authToken;
  User? _currentUser;
  String? _userId;

  Future<User?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['access_token'] != null && responseBody['user'] != null) {
        await storage.write(key: 'authToken', value: responseBody['access_token']);
        await storage.write(key: 'userId', value: responseBody['user']['_id']);
        _authToken = responseBody['access_token'];
        _userId = responseBody['user']['_id'];
        _currentUser = User.fromJson(responseBody['user']);
        return _currentUser;
      } else {
        throw Exception('Invalid response data');
      }
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/users/logout'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_authToken'},
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'authToken');
      await storage.delete(key: 'userId');
      _authToken = null;
      _userId = null;
      _currentUser = null;
    } else {
      throw Exception('Failed to logout. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteAccount() async {
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
      _authToken = null;
      _userId = null;
      _currentUser = null;
    } else {
      throw Exception('Failed to delete account. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateAccount(String username, String email, String password) async {
    final response = await http.patch(
      Uri.parse('http://localhost:3000/users/update/$_userId'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_authToken'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final userData = jsonDecode(response.body);
      _currentUser = User.fromJson(userData);
    } else {
      final message = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Update failed: $message');
    }
  }

  Future<User?> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/users/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'email': email, 'password': password}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final userData = jsonDecode(response.body);
      _currentUser = User.fromJson(userData);
      return _currentUser;
    } else {
      final message = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Registration failed: $message');
    }
  }

  Future<User?> adminLogin(String email, String password) async {
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
      _currentUser = User.fromJson(responseBody['user']);
      return _currentUser;
    } else {
      throw Exception('Failed to login. Status code: ${response.statusCode}');
    }
  }

  Future<void> adminLogout() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/admin/logout'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_authToken'},
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'authToken');
      await storage.delete(key: 'userId');
      _authToken = null;
      _userId = null;
      _currentUser = null;
    } else {
      throw Exception('Failed to logout. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteAccountByAdmin(String adminUserId, String userIdToDelete) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3000/admin/delete/$userIdToDelete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_authToken',
      },
    );

    if (response.statusCode == 200) {
      // Account deleted successfully
    } else {
      throw Exception('Failed to delete user. Status code: ${response.statusCode}');
    }
  }
}
