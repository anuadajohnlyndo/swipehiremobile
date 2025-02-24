import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/login_page.dart';

class HomeEmployer extends StatefulWidget {
  const HomeEmployer({super.key});

  @override
  HomeEmployerState createState() => HomeEmployerState();
}

class HomeEmployerState extends State<HomeEmployer> {
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
          Text('Employer Homepage'),
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
