import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../domain/models/user_model.dart';

// Define custom NotFoundException
class NotFoundException implements Exception {
  final String message;
  NotFoundException(this.message);
}

// Define UserProfile class
class UserProfile {
  Future<User> updateUserProfile(String userId, String username, String email, String password) async {
    final String apiUrl = 'http://localhost:3000/users/update/$userId'; // Replace this with your actual API endpoint

    final Map<String, dynamic> updateUserDto = {
      'username': username,
      'email': email,
      'password': password, // Assuming password is already hashed if needed
    };

    final response = await http.patch(
      Uri.parse(apiUrl),
      headers: <String, String>{ 
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(updateUserDto),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      return User.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 404) {
      // If the server returns a 404 Not Found response
      throw NotFoundException("User not found");
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to update user profile');
    }
  }

  // Method to delete user profile
  Future<void> deleteUserProfile(String userId) async {
    final String apiUrl = 'http://localhost:3000/users/delete/$userId'; // Replace this with your actual API endpoint

    final response = await http.delete(
      Uri.parse(apiUrl),
      headers: <String, String>{ 
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, the user has been deleted
      return;
    } else if (response.statusCode == 404) {
      // If the server returns a 404 Not Found response
      throw NotFoundException("User not found");
    } else {
      // If the server returns an error response, throw an exception
      throw Exception('Failed to delete user profile');
    }
  }
}
