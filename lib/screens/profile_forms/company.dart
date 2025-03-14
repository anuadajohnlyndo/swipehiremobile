import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileFormsCompany extends StatefulWidget {
  const ProfileFormsCompany({super.key});

  @override
  ProfileFormsCompanyState createState() => ProfileFormsCompanyState();
}

class ProfileFormsCompanyState extends State<ProfileFormsCompany> {
  late TextEditingController _companyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
    _companyController = TextEditingController();
  }

  @override
  void dispose() {
    _companyController.dispose();
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
        Uri.parse('http://10.0.2.2:5152/api/Recruit/account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (contactResponse.statusCode == 200 ||
          contactResponse.statusCode == 201) {
        var data = jsonDecode(contactResponse.body);
        setState(() {
          _companyController.text = data['company'];
        });
      } else {
        _showToast('An unexpected error occured!');
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
                    'Edit Company',
                    style:
                        TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 28),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Password TextField
                  TextFormField(
                    controller: _companyController,
                    decoration: const InputDecoration(
                      labelText: 'Company',
                      border: OutlineInputBorder(),
                    ),

                    style: TextStyle(
                        fontFamily: 'Fustat Regular',
                        fontSize: 16), // Hide the input for password
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter company';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  // Login Button

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
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
