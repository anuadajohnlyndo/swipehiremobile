import 'package:flutter/material.dart';
import 'package:swipehire_2/screens/login_page.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  void _redirectToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/model_swipehire.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Welcome to SwipeHire',
                style: TextStyle(
                  fontFamily: 'Fustat ExtraBold',
                  color: Color(0xFFfffffe),
                  fontSize: 36,
                  height: 1,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
              child: Text(
                'With SwipeHire, explore opportunities, connect with companies, and jumpstart your career—all in one place.',
                style: TextStyle(
                  fontFamily: 'Fustat Regular',
                  color: Color(0xFFfffffe),
                  fontSize: 16,
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: () {
                      _redirectToLoginPage(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      textStyle: TextStyle(fontSize: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      backgroundColor: Color(0xFFfffffe),
                    ),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          color: Color(0xFF272727),
                          fontFamily: 'Fustat Regular'),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
