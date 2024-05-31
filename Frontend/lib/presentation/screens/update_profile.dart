import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../application/providers/user_provider.dart';

class UpdateProfilePage extends ConsumerStatefulWidget {
  const UpdateProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends ConsumerState<UpdateProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider);
    nameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    passwordController = TextEditingController(text: user.password);
  }

  @override
  void dispose() {
    nameController.dispose();
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
              controller: nameController,
              decoration: const InputDecoration(labelText: 'name'),
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
                ref
                    .read(userProvider.notifier)
                    .updatename(nameController.text);
                ref
                    .read(userProvider.notifier)
                    .updateEmail(emailController.text);
                ref
                    .read(userProvider.notifier)
                    .updatePassword(passwordController.text);
                context
                    .pop(); // Use GoRouter's context extension to navigate back
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
