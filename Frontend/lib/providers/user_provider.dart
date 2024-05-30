// providers/user_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) {
  final initialUser = ref.read(initialUserProvider); // Read the initial user data
  return UserNotifier(initialUser); // Pass the initial user data to the UserNotifier
});

final initialUserProvider = Provider<User>((ref) {
  return User(username: '', email: '', password: '');
});

class UserNotifier extends StateNotifier<User> {
  UserNotifier(User user) : super(user);

  void setUser(User user) {
    state = user;
  }

  void updateUsername(String username) {
    state = User(username: username, email: state.email, password: state.password);
  }

  void updateEmail(String email) {
    state = User(username: state.username, email: email, password: state.password);
  }

  void updatePassword(String password) {
    state = User(username: state.username, email: state.email, password: password);
  }
}
