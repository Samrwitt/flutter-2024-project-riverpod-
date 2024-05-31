import 'package:flutter/material.dart';
import 'package:digital_notebook/presentation/screens/login.dart';
import 'package:digital_notebook/presentation/screens/signup.dart';

class PageSelector extends StatelessWidget {
  const PageSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const LoginPage(),
        const SizedBox(height: 20), // Add some spacing between login and signup pages
        const SignupPage(),
      ],
    );
  }
}
