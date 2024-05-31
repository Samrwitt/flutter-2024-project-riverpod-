import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/gestures.dart';
import '../widgets/email.dart';
import '../widgets/password.dart';
import '../../application/providers/auth_provider.dart';

final emailFieldProvider = ChangeNotifierProvider((ref) => EmailFieldProvider());

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authProviderProvider);

    ref.listen<AuthProvider>(authProviderProvider, (previous, next) {
      if (!next.hasError && !next.isLoading) {
        context.go('/notes');
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    'Welcome, New User',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(color: Colors.black),
                          ),
                          TextSpan(
                            text: 'Sign in Here',
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.go('/login');
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'name',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                EmailField(
                  controller: _emailController,
                ),
                const SizedBox(height: 10),
                PasswordField(
                  controller: _passwordController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: authProvider.isLoading
                      ? null
                      : () async {
                          await authProvider.registerUser(
                            _nameController.text.trim(),
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            context,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'San Serif',
                    ),
                  ),
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                ),
                if (authProvider.hasError)
                  Text(
                    authProvider.error,
                    style: const TextStyle(color: Colors.red),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
