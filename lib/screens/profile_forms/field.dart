import 'package:flutter/material.dart';

class ProfileFormsField extends StatefulWidget {
  const ProfileFormsField({super.key});

  @override
  ProfileFormsFieldState createState() => ProfileFormsFieldState();
}

class ProfileFormsFieldState extends State<ProfileFormsField> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: Color(0xFFfffffe),
        height: 500,
        child: Center(child: Text('Field')),
      ),
    );
  }
}
