import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'navigatorkey_provider.dart';

final logoutProvider = Provider.autoDispose((ref) {
  return () {
    final navigatorKey = ref.read(navigatorKeyProvider);
    navigatorKey.currentState?.pushReplacementNamed('/login');
  };
});
