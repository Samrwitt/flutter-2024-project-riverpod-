import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(
          child: Text(
            'Echo',
            style: GoogleFonts.dancingScript(
              textStyle: TextStyle(
                color: Colors.red[500],
                fontSize: 50,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 400,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/quill.png'),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
          ),
          // Slogan
          Positioned(
            top: 400,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Put your notes \n                  here',
                style: GoogleFonts.dancingScript(
                  textStyle: TextStyle(
                    color: Colors.red[500],
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          // Register Here Button
          Positioned(
            top: 500,
            left: 50,
            right: 50,
            child: ElevatedButton(
              onPressed: () => context.push('/signup'), // Using GoRouter for navigation
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(180),
                    side: const BorderSide(color: Colors.blueGrey, width: 2),
                  ),
                ),
              ),
              child: const Text(
                'Register Here',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          // Click Here for Admin Button
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Click Here',
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => context.push('/adminLogin'), // Using GoRouter
                      ),
                      const TextSpan(
                        text: " for Admin",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
