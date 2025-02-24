import 'package:flutter/material.dart';

class ProfileFormsExperience extends StatefulWidget {
  const ProfileFormsExperience({super.key});

  @override
  ProfileFormsExperienceState createState() => ProfileFormsExperienceState();
}

class ProfileFormsExperienceState extends State<ProfileFormsExperience> {
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
                    initialValue:
                        'I discovered that I cannot work under pressure',
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
