import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/home_intern.dart';

class ProfileFormsContact extends StatefulWidget {
  const ProfileFormsContact({super.key});

  @override
  ProfileFormsContactState createState() => ProfileFormsContactState();
}

class ProfileFormsContactState extends State<ProfileFormsContact> {
  late TextEditingController _emailController = TextEditingController();
  late TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
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
      final contactResponse = await http.get(
        Uri.parse('http://10.0.2.2:5152/api/Intern/Account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (contactResponse.statusCode == 200 ||
          contactResponse.statusCode == 201) {
        var data = jsonDecode(contactResponse.body);
        setState(() {
          _emailController.text = data['email'];
          if (data['contactNumber'] == 'Tap to edit') {
            _phoneController.text = '';
          } else {
            _phoneController.text = data['contactNumber'];
          }
        });
      } else {
        _showToast('An unexpected error occured!');
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
  }

  void _updateContact() async {
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
              "contactNumber": _phoneController.text,
              "accountId": accountId,
              "email": _emailController.text,
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
                    'Edit Contact',
                    style:
                        TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 28),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Email TextField
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    style:
                        TextStyle(fontFamily: 'Fustat Regular', fontSize: 16),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Password TextField
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),

                    style: TextStyle(
                        fontFamily: 'Fustat Regular',
                        fontSize: 16), // Hide the input for password
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
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
                        _updateContact();
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
