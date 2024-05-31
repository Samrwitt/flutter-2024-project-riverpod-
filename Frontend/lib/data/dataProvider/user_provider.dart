import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_model.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

// Provider to supply initial user data, represents no user logged in initially
final initialUserProvider = Provider<User>((ref) {
  return User(
    id: '',
    username: '',
    email: '',
    password: '',
  );
});

// StateNotifier for managing user state
class UserNotifier extends StateNotifier<User> {
  UserNotifier(User user) : super(user);

  // Function to set a new user
  void setUser(User user) {
    state = user;
  }

  // Function to authenticate user
  Future<bool> authenticateUser(String username, String password) async {
    // Implement your authentication logic here. This is a placeholder example.
    // This should include server-side validation of username and password.
    if (username == 'example' && password == 'password') {
      // If authentication is successful, set the user state
      setUser(User(
        id: '1',
        username: username,
        email: 'example@example.com',
        password: hashPassword(password),
      ));
      return true;
    }
    return false;
  }

  // Function to update username
  void updateUsername(String username) {
    state = state.copyWith(username: username);
  }

  // Function to update email
  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  // Function to update password with hashing
  void updatePassword(String password) {
    state = state.copyWith(password: hashPassword(password));
  }

  // Function to hash password
  String hashPassword(String password) {
    final bytes = utf8.encode(password); // Convert password to bytes
    final hashed = sha256.convert(bytes); // Hash the password using SHA-256
    return hashed.toString(); // Convert hash to string and return
  }
}

// Provider for the UserNotifier
final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  final initialUser = ref.read(initialUserProvider);
  return UserNotifier(initialUser);
});
