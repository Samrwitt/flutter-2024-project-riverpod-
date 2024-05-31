import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/providers/auth_provider.dart';
import '../../application/providers/ui_provider.dart';
import '../widgets/email.dart';
import '../widgets/password.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authProviderProvider);

    ref.listen<AuthProvider>(authProviderProvider, (previous, next) {
      if (!next.hasError && !next.isLoading) {
        context.go('/notes'); // Navigate to the notes page if login is successful
      }
    });

    return WillPopScope(
      onWillPop: () async {
        context.go('/'); // Uses GoRouter to navigate to the homepage
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
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
                      'Welcome back, User',
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
                          children: <TextSpan>[
                            const TextSpan(
                              text: "Don't have an account? ",
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                            TextSpan(
                              text: 'Register Here',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  context.push('/signup'); // GoRouter navigation
                                },
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  EmailField(controller: _emailController),
                  const SizedBox(height: 20),
                  PasswordField(controller: _passwordController),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          // Implement forgot password logic
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: Colors.blueGrey,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: authProvider.isLoading
                        ? null
                        : () async {
                            await authProvider.loginUser(
                                _emailController.text.trim(),
                                _passwordController.text.trim(),
                                context);
                          },
                    child: authProvider.isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'Login',
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
      ),
    );
  }
}
