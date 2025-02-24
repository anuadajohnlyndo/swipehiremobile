import 'package:flutter/material.dart';
import 'package:swipehire_2/screens/login_page.dart';
import 'package:swipehire_2/screens/register_employer.dart';
import 'package:swipehire_2/screens/register_intern.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RoleRegister extends StatefulWidget {
  const RoleRegister({super.key});

  @override
  RegisterRole createState() => RegisterRole();
}

class RegisterRole extends State<RoleRegister> {
  String selectedRole = 'Employer';

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _registerIntern() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InternRegisterLayout()),
    );
  }

  void _registerEmployer() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EmployerRegisterLayout()),
    );
  }

  int counter = 0;
  String currentImg = 'assets/images/employer_img.png';

  void _animateImg() {
    setState(() {
      if (selectedRole == 'Employer') {
        currentImg = 'assets/images/employer_img.png';
      }
      if (selectedRole == 'Intern') {
        currentImg = 'assets/images/intern_img.png';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    counter++;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFfffffe),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Register ',
                          style: TextStyle(
                            fontFamily: 'Fustat ExtraBold',
                            color: Color(0xFF6246EA),
                            fontSize: 36,
                          ),
                        ),
                        TextSpan(
                          text: 'as',
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRole = 'Employer';
                                  counter++;
                                  _animateImg();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color(0xFFF7F7FF),
                                  border: Border.all(
                                    color: selectedRole == 'Employer'
                                        ? Color(0xFF6246EA)
                                        : Color(0xFFd9d9d9),
                                    width: 1,
                                  ),
                                ),
                                height: 50,
                                padding: EdgeInsets.only(left: 10, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'assets/images/employer_icon.png',
                                    ),
                                    Text(
                                      'Employer',
                                      style: TextStyle(
                                        fontFamily: 'Fustat ExtraBold',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 14),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedRole = 'Intern';
                                  counter++;
                                  _animateImg();
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color(0xFFF7F7FF),
                                  border: Border.all(
                                    color: selectedRole == 'Intern'
                                        ? Color(0xFF6246EA)
                                        : Color(0xFFd9d9d9),
                                    width: 1,
                                  ),
                                ),
                                height: 50,
                                padding: EdgeInsets.only(left: 10, right: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.asset(
                                      'assets/images/intern_icon.png',
                                    ),
                                    Text(
                                      'Intern',
                                      style: TextStyle(
                                        fontFamily: 'Fustat ExtraBold',
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedRole == 'Employer') {
                                  _registerEmployer();
                                }
                                if (selectedRole == 'Intern') {
                                  _registerIntern();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                textStyle: TextStyle(fontSize: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                backgroundColor: Color(0xFF6246EA),
                              ),
                              child: Text(
                                'Continue',
                                style: TextStyle(color: Color(0xFFfffffe)),
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
                      _login();
                    },
                    child: Text(
                        style: TextStyle(
                            fontFamily: 'Fustat Regular',
                            fontSize: 16,
                            color: Color(0xFF6246EA)),
                        'Already have an account?'),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child: Animate(
                      key: ValueKey(counter),
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
                        currentImg,
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
