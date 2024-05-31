import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';

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

  void updatename(String name) {
    state = state.copyWith(name: name);
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
