import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordFieldProvider extends ValueNotifier<bool> {
  PasswordFieldProvider() : super(true);

  void toggleObscureText() {
    value = !value;
  }
}

final passwordFieldProvider =
    ChangeNotifierProvider((ref) => PasswordFieldProvider());

class PasswordField extends ConsumerWidget {
  final TextEditingController controller;

  const PasswordField({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(passwordFieldProvider);

    return Container(
      height: 57,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: TextField(
          controller: controller,
          obscureText: provider.value,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            labelText: 'Password',
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            border: InputBorder.none,
            suffixIcon: IconButton(
              onPressed: () =>
                  ref.read(passwordFieldProvider.notifier).toggleObscureText(),
              icon: Icon(
                provider.value ? Icons.visibility_off : Icons.visibility,
                color: Colors.blueGrey,
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
