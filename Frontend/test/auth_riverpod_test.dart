import 'package:digital_notebook/data/dataProvider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthProvider Riverpod Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('Initial state is correct', () {
      final authProvider = container.read(authProviderProvider);
      expect(authProvider.isLoading, false);
      expect(authProvider.hasError, false);
      expect(authProvider.currentUser, isNull);
    });

    test('Login attempt updates state correctly', () async {
      final authProvider = container.read(authProviderProvider.notifier);
      authProvider.login('test@example.com', 'password123');
      await container.pump();
      expect(authProvider.isLoading, false);
      expect(authProvider.hasError, true);
      expect(authProvider.currentUser, isNull);
    });

    test('Logout attempt updates state correctly', () async {
      final authProvider = container.read(authProviderProvider.notifier);
      authProvider.logout();
      await container.pump();
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.hasError, false);
    });

    test('Account update reflects state changes', () async {
      final authProvider = container.read(authProviderProvider.notifier);
      authProvider.updateAccount('UpdatedName', 'newemail@example.com', 'newPassword123');
      await container.pump();
      expect(authProvider.isLoading, false);
      expect(authProvider.hasError, true);
      expect(authProvider.currentUser?.username, equals('UpdatedName'));
    });

    test('Registration initializes user correctly', () async {
      final authProvider = container.read(authProviderProvider.notifier);
      authProvider.register('NewUser', 'newuser@example.com', 'password123');
      await container.pump();
      expect(authProvider.isLoading, false);
      expect(authProvider.hasError, true);
      expect(authProvider.currentUser?.username, equals('NewUser'));
    });

    test('Deleting an account clears user data', () async {
      final authProvider = container.read(authProviderProvider.notifier);
      authProvider.deleteAccount();
      await container.pump();
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.hasError, true);
    });

    test('Admin login sets current user and token correctly', () async {
      final authProvider = container.read(authProviderProvider.notifier);
      authProvider.adminLogin('admin@example.com', 'adminPass123');
      await container.pump();
      expect(authProvider.isLoading, false);
      expect(authProvider.hasError, false);
      expect(authProvider.currentUser?.email, equals('admin@example.com'));
    });

    test('Admin logout clears admin data', () async {
      final authProvider = container.read(authProviderProvider.notifier);
      authProvider.adminLogout();
      await container.pump();
      expect(authProvider.currentUser, isNull);
      expect(authProvider.isLoading, false);
      expect(authProvider.hasError, false);
    });

    test('Error handling functions correctly', () {
      final authProvider = container.read(authProviderProvider.notifier);
      authProvider.setError('An error occurred');
      expect(authProvider.hasError, true);
      expect(authProvider.error, 'An error occurred');

      authProvider.clearError();
      expect(authProvider.hasError, false);
      expect(authProvider.error, '');
    });
  });
}