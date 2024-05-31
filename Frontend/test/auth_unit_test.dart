// import 'package:digital_notebook/data/dataProvider/auth_provider.dart';
// import 'package:flutter_test/flutter_test.dart';

// void main() {
//   group('AuthProvider Unit Tests', () {
//     late AuthProvider authProvider;

//     setUp(() {
//       authProvider = AuthProvider(none);
//     });

//     test('Error handling functions correctly', () {
//       expect(authProvider.hasError, false);

//       authProvider.setError('An error occurred');
//       expect(authProvider.hasError, true);
//       expect(authProvider.error, 'An error occurred');

//       authProvider.clearError();
//       expect(authProvider.hasError, false);
//       expect(authProvider.error, '');
//     });

//     test('Loading state is managed correctly', () {
//       expect(authProvider.isLoading, false);
//       authProvider.login('test@example.com', 'password123');  // Simulating login

//       // Assuming the method immediately sets loading to true
//       expect(authProvider.isLoading, true);

//       // Simulate completion
//       authProvider.isLoading = false; // Directly manipulating state for the test
//       expect(authProvider.isLoading, false);
//     });

//     // More tests for logout, deleteAccount, etc.
//   });
// }