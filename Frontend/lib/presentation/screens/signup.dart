import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../widgets/password.dart';
import '../widgets/email.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final GlobalKey<EmailFieldState> _emailFieldKey = GlobalKey<EmailFieldState>();

  @override
  Widget build(BuildContext context) {
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
              children: [const Center(child:Text(
                      'Welcome, New User',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                ),
                const SizedBox(height: 20,),
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
                            )),
                          TextSpan(
                              text: 'Sign in Here',
                              style: const TextStyle(
                                color: Colors.blueGrey,
                                decoration: TextDecoration.underline,
                                ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(context, '/login');
                                }
                            )
                          ]
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 20),
                EmailField(key: _emailFieldKey),
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
                    color:Colors.black),
                ),
                const SizedBox(height: 10),
                const PasswordWidget(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    final isValidEmail = _emailFieldKey.currentState?.isSignUpEnabled() ?? false;
                    if (isValidEmail) {
                      Navigator.pushNamed(context, '/notes');
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Invalid Email',
                            style: TextStyle(
                              color: Colors.white
                              ),
                            ),
                            content: const Text('Please enter a valid email address.'),
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
                  child: const Text('Sign Up', style:TextStyle(color: Colors.blueGrey)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
