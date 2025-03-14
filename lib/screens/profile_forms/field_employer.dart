import 'dart:convert';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:swipehire_2/screens/home_employer.dart';

class ProfileFormsFieldsEmployer extends StatefulWidget {
  const ProfileFormsFieldsEmployer({super.key});

  @override
  ProfileFormsFieldsEmployerState createState() =>
      ProfileFormsFieldsEmployerState();
}

class ProfileFormsFieldsEmployerState
    extends State<ProfileFormsFieldsEmployer> {
  late TextEditingController _fieldsController = TextEditingController();
  String dropdownValue = '1';
  @override
  void initState() {
    super.initState();
    _getUserData();
    _fieldsController = TextEditingController();
  }

  @override
  void dispose() {
    _fieldsController.dispose();
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
        Uri.parse('http://10.0.2.2:5152/api/Recruit/account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (profile.statusCode == 200 || profile.statusCode == 201) {
        var data = jsonDecode(profile.body);
        setState(() {
          dropdownValue = data['field'];
          _getFieldName(dropdownValue);
        });
      } else {
        setState(() {
          _fieldsController.text = '';
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
          _fieldsController.text = data['name'] ?? "Error...";
        });
      } else {
        _fieldsController.text = "Error...";
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
  }

  void _updateField() async {
    Future<String?> getAccountId() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('accountId');
    }

    String? accountId = await getAccountId();

    try {
      final response = await http
          .put(
            Uri.parse('http://10.0.2.2:5152/api/Recruit/ByAccount/$accountId'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "field": dropdownValue,
              "accountId": accountId,
            }),
          )
          .timeout(Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeEmployer()),
          );
        }
      } else {
        _showToast('Save Changes!');
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeEmployer()),
          );
        }
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
                    'Edit Field',
                    style:
                        TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 28),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Password TextField
                  DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 16,
                    style: const TextStyle(
                      color: Colors.deepPurple,
                      fontFamily: 'Fustat ExtraBold',
                      fontSize: 18,
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    // Step 2: Provide the list of items
                    items: const [
                      DropdownMenuItem(
                        value: '1',
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Tehnology'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '2',
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Healthcare'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '3',
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Finance'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '4',
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Education'),
                        ),
                      ),
                      DropdownMenuItem(
                        value: '5',
                        child: Align(
                          alignment: Alignment.center,
                          child: Text('Marketing'),
                        ),
                      ),
                    ],
                    // Step 3: Handle the selection
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),

                  const SizedBox(height: 24.0),
                  // Login Button

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        _updateField();
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
