import 'package:flutter/material.dart';

class WebLayout extends StatelessWidget {
  const WebLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF6246EA),
        body: Center(
          child: Text(
            'This layout is for Web Application.',
            style: TextStyle(color: Color(0xFFfffffe)),
          ),
        ));
  }
}
