import 'package:flutter/material.dart';
import 'package:swipehire_2/responsive/redirect_user.dart';
import 'package:swipehire_2/screens/home_employer.dart';
import 'package:swipehire_2/screens/home_intern.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: RedirectUser(
          internLayout: HomeIntern(),
          employerLayout: HomeEmployer(),
        ),
      ),
    );
  }
}
