import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    usernameController = TextEditingController(text: user.username);
    emailController = TextEditingController(text: user.email);
    passwordController = TextEditingController(text: user.password);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(userProvider.notifier).updateUsername(usernameController.text);
                ref.read(userProvider.notifier).updateEmail(emailController.text);
                ref.read(userProvider.notifier).updatePassword(passwordController.text);
                Navigator.of(context).pop(); // Navigate back after updating
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
