import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//import  '../../providers/auth_provider.dart';

final emailFieldProvider = ChangeNotifierProvider((ref) => EmailFieldProvider());

class EmailFieldProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  bool _isValid = false;
  String _email = "";

  String get email => _email;
  bool get isValid => _isValid;

  void setEmail(String email) {
    _email = email;
    _isValid = validateEmail(email);
    notifyListeners();
  }

  bool validateEmail(String email) {
    return email.isNotEmpty && email.contains('@') && email.contains('.');
  }

  void updateEmail(String email) {
    _email = email;
    _isValid = validateEmail(email);
    notifyListeners();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}

class EmailField extends ConsumerWidget {
  final TextEditingController controller;

  const EmailField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(emailFieldProvider.notifier);

    return Container(
      height: 57,
      padding: const EdgeInsets.all(1),
      child: TextField(
        controller: controller,
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
        onChanged: (value) => provider.updateEmail(value),
      ),
    );
  }
}
