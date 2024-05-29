import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/password.dart';
import '../widgets/email.dart';
import '../../providers/auth_provider.dart';
import '../../providers/ui_provider.dart';

final emailFieldProvider = ChangeNotifierProvider((ref) => EmailFieldProvider());
final uiProviderProvider = ChangeNotifierProvider((ref) => UIProvider());

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
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
    final emailField = ref.watch(emailFieldProvider);

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
                        children: <TextSpan>[
                          const TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: 'Sign in Here',
                            style: const TextStyle(
                              color: Colors.blueGrey,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(context, '/login');
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                EmailField(controller: _emailController), // Pass controller
                const SizedBox(height: 10),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'User Name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey),
                    ),
                  ),
                  style: TextStyle(
                    fontFamily: 'San Serif',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                PasswordField(controller: _passwordController), // Pass controller
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final isValidEmail = emailField.isValid; // Check email validation
                    if (isValidEmail) {
                      await authProvider.signupUser(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      if (!authProvider.hasError) {
                        Navigator.pushNamed(context, '/notes');
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                'Signup Error',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              content: Text(authProvider.error ?? 'An unknown error occurred.'),
                              backgroundColor: Colors.grey[900],
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text(
                              'Invalid Email',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            content: const Text(
                              'Please enter a valid email address.',
                            ),
                            backgroundColor: Colors.grey[900],
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('OK'),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'San Serif',
                    ),
                  ),
                  child: authProvider.isLoading
                      ? CircularProgressIndicator()
                      : const Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
