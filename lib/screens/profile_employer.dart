import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:swipehire_2/screens/profile_forms/address.dart';
import 'package:swipehire_2/screens/profile_forms/company.dart';
import 'package:swipehire_2/screens/profile_forms/contact_employer.dart';
import 'package:swipehire_2/screens/profile_forms/field_employer.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/profile_forms/name_employer.dart';
import 'package:swipehire_2/screens/profile_forms/position.dart';

class ProfileEmployer extends StatefulWidget {
  const ProfileEmployer({super.key});

  @override
  ProfileEmployerState createState() => ProfileEmployerState();
}

class ProfileEmployerState extends State<ProfileEmployer> {
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
      company = '',
      address = '',
      position = '';
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
        Uri.parse('http://10.0.2.2:5152/api/Recruit/account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (profile.statusCode == 200 || profile.statusCode == 201) {
        var data = jsonDecode(profile.body);
        setState(() {
          contactNumber = data['phoneNumber'] ?? 'Tap to edit';
          _getFieldName(data['field']);
          company = data['company'] ?? 'Tap to edit';
          address = data['address'] ?? 'Tap to edit';
          position = data['position'] ?? 'Tap to edit';
        });
      } else {
        setState(() {
          contactNumber = 'Tap to edit';
          fieldName = 'Tap to edit';
          company = 'Tap to edit';
          address = 'Tap to edit';
          position = 'Tap to edit';
        });
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
  }

  void _getFieldName(id) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5152/api/Field/$id'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        setState(() {
          fieldName = data['name'] ?? "Error...";
        });
      } else {
        fieldName = "Error...";
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
                    return ProfileFormsNameEmployer();
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
                    return ProfileFormsContactEmployer();
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

          //Explore
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
                    return ProfileFormsFieldsEmployer();
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
                            Icon(Icons.explore),
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

          //COMPANY
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Company',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsCompany();
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
                            Icon(Icons.business),
                            SizedBox(
                              width: 15,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 15),
                              child: Text(
                                company,
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

          //ADDRESS
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Address',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsAddress();
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
                            Icon(IconlyBold.location),
                            SizedBox(width: 15),
                            Expanded(
                              // Wrap Text with Expanded to allow wrapping
                              child: Text(
                                address,
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

          //POSITION
          Padding(
            padding:
                const EdgeInsets.only(top: 10, bottom: 0, left: 20, right: 20),
            child: Text(
              'Position',
              style: TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 32),
            ),
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return ProfileFormsPosition();
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
                            Icon(IconlyBold.work),
                            SizedBox(width: 15),
                            Expanded(
                              // Wrap Text with Expanded to allow wrapping
                              child: Text(
                                position,
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
