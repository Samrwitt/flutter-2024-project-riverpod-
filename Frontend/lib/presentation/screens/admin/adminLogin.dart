import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/password.dart';
import '../../widgets/email.dart';
import '../../../providers/admin_login_provider.dart';

// Define the state provider
final adminLoginProvider = ChangeNotifierProvider((ref) => AdminLoginProvider());

class AdminLoginPage extends ConsumerStatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends ConsumerState<AdminLoginPage> {
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
    final adminLogin = ref.watch(adminLoginProvider);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Admin Login',
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
                      'Welcome Back, Admin',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  EmailField(controller: _emailController), // Pass controller
                  const SizedBox(height: 20),
                  PasswordField(controller: _passwordController), // Pass controller
                  const SizedBox(height: 20),
                  if (adminLogin.errorMessage != null)
                    Text(
                      adminLogin.errorMessage!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: ()  {
                      adminLogin.login(
                        _emailController.text, // Use the email entered by the user
                        _passwordController.text, // Use the password entered by the user
                      );
                      if (!adminLogin.hasError) {
                        Navigator.pushReplacementNamed(context, '/admin');
                      }
                    },
                    child: adminLogin.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.blueGrey,
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(color: Colors.blueGrey),
                          ),
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
