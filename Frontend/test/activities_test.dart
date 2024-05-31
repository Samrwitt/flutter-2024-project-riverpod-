import 'package:digital_notebook/data/dataProvider/activities_provider.dart';
import 'package:digital_notebook/domain/models/activity_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('ActivitiesNotifier Tests', () {
    test('Adding a new activity updates the state correctly', () {
      final container = ProviderContainer();
      final notifier = container.read(activitiesProvider.notifier);
      final initialLength = container.read(activitiesProvider).length;

      final testActivity = Activity(
        user: 'testUser',
        name: 'Test Activity',
        date: '2024-06-01',
        time: '12:00',
        logs: [],
        id: '1'
      );

      notifier.addActivity('testUser', 'Test Activity', DateTime(2024, 6, 1, 12), 'Admin');
      expect(container.read(activitiesProvider).length, initialLength + 1);
      expect(container.read(activitiesProvider).last, equals(testActivity));
    });
  });
}