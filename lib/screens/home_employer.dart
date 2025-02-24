import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/explore_page.dart';
import 'package:swipehire_2/screens/login_page.dart';
import 'package:swipehire_2/screens/profile_employer.dart';

class HomeEmployer extends StatefulWidget {
  const HomeEmployer({super.key});

  @override
  HomeEmployerState createState() => HomeEmployerState();
}

class HomeEmployerState extends State<HomeEmployer> {
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
    ExplorePage(),
    Container(
      color: Colors.orange,
    ),
    ProfileEmployer(),
    Container(
      color: Colors.yellow,
    ),
  ];

  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widgetList[myIndex],
      ),
      backgroundColor: Color(0xFFfffffe),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFFfffffe),
        currentIndex: myIndex,
        selectedItemColor: Color(0xFF6246EA), // Color when selected
        unselectedItemColor: Colors.grey, // Color when not selected
        onTap: (index) {
          if (index == 3) {
            // Changed from 4 to 3
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
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Sign out'),
        ],
      ),
    );
  }
}
