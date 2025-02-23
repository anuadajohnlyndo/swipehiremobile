import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehire_2/screens/home_page.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:swipehire_2/screens/register_role.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _setUsername(id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountId', id.toString());
  }

  Future<void> _loginUser(email, password, context) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://10.0.2.2:5152/api/Auth/login'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              "email": email,
              "password": password,
            }),
          )
          .timeout(Duration(seconds: 20));

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = jsonDecode(response.body);
        final result = data['accountId'];
        _setUsername(result).then((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        });
      } else {
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
                  'Error Logging in! Please try again.',
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
    } catch (e) {
      final result = "Error: $e";
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
                result.toString(),
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
  }

  // submit
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  void _submit() {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;
      _loginUser(email, password, context);
    }
  }

  void _register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RoleRegister()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFfffffe),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Container(
                color: Color(0XFFfffffe),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Sign ',
                            style: TextStyle(
                              fontFamily: 'Fustat ExtraBold',
                              color: Color(0xFF6246EA),
                              fontSize: 36,
                            ),
                          ),
                          TextSpan(
                            text: 'In',
                            style: TextStyle(
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
                          key: _formKey, // Assigning the form key.
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
                                    fontFamily: 'Fustat Regular', fontSize: 16),
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
                              // Password TextField
                              TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,

                                style: TextStyle(
                                    fontFamily: 'Fustat Regular',
                                    fontSize:
                                        16), // Hide the input for password
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
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
                                child: ElevatedButton(
                                  onPressed: () {
                                    _submit();
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
                                      'Log in'),
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
            Expanded(
                child: Container(
              color: Color(0XFFfffffe),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    style: ButtonStyle(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    onPressed: () {
                      _register();
                    },
                    child: Text(
                        style: TextStyle(
                            fontFamily: 'Fustat Regular',
                            fontSize: 16,
                            color: Color(0xFF6246EA)),
                        'Don\'t have an account?'),
                  ),
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
