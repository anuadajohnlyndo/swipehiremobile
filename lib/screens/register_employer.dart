import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:swipehire_2/screens/login_page.dart';
import 'dart:convert';

class EmployerRegisterLayout extends StatefulWidget {
  const EmployerRegisterLayout({super.key});

  @override
  State<EmployerRegisterLayout> createState() => _EmployerRegisterState();
}

class _EmployerRegisterState extends State<EmployerRegisterLayout> {
  final GlobalKey<FormState> _formNameKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formProfileKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formCompanyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formAddressKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formPositionKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formFieldKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formEmailKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formPasswordKey = GlobalKey<FormState>();
  bool showNameForm = true;
  bool showProfileForm = false;
  bool showCompanyForm = false;
  bool showAddressForm = false;
  bool showPositionForm = false;
  bool showFieldForm = false;
  bool showEmailForm = false;
  bool showPasswordForm = false;
  int counter = 0;

  // submit name
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _fieldController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  void _submitName() {
    if (_formNameKey.currentState!.validate()) {
      setState(() {
        showNameForm = false;
        showProfileForm = true;
        counter++;
      });
    }
  }

  void _backProfile() {
    setState(() {
      showNameForm = true;
      showProfileForm = false;
      counter--;
    });
  }

  bool hasProfile = false;
  File? _image;
  final picker = ImagePicker();
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        hasProfile = true;
      });
    }
  }

  void _submitProfile() {
    if (hasProfile) {
      setState(() {
        showProfileForm = false;
        showCompanyForm = true;
        counter++;
      });
    } else {
      _showToast('Please select your profile!');
    }
  }

  void _backCompany() {
    setState(() {
      showProfileForm = true;
      showCompanyForm = false;
      counter--;
    });
  }

  void _submitCompany() {
    if (_formCompanyKey.currentState!.validate()) {
      setState(() {
        showAddressForm = true;
        showCompanyForm = false;
        counter++;
      });
    }
  }

  void _submitAddress() {
    if (_formAddressKey.currentState!.validate()) {
      setState(() {
        showPositionForm = true;
        showAddressForm = false;
        counter++;
      });
    }
  }

  void _backAddress() {
    setState(() {
      showAddressForm = false;
      showCompanyForm = true;
      counter--;
    });
  }

  void _backPosition() {
    setState(() {
      showPositionForm = false;
      showCompanyForm = true;
      counter--;
    });
  }

  void _submitPosition() {
    if (_formPositionKey.currentState!.validate()) {
      setState(() {
        showFieldForm = true;
        showPositionForm = false;
        counter++;
      });
    }
  }

  void _backField() {
    setState(() {
      showFieldForm = false;
      showPositionForm = true;
      counter--;
    });
  }

  void _submitField() {
    if (_formFieldKey.currentState!.validate()) {
      setState(() {
        showEmailForm = true;
        showFieldForm = false;
        counter++;
      });
    }
  }

  void _backEmail() {
    setState(() {
      showEmailForm = false;
      showFieldForm = true;
      counter--;
    });
  }

  void _submitEmail() {
    if (_formEmailKey.currentState!.validate()) {
      setState(() {
        showEmailForm = false;
        showPasswordForm = true;
        counter++;
      });
    }
  }

  void _backPassword() {
    setState(() {
      showEmailForm = true;
      showPasswordForm = false;
      counter--;
    });
  }

  void _register() async {
    if (_formPasswordKey.currentState!.validate()) {
      if (_passwordController.text == _confirmPassController.text) {
        try {
          // Create multipart request
          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://10.0.2.2:5152/api/Account'),
          );

          // Add text fields
          request.fields['Firstname'] = _firstnameController.text;
          request.fields['Lastname'] = _lastnameController.text;
          request.fields['Email'] = _emailController.text;
          request.fields['Password'] = _passwordController.text;
          request.fields['AccountTypeId'] = '9';

          // Add image file
          if (_image != null) {
            request.files.add(
              await http.MultipartFile.fromPath(
                'InternPicture', // This should match your backend parameter name
                _image!.path,
              ),
            );
          }

          // Send request
          var response = await request.send();

          // Handle response
          if (response.statusCode == 200 || response.statusCode == 201) {
            // if (mounted) {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => LoginPage()),
            //   );
            // }
            _createEmployerProfile(
                _firstnameController.text,
                _lastnameController.text,
                _positionController.text,
                _companyController.text,
                _firstnameController.text,
                _addressController.text,
                _phoneController.text,
                accountId);
          } else {
            _showToast('Unsuccessful');
          }
        } catch (e) {
          final result = "Error: $e";
          _showToast(result.toString());
        }
      } else {
        setState(() {
          _showToast('Password doesn\'t match!');
        });
      }
    }
  }

  void _createEmployerProfile(firstname, lastname, position, company, field,
      address, phoneNumber, accountId) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://10.0.2.2:5152/api/Auth/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "firstname": firstname,
              "lastname": lastname,
              "position": position,
              "company": company,
              "field": field,
              "address": address,
              "phoneNumber": phoneNumber,
              "accountId": accountId,
            }),
          )
          .timeout(Duration(seconds: 20));

      // Handle response
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        }
      } else {
        _showToast('Unsuccessful');
      }
    } catch (e) {
      final result = "Error: $e";
      _showToast(result.toString());
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFfffffe),
      body: Center(
        child: Column(
          children: [
            if (showNameForm)
              Animate(
                key: ValueKey(counter),
                effects: [
                  FadeEffect(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                  SlideEffect(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Expanded(
                  child: Container(
                    color: Color(0XFFfffffe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Tell us your ',
                                style: TextStyle(
                                  height: 1,
                                  fontFamily: 'Fustat ExtraBold',
                                  color: Color(0xFF6246EA),
                                  fontSize: 36,
                                ),
                              ),
                              TextSpan(
                                text: 'name',
                                style: TextStyle(
                                  height: 1,
                                  fontFamily: 'Fustat ExtraBold',
                                  color: Color(0xFF272727),
                                  fontSize: 36,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFd9d9d9),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _formNameKey, // Assigning the form key.
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Email TextField
                                  TextFormField(
                                    controller: _firstnameController,
                                    decoration: const InputDecoration(
                                      labelText: 'First Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize: 16),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter first name';
                                      }
                                      // Simple email regex validation.
                                      final nameRegex =
                                          RegExp(r"^[a-zA-Z ._'-]+$");
                                      if (!nameRegex.hasMatch(value)) {
                                        return 'Invalid First Name';
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
                                        fontSize:
                                            16), // Hide the input for password
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter last name';
                                      }
                                      final nameRegex =
                                          RegExp(r"^[a-zA-Z ._'-]+$");
                                      if (!nameRegex.hasMatch(value)) {
                                        return 'Invalid Last Name';
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
                                        _submitName();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 14),
                                        textStyle: TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Fustat Regular',
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                        ),
                                        backgroundColor: Color(0xFF6246EA),
                                      ),
                                      child: Text(
                                          style: TextStyle(
                                            color: Color(0xFFfffffe),
                                          ),
                                          'Continue'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (showProfileForm)
              Animate(
                key: ValueKey(counter),
                effects: [
                  FadeEffect(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                  SlideEffect(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Expanded(
                  child: Container(
                    color: Color(0XFFfffffe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Let\'s set up your ',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF6246EA),
                                    fontSize: 36,
                                  ),
                                ),
                                TextSpan(
                                  text: 'profile',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF272727),
                                    fontSize: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFd9d9d9),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _formProfileKey, // Assigning the form key.
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: _pickImage,
                                    child: CircleAvatar(
                                      radius: 70,
                                      backgroundColor: Color(0x686146EA),
                                      backgroundImage: _image != null
                                          ? FileImage(_image!)
                                          : AssetImage(
                                                  'assets/images/employer_icon.png')
                                              as ImageProvider,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _backProfile();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Fustat Regular',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            backgroundColor: Color(0xFFD1D1E9),
                                          ),
                                          child: Text(
                                              style: TextStyle(
                                                color: Color(0xFFfffffe),
                                              ),
                                              'Back'),
                                        ),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _submitProfile();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Fustat Regular',
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF6246EA),
                                            ),
                                            child: Text(
                                                style: TextStyle(
                                                  color: Color(0xFFfffffe),
                                                ),
                                                'Continue'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (showCompanyForm)
              Animate(
                key: ValueKey(counter),
                effects: [
                  FadeEffect(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                  SlideEffect(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Expanded(
                  child: Container(
                    color: Color(0XFFfffffe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Which company do you work ',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF6246EA),
                                    fontSize: 36,
                                  ),
                                ),
                                TextSpan(
                                  text: 'for?',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF272727),
                                    fontSize: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFd9d9d9),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _formCompanyKey, // Assigning the form key.
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Email TextField
                                  TextFormField(
                                    controller: _companyController,
                                    decoration: const InputDecoration(
                                      labelText: 'Company Name',
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize: 16),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter company name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _backCompany();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Fustat Regular',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            backgroundColor: Color(0xFFD1D1E9),
                                          ),
                                          child: Text(
                                              style: TextStyle(
                                                color: Color(0xFFfffffe),
                                              ),
                                              'Back'),
                                        ),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _submitCompany();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Fustat Regular',
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF6246EA),
                                            ),
                                            child: Text(
                                                style: TextStyle(
                                                  color: Color(0xFFfffffe),
                                                ),
                                                'Continue'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (showAddressForm)
              Animate(
                key: ValueKey(counter),
                effects: [
                  FadeEffect(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                  SlideEffect(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Expanded(
                  child: Container(
                    color: Color(0XFFfffffe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Where is your company ',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF6246EA),
                                    fontSize: 36,
                                  ),
                                ),
                                TextSpan(
                                  text: 'located?',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF272727),
                                    fontSize: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFd9d9d9),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _formAddressKey, // Assigning the form key.
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Email TextField
                                  TextFormField(
                                    controller: _addressController,
                                    decoration: const InputDecoration(
                                      labelText: 'Company Address',
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize: 16),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter company address';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _backAddress();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Fustat Regular',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            backgroundColor: Color(0xFFD1D1E9),
                                          ),
                                          child: Text(
                                              style: TextStyle(
                                                color: Color(0xFFfffffe),
                                              ),
                                              'Back'),
                                        ),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _submitAddress();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Fustat Regular',
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF6246EA),
                                            ),
                                            child: Text(
                                                style: TextStyle(
                                                  color: Color(0xFFfffffe),
                                                ),
                                                'Continue'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (showPositionForm)
              Animate(
                key: ValueKey(counter),
                effects: [
                  FadeEffect(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                  SlideEffect(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Expanded(
                  child: Container(
                    color: Color(0XFFfffffe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'What is your job ',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF6246EA),
                                    fontSize: 36,
                                  ),
                                ),
                                TextSpan(
                                  text: 'like?',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF272727),
                                    fontSize: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFd9d9d9),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _formPositionKey, // Assigning the form key.
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Email TextField
                                  TextFormField(
                                    controller: _positionController,
                                    decoration: const InputDecoration(
                                      labelText: 'Position',
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize: 16),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your position';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _backPosition();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Fustat Regular',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            backgroundColor: Color(0xFFD1D1E9),
                                          ),
                                          child: Text(
                                              style: TextStyle(
                                                color: Color(0xFFfffffe),
                                              ),
                                              'Back'),
                                        ),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _submitPosition();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Fustat Regular',
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF6246EA),
                                            ),
                                            child: Text(
                                                style: TextStyle(
                                                  color: Color(0xFFfffffe),
                                                ),
                                                'Continue'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (showFieldForm)
              Animate(
                key: ValueKey(counter),
                effects: [
                  FadeEffect(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                  SlideEffect(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Expanded(
                  child: Container(
                    color: Color(0XFFfffffe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'What do you look for ',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF6246EA),
                                    fontSize: 36,
                                  ),
                                ),
                                TextSpan(
                                  text: 'interns?',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF272727),
                                    fontSize: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFd9d9d9),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _formFieldKey, // Assigning the form key.
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Email TextField
                                  TextFormField(
                                    controller: _fieldController,
                                    decoration: const InputDecoration(
                                      labelText: 'Field',
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize: 16),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter field';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _backField();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Fustat Regular',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            backgroundColor: Color(0xFFD1D1E9),
                                          ),
                                          child: Text(
                                              style: TextStyle(
                                                color: Color(0xFFfffffe),
                                              ),
                                              'Back'),
                                        ),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _submitField();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Fustat Regular',
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF6246EA),
                                            ),
                                            child: Text(
                                                style: TextStyle(
                                                  color: Color(0xFFfffffe),
                                                ),
                                                'Continue'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (showEmailForm)
              Animate(
                key: ValueKey(counter),
                effects: [
                  FadeEffect(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                  SlideEffect(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Expanded(
                  child: Container(
                    color: Color(0XFFfffffe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Keep in ',
                                style: TextStyle(
                                  height: 1,
                                  fontFamily: 'Fustat ExtraBold',
                                  color: Color(0xFF6246EA),
                                  fontSize: 36,
                                ),
                              ),
                              TextSpan(
                                text: 'touch',
                                style: TextStyle(
                                  height: 1,
                                  fontFamily: 'Fustat ExtraBold',
                                  color: Color(0xFF272727),
                                  fontSize: 36,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFd9d9d9),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _formEmailKey, // Assigning the form key.
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Email TextField
                                  TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize: 16),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      // Simple email regex validation.
                                      final emailRegex = RegExp(
                                          r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                                      if (!emailRegex.hasMatch(value)) {
                                        return 'Enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),

                                  // Phone TextField
                                  TextFormField(
                                    controller: _phoneController,
                                    decoration: const InputDecoration(
                                      labelText: 'Phone',
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize: 16),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone';
                                      }
                                      // Simple email regex validation.
                                      final numberRegex = RegExp(r"^[0-9]+$");

                                      if (!numberRegex.hasMatch(value)) {
                                        return 'Enter a valid phone';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),

                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _backEmail();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Fustat Regular',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            backgroundColor: Color(0xFFD1D1E9),
                                          ),
                                          child: Text(
                                              style: TextStyle(
                                                color: Color(0xFFfffffe),
                                              ),
                                              'Back'),
                                        ),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _submitEmail();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Fustat Regular',
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF6246EA),
                                            ),
                                            child: Text(
                                                style: TextStyle(
                                                  color: Color(0xFFfffffe),
                                                ),
                                                'Continue'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            if (showPasswordForm)
              Animate(
                key: ValueKey(counter),
                effects: [
                  FadeEffect(
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                  SlideEffect(
                    begin: Offset(0, 1),
                    end: Offset(0, 0),
                    duration: 300.ms,
                    curve: Curves.easeInOut,
                  ),
                ],
                child: Expanded(
                  child: Container(
                    color: Color(0XFFfffffe),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 30.0),
                          child: Text.rich(
                            textAlign: TextAlign.center,
                            TextSpan(
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Finally, let\'s keep your account ',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF6246EA),
                                    fontSize: 36,
                                  ),
                                ),
                                TextSpan(
                                  text: 'secured',
                                  style: TextStyle(
                                    height: 1,
                                    fontFamily: 'Fustat ExtraBold',
                                    color: Color(0xFF272727),
                                    fontSize: 36,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 40, right: 40, top: 15),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color(0xFFd9d9d9),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Form(
                              key: _formPasswordKey, // Assigning the form key.
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Email TextField
                                  TextFormField(
                                    controller: _passwordController,
                                    decoration: const InputDecoration(
                                      labelText: 'Password',
                                      border: OutlineInputBorder(),
                                    ),
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize: 16),
                                    keyboardType: TextInputType.emailAddress,
                                    obscureText: true,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16.0),
                                  // Password TextField
                                  TextFormField(
                                    controller: _confirmPassController,
                                    decoration: const InputDecoration(
                                      labelText: 'Confirm Password',
                                      border: OutlineInputBorder(),
                                    ),
                                    obscureText: true,
                                    style: TextStyle(
                                        fontFamily: 'Fustat Regular',
                                        fontSize:
                                            16), // Hide the input for password
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please confirm password';
                                      }
                                      if (value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 24.0),
                                  // Login Button
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            _backPassword();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 14),
                                            textStyle: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'Fustat Regular',
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            backgroundColor: Color(0xFFD1D1E9),
                                          ),
                                          child: Text(
                                              style: TextStyle(
                                                color: Color(0xFFfffffe),
                                              ),
                                              'Back'),
                                        ),
                                        SizedBox(
                                          width: 14,
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              _register();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 14),
                                              textStyle: TextStyle(
                                                fontSize: 16,
                                                fontFamily: 'Fustat Regular',
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              backgroundColor:
                                                  Color(0xFF6246EA),
                                            ),
                                            child: Text(
                                                style: TextStyle(
                                                  color: Color(0xFFfffffe),
                                                ),
                                                'Register'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            Expanded(
                //Bottom part
                child: Container(
              color: Color(0XFFfffffe),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Animate(
                      effects: [
                        FadeEffect(
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        ),
                        SlideEffect(
                          begin: Offset(1, 1),
                          end: Offset(0, 0),
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        ),
                        ScaleEffect(
                          begin: Offset(0.9, 0.9),
                          end: Offset(1.05, 1.05),
                          duration: 300.ms,
                          curve: Curves.easeInOut,
                        ),
                      ],
                      child: Image.asset(
                        'assets/images/signin_material.png',
                        width: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
