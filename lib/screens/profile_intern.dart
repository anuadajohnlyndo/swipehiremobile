import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:swipehire_2/screens/profile_forms/contact.dart';
import 'package:swipehire_2/screens/profile_forms/education.dart';
import 'package:swipehire_2/screens/profile_forms/experience.dart';
import 'package:swipehire_2/screens/profile_forms/field.dart';
import 'package:swipehire_2/screens/profile_forms/name.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/profile_forms/skills.dart';
import 'package:swipehire_2/screens/profile_forms/summary.dart';

class ProfileIntern extends StatefulWidget {
  const ProfileIntern({super.key});

  @override
  ProfileInternState createState() => ProfileInternState();
}

class ProfileInternState extends State<ProfileIntern> {
  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _showToast(message) {
    DelightToastBar(
      builder: (context) {
        return ToastCard(
            leading: Icon(
              Icons.warning_rounded,
              size: 32,
              color: Color(0xFF6246EA),
            ),
            color: Color(0XFFfffffe),
            title: Text(
              message,
              style: TextStyle(
                fontFamily: 'Fustat Regular',
                color: Color(0xFF272727),
                fontSize: 16,
              ),
            ));
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
    ).show(context);
  }

  String imageProfile = 'https://www.pngall.com/profile-png/',
      fullname = '',
      email = '',
      contactNumber = '',
      fieldName = '',
      skills = '',
      education = '',
      experience = '',
      summary = '';
  void _getUserData() async {
    Future<String?> getAccountId() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('accountId');
    }

    String? accountId = await getAccountId();

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5152/api/Account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        setState(() {
          String firstname = data['firstname'];
          String lastname = data['lastname'];
          imageProfile = data['internPictureUrl'];
          fullname = '$firstname $lastname';
          email = data['email'].toString();
        });
      } else {
        _showToast('An unexpected error occured!');
      }

      final profile = await http.get(
        Uri.parse('http://10.0.2.2:5152/api/Intern/account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (profile.statusCode == 200 || profile.statusCode == 201) {
        var data = jsonDecode(profile.body);
        setState(() {
          contactNumber = data['contactNumber'] ?? 'Tap to edit';
          fieldName = data['specialization'] ?? 'Tap to edit';
          skills = data['skills'] ?? 'Tap to edit';
          education = data['school'] ?? 'Tap to edit';
          experience = data['company'] ?? 'Tap to edit';
          summary = data['description'] ?? 'Tap to edit';
        });
      } else {
        setState(() {
          contactNumber = 'Tap to edit';
          fieldName = 'Tap to edit';
          skills = 'Tap to edit';
          education = 'Tap to edit';
          experience = 'Tap to edit';
          summary = 'Tap to edit';
        });
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfffffe),
      body: ListView(
        children: [
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Profile',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsName();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipOval(
                          child: Image.network(
                            imageProfile,
                            fit: BoxFit.cover,
                            width: 120.0,
                            height: 120.0,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          fullname,
                          style: TextStyle(
                              fontFamily: 'Fustat Regular', fontSize: 26),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //CONTACT
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Contact',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsContact();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(IconlyBold.call),
                            SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                contactNumber,
                                style: TextStyle(
                                    fontFamily: 'Fustat Regular', fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(IconlyBold.message),
                            SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                email,
                                style: TextStyle(
                                    fontFamily: 'Fustat Regular', fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //FIELD
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Field',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsFields();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(IconlyBold.work),
                            SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                fieldName,
                                style: TextStyle(
                                    fontFamily: 'Fustat Regular', fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //SKILLS
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Skills',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsSkills();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(IconlyBold.star),
                            SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                skills,
                                style: TextStyle(
                                    fontFamily: 'Fustat Regular', fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //EDUCATION
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Education',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsEducation();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(IconlyBold.edit),
                            SizedBox(width: 15),
                            Expanded(
                              // Wrap Text with Expanded to allow wrapping
                              child: Text(
                                education,
                                softWrap:
                                    true, // Text will wrap to the next line
                                style: TextStyle(
                                  fontFamily: 'Fustat Regular',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Experience
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Experience',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsExperience();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(IconlyBold.chart),
                            SizedBox(width: 15),
                            Expanded(
                              // Wrap Text with Expanded to allow wrapping
                              child: Text(
                                experience,
                                softWrap:
                                    true, // Text will wrap to the next line
                                style: TextStyle(
                                  fontFamily: 'Fustat Regular',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          //Summary
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Summary',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsSummary();
                  });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 0, bottom: 10, left: 20, right: 20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  color: Color(0xFFFAFAFA),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(IconlyBold.profile),
                            SizedBox(width: 15),
                            Expanded(
                              // Wrap Text with Expanded to allow wrapping
                              child: Text(
                                summary,
                                softWrap:
                                    true, // Text will wrap to the next line
                                style: TextStyle(
                                  fontFamily: 'Fustat Regular',
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
