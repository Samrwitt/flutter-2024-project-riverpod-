import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:digital_notebook/data/dataProvider/auth_provider.dart';
import 'package:digital_notebook/presentation/screens/admin/adminNotes.dart';

class AdminLogin extends ConsumerStatefulWidget {
  const AdminLogin({Key? key}) : super(key: key);

 @override
  ConsumerState<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends ConsumerState<AdminLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = ref.watch(authProviderProvider);

    ref.listen<AuthProvider>(authProviderProvider, (previous, next) {
      if (!next.hasError && !next.isLoading && next.currentUser != null) {
        context.go('/admin'); // Navigate to the notes page if login is successful
      }
    });
    return WillPopScope(
      onWillPop: () async{
        context.go('/');
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        title: const Text('Admin Login'),
      ),
      body: Center(
        child:Padding(padding:const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            // if (authProvider.isLoading)
            //   const Center(child: CircularProgressIndicator()),
            // if (authProvider.hasError)
            //   Text(
            //     authProvider.errorMessage ?? 'An error occurred',
            //     style: const TextStyle(color: Colors.red),
            //   ),
            ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () async {
                      await ref
                      .read(authProviderProvider.notifier)
                      .adminLogin(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      );
                  },
                   child: authProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.black),
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
      )
    );
  }
}
