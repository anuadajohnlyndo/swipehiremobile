import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/home_page.dart';
import 'package:swipehire_2/screens/intro_page.dart';

class MobileLayout extends StatefulWidget {
  const MobileLayout({super.key});

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  Future<String?> getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accountId');
  }

  void _checkAccountId() async {
    String? accountId = await getAccountId();

    if (!mounted) return;
    if (accountId != null) {
      _redirectToHomePage(context);
    } else {
      _redirectToLoginPage(context);
    }
  }

  void _redirectToHomePage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  void _redirectToLoginPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const IntroPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAccountId();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFfffffe),
      body: Container(),
    );
  }
}
