import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:digital_notebook/data/dataProvider/user_provider.dart';
import 'package:digital_notebook/domain/models/user_model.dart';

final logoutProvider = Provider.autoDispose<void Function(BuildContext)>((ref) {
  return (BuildContext context) async {
    try {
      // Get the instance of SharedPreferences
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      
      // Retrieve the token from SharedPreferences
      final String? token = prefs.getString('authToken');
      
      // If the token is not found, show a message to the user
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Token not found. Please log in again.'),
          ),
        );
        return;
      }

      // Set the headers for the logout request, including the token
      final Map<String, String> headers = {'Authorization': 'Bearer $token'};

      // Make the HTTP POST request to the logout endpoint
      final response = await http.post(
        Uri.parse('http://localhost:3000/users/logout'),
        headers: headers,
      );

      // If the response status code indicates success, clear the token and navigate to the login page
      if (response.statusCode == 200) {
        await prefs.clear();
        
        // Reset the user in the userProvider
        ref.read(userProvider.notifier).setUser(User(id: '', username: '', email: '', password: ''));
        
        // Navigate to the login page
        context.go('/');
      } else {
        // If the response status code indicates failure, show a message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Logout failed. Please try again later.'),
          ),
        );
      }
    } catch (error) {
      // If an error occurs, show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $error'),
        ),
      );
    }
  };
});
