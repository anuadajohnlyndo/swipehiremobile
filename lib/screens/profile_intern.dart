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
import 'package:swipehire_2/screens/profile_forms/summary.dart';

class ProfileIntern extends StatefulWidget {
  const ProfileIntern({super.key});

  @override
  ProfileInternState createState() => ProfileInternState();
}

class ProfileInternState extends State<ProfileIntern> {
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

  void _getExperience(accountId) async {
    Future<String?> getAccountId() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('accountId');
    }

    String? accountId = await getAccountId();

    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5152/api/InternWorkExperience'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      // Get accountId before making the request
      String? accountId = await getAccountId();
      print('Account ID: $accountId');

      if (accountId == null) {
        print('No account ID found.');
        return;
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);

        if (data is Map && data['\$values'] is List) {
          List<dynamic> values = data['\$values'];
          List<String> experience = values.map((item) {
            return item['internId'].toString();
          }).toList();

          if (experience.contains(accountId)) {
            print('Account ID found in experience: $accountId');
          } else {
            print('none');
          }
        } else {
          _showToast('Unexpected JSON structure: $data');
        }
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    _getExperience('1');
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
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0x686146EA),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'John Lyndo Anuada',
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
                                '09981720994',
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
                                'anuadajohnlyndo@gmail.com',
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
                    return ProfileFormsField();
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
                                'IT',
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
                    return ProfileFormsField();
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
                                'IT',
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
                                'Cebu Technological University - Argao Campus',
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
                                'I discovered that I cannot work under pressure',
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
                                'Flexible ang ferson',
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
