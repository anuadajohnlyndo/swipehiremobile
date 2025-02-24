import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileFormsName extends StatefulWidget {
  const ProfileFormsName({super.key});

  @override
  ProfileFormsNameState createState() => ProfileFormsNameState();
}

class ProfileFormsNameState extends State<ProfileFormsName> {
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
                  GestureDetector(
                    //onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0x686146EA),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  // Email TextField
                  TextFormField(
                    //controller: _firstnameController,
                    initialValue: 'John Lyndo',
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
                    //controller: _lastnameController,
                    initialValue: 'Anuada',
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
