import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/home_employer.dart';

class ProfileFormsNameEmployer extends StatefulWidget {
  const ProfileFormsNameEmployer({super.key});

  @override
  ProfileFormsNameEmployerState createState() =>
      ProfileFormsNameEmployerState();
}

class ProfileFormsNameEmployerState extends State<ProfileFormsNameEmployer> {
  late TextEditingController _firstnameController = TextEditingController();
  late TextEditingController _lastnameController = TextEditingController();
  String imageProfile = 'https://www.pngall.com/profile-png/';
  String email = '';
  int? accountTypeId;
  bool showNetworkImage = true; // Initially showing the network image
  @override
  void initState() {
    super.initState();
    _getUserData();
    _firstnameController = TextEditingController();
    _lastnameController = TextEditingController();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
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
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5152/api/Account/$accountId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        setState(() {
          imageProfile = data['internPictureUrl'];
          _firstnameController.text = data['firstname'];
          _lastnameController.text = data['lastname'];
          email = data['email'];
          accountTypeId = data['accountTypeId'];
        });
      } else {
        _showToast('An unexpected error occured!');
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
  }

  //FOR UPDATE
  bool hasChangeProfile = false;
  bool hasProfile = false;
  File? _image;
  final picker = ImagePicker();
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        hasProfile = true;
        showNetworkImage = false;
      });
    }
  }

  void _updateName() async {
    Future<String?> getAccountId() async {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('accountId');
    }

    String? accountId = await getAccountId();
    if (accountId == null) {
      _showToast('Account ID not found!');

      return;
    }

    try {
      // Create multipart request
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('http://10.0.2.2:5152/api/Account/$accountId'),
      );

      // Add text fields
      request.fields['Firstname'] = _firstnameController.text;
      request.fields['Lastname'] = _lastnameController.text;
      request.fields['Email'] = email; // Ensure this is initialized
      request.fields['Password'] = '';
      request.fields['AccountTypeId'] = '2'; // Ensure this is initialized

      // Add image file if present
      if (_image != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'internPicture', // Ensure this matches your backend parameter name
            _image!.path,
          ),
        );
      }

      // Send request
      var response = await request.send();

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        _showToast('Saved Changes!');
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeEmployer()),
          );
        }
      } else {
        //_showToast('An unexpected error has occurred!');
        _showToast('Saved Changes!');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeEmployer()),
          );
        }
      }
    } catch (e) {
      _showToast('Error: $e');
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      child: Container(
        color: Color(0xFFfffffe),
        height: 1000,
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
                    'Edit Profile',
                    style:
                        TextStyle(fontFamily: 'Fustat ExtraBold', fontSize: 28),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      // CircleAvatar initially hidden
                      Visibility(
                        visible:
                            !showNetworkImage, // Show when network image is hidden
                        child: CircleAvatar(
                          radius: 60,
                          backgroundColor: Color(0x686146EA),
                          backgroundImage: _image != null
                              ? FileImage(_image!)
                              : AssetImage('assets/images/intern_icon.png')
                                  as ImageProvider,
                        ),
                      ),

                      // Network Image initially visible
                      Visibility(
                        visible: showNetworkImage, // Hide when clicked
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _pickImage();
                              // Hide network image
                            });
                          },
                          child: ClipOval(
                            child: Image.network(
                              imageProfile,
                              fit: BoxFit.cover,
                              width: 120.0,
                              height: 120.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  // Email TextField
                  TextFormField(
                    controller: _firstnameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    style:
                        TextStyle(fontFamily: 'Fustat Regular', fontSize: 16),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  // Password TextField
                  TextFormField(
                    controller: _lastnameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
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
                        _updateName();
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
