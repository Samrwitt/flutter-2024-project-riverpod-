import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final logoutProvider = Provider.autoDispose<void Function(BuildContext)>((ref) {
  return (BuildContext context) async {
    // Clear user data, example with SharedPreferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    context.go('/'); // Using GoRouter to navigate to the home or login page
  };
});
