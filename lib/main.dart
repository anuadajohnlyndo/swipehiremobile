import 'package:flutter/material.dart';
import 'package:swipehire_2/landing_page/mobile_page.dart';
import 'package:swipehire_2/landing_page/web_page.dart';
import 'package:swipehire_2/responsive/responsive_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: ResponsiveLayout(
          mobileLayout: MobileLayout(),
          webLayout: WebLayout(),
        ),
      ),
    );
  }
}
