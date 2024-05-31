import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Provider for handling the logout functionality
final logoutProvider = StateNotifierProvider<LogoutNotifier, bool>((ref) {
  return LogoutNotifier(ref);
});

class LogoutNotifier extends StateNotifier<bool> {
  LogoutNotifier(this.ref) : super(false);

  final Ref ref;

  Future<void> logout(BuildContext context) async {
    state = true; // Set loading state to true
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay for logout process
    context.go('/'); // Assuming '/' is the route to logout and redirect to
    state = false; // Set loading state to false
  }
}

class AdminCircleAvatarWidget extends ConsumerWidget {
  const AdminCircleAvatarWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(logoutProvider);

    return Stack(
      alignment: Alignment.center,
      children: [
        PopupMenuButton<String>(
          itemBuilder: (BuildContext context) {
            return [
              const PopupMenuItem<String>(
                value: 'admin',
                child: Text(
                  'Admin',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                enabled: false, // This item is just a display for the admin name
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'manageUsers',
                child: Text('Manage Users'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('Logout'),
              ),
            ];
          },
          onSelected: (String value) {
            switch (value) {
              case 'manageUsers':
                context.go('/manageUsers'); // Navigate using GoRouter
                break;
              case 'logout':
                context.go('/');
                // ref.read(logoutProvider.notifier).logout(context); // Execute logout function
                break;
            }
          },
          child: const CircleAvatar(
            backgroundImage: AssetImage(
                'assets/images/avatar.png'), // Ensure this asset is correctly placed in your assets directory
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.5),
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
