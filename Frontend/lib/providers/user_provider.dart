import 'package:flutter_riverpod/flutter_riverpod.dart';

// User model definition
class User {
  final String id;
  final String username;
  final String email;
  final String password;

  User({this.id = '', this.username = '', this.email = '', this.password = ''});

  // Helper method to copy the user with modified fields
  User copyWith(
      {String? id, String? username, String? email, String? password}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}

// Provider to supply initial user data, represents no user logged in initially
final initialUserProvider = Provider<User>((ref) {
  return User(); // Returns an empty user indicating no user is logged in.
});

// StateNotifier for managing user state
class UserNotifier extends StateNotifier<User> {
  UserNotifier(User user) : super(user);

  void setUser(User user) {
    state = user;
  }

  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }
}

// Provider for the UserNotifier
final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  final initialUser = ref.read(initialUserProvider);
  return UserNotifier(initialUser);
});

// Repository class to handle authentication processes
class AuthRepository {
  final Ref ref;

  AuthRepository(this.ref);

  Future<void> login(String username, String password) async {
    // Simulate fetching user data from a backend service
    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
    String userId =
        'fetched_user_id'; // This should ideally be fetched from your backend.

    // Assuming a successful login, update the user provider
    User newUser = User(
        id: userId,
        username: username,
        email: 'user@example.com',
        password: password);
    ref.read(userProvider.notifier).setUser(newUser);
  }

  // Example logout method
  void logout() {
    ref.read(userProvider.notifier).setUser(User());
  }
}

// Example usage of the AuthRepository class in your app to login/logout
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref);
});
