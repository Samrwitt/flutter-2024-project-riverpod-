import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:digital_notebook/providers/user_provider.dart';

// Provider for handling the logout functionality
final logoutProvider = Provider.autoDispose<void Function(BuildContext)>((ref) {
  return (BuildContext context) {
    context.go('/'); // Using GoRouter to navigate to the home or login page
  };
});

// Provider for handling the delete account functionality
final deleteAccountProvider =
    Provider.autoDispose<void Function(BuildContext)>((ref) {
  return (BuildContext context) {
    // Implement your delete account logic here
    context.go(
        '/'); // Assuming the logout process or redirect to a confirmation page
  };
});

// Provider for handling the update profile functionality
final updateProfileProvider =
    Provider.autoDispose<void Function(BuildContext)>((ref) {
  return (BuildContext context) {
    context.go('/updateProfile'); // Navigating using GoRouter
  };
});

class CircleAvatarWidget extends ConsumerWidget {
  const CircleAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logout = ref.watch(logoutProvider);
    final deleteAccount = ref.watch(deleteAccountProvider);
    final updateProfile = ref.watch(updateProfileProvider);
    final user = ref.watch(userProvider);

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'email',
            child: Text(
              user?.email ?? 'No Email',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            enabled: false, // This item is just a display for the email
          ),
          const PopupMenuDivider(),
          const PopupMenuItem<String>(
            value: 'updateProfile',
            child: Text('Update Profile'),
          ),
          const PopupMenuItem<String>(
            value: 'deleteAccount',
            child: Text('Delete Account'),
          ),
          const PopupMenuItem<String>(
            value: 'logout',
            child: Text('Logout'),
          ),
        ];
      },
      onSelected: (String value) {
        switch (value) {
          case 'updateProfile':
            updateProfile(context);
            break;
          case 'deleteAccount':
            deleteAccount(context);
            break;
          case 'logout':
            logout(context);
            break;
        }
      },
      child: const CircleAvatar(
        backgroundImage: AssetImage(
            'assets/images/avatar.png'), // Ensure this asset is correctly placed in your assets directory
      ),
    );
  }
}
