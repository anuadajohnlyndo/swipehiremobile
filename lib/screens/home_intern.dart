import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/login_page.dart';
import 'package:swipehire_2/screens/profile_intern.dart';

class HomeIntern extends StatefulWidget {
  const HomeIntern({super.key});

  @override
  HomeInternState createState() => HomeInternState();
}

class HomeInternState extends State<HomeIntern> {
  Future<void> _signOutUser(context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('accountId').then((_) {
      CircularProgressIndicator();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  List<Widget> widgetList = [
    Container(
      color: Colors.amber,
    ),
    ProfileIntern(),
    Container(
      color: Colors.amber,
    ),
  ];

  int myIndex = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList[myIndex],
      ),
      backgroundColor: Color(0xFFfffffe),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Color(0xFFfffffe),
          currentIndex: myIndex,
          onTap: (index) {
            if (index == 2) {
              if (mounted) {
                _signOutUser(context);
              }
            } else {
              setState(() {
                myIndex = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
            BottomNavigationBarItem(
                icon: Icon(Icons.logout), label: 'Sign out'),
          ]),
    );
  }
}
