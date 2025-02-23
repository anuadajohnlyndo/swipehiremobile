import 'package:flutter/material.dart';

class HomeEmployer extends StatefulWidget {
  const HomeEmployer({super.key});

  @override
  HomeEmployerState createState() => HomeEmployerState();
}

class HomeEmployerState extends State<HomeEmployer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Employer Homepage.'),
      ),
    );
  }
}
