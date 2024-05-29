import 'package:flutter/material.dart';

class EmailField extends StatefulWidget {
  const EmailField({super.key});

  @override
  EmailFieldState createState() => EmailFieldState();
}

class EmailFieldState extends State<EmailField> {
  final TextEditingController emailController = TextEditingController();
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final email = emailController.text.trim();
    final isValid = email.isNotEmpty && email.contains('@') && email.contains('.');
    setState(() {
      _isValid = isValid;
    });
  }

  bool isSignUpEnabled() {
    return _isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 57,
      padding: const EdgeInsets.all(1),
      child: TextField(
        controller: emailController,
        decoration: const InputDecoration(
          labelText: 'Email',
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 87, 85, 85),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
        ),
        style: const TextStyle(
          fontFamily: 'San Serif',
          fontSize: 16,
          color: Colors.black,
        ),
        onChanged: (_) => _validateEmail(),
      ),
    );
  }
}
