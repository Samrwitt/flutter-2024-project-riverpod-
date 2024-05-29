import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/password.dart';
import '../widgets/email.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamed(context, '/');
        return false; // Prevents the default behavior
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
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
                  children: [const Center(child:Text(
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
                            )),
                          TextSpan(
                              text: 'Register Here',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                decoration: TextDecoration.underline,
                                ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/signup');
                                }
                            )
                          ]
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                    const EmailField(),
                    const SizedBox(height: 20),
                    const PasswordWidget(
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/notes');
                      },
                      child: const Text('Login', style:TextStyle(color: Colors.blueGrey)),
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
