import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/user_model.dart';
import 'user_provider.dart';
import 'update_account_provider.dart'; // Ensure you import the UserProfile class

final deleteAccountProvider = Provider.autoDispose<void Function(BuildContext)>((ref) {
  return (BuildContext context) async {
    // Read the current user from the userProvider
    final user = ref.read(userProvider);

    try {
      // Create an instance of UserProfile to handle account deletion
      final userProfile = UserProfile();
      
      // Delete the user profile using the user's ID
      await userProfile.deleteUserProfile(user.id);
      
      // Reset the user state in the userProvider
      ref.read(userProvider.notifier).setUser(User(id: '', username: '', email: '', password: ''));
      
      // Navigate to the home or login screen after account deletion
      context.go('/');
    } catch (e) {
      // Handle any errors by showing a Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete account: $e')),
      );
    }
  };
});
