import 'dart:convert';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:swipehire_2/screens/home_intern.dart';

class ProfileFormsExperience extends StatefulWidget {
  const ProfileFormsExperience({super.key});

  @override
  ProfileFormsExperienceState createState() => ProfileFormsExperienceState();
}

class ProfileFormsExperienceState extends State<ProfileFormsExperience> {
  late TextEditingController _experienceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _getUserData();
    _experienceController = TextEditingController();
  }

  @override
  void dispose() {
    _experienceController.dispose();
    super.dispose();
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

  void _getUserData() async {
    Future<String?> getAccountId() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('accountId');
    }

    String? accountId = await getAccountId();

    try {
      final profile = await http.get(
        Uri.parse('http://10.0.2.2:5152/api/Intern/account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (profile.statusCode == 200 || profile.statusCode == 201) {
        var data = jsonDecode(profile.body);
        setState(() {
          email = data['email'];
          phone = data['contactNumber'];
          if (data['specialization'] == 'Tap to edit') {
            _experienceController.text = '';
          } else {
            _experienceController.text = data['specialization'];
          }
        });
      } else {
        setState(() {
          _experienceController.text = '';
        });
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
  }

  String phone = '', email = '';
  void _updateEducation() async {
    Future<String?> getAccountId() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('accountId');
    }

    String? accountId = await getAccountId();

    try {
      final response = await http
          .put(
            Uri.parse('http://10.0.2.2:5152/api/Intern/account/$accountId'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "id": 0,
              "contactNumber": phone,
              "accountId": accountId,
              "email": email,
              "specialization": _experienceController.text,
            }),
          )
          .timeout(Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeIntern()),
          );
        }
      } else {
        _showToast('Something went wrong!');
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: Color(0xFFfffffe),
        height: 500,
        child: Container(
          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: Form(
              //key: _formNameKey, // Assigning the form key.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Edit Experience',
                    style:
                        TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 28),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Password TextField
                  TextFormField(
                    controller: _experienceController,
                    decoration: const InputDecoration(
                      labelText: 'Experience',
                      border: OutlineInputBorder(),
                      alignLabelWithHint:
                          true, // Aligns the label to the top for multiline
                    ),
                    style: TextStyle(
                      fontFamily: 'Fustat Regular',
                      fontSize: 16,
                    ),
                    maxLines: null, // Makes it expand as needed
                    minLines: 3, // Sets a minimum height
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your experience';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24.0),
                  // Login Button

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateEducation();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        textStyle: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Fustat Regular',
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        backgroundColor: Color(0xFF6246EA),
                      ),
                      child: Text(
                          style: TextStyle(
                            color: Color(0xFFfffffe),
                          ),
                          'Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
