import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/login_page.dart';

class HomeIntern extends StatefulWidget {
  const HomeIntern({super.key});

  @override
  HomeInternState createState() => HomeInternState();
}

class HomeInternState extends State<HomeIntern> {
  Future<void> _signOutUser(context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accountId').then((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Intern Homepage'),
          ElevatedButton(
              onPressed: () {
                _signOutUser(context);
              },
              child: Text('Sign out'))
        ],
      ),
    );
  }
}
