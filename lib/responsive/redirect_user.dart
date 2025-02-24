import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';

class RedirectUser extends StatelessWidget {
  final Widget internLayout;
  final Widget employerLayout;

  const RedirectUser(
      {super.key, required this.internLayout, required this.employerLayout});

  Future<String?> getAccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accountId');
  }

  void showToast(BuildContext context, String message) {
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
          ),
        );
      },
      position: DelightSnackbarPosition.top,
      autoDismiss: true,
    ).show(context);
  }

  Future<String?> getAccountType(String accountId) async {
    final response = await http
        .get(Uri.parse('http://10.0.2.2:5152/api/Account/$accountId'));

    if (response.statusCode == 200) {
      var accountData = jsonDecode(response.body);
      return accountData['accountType']['id'].toString();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: getAccountId(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          showToast(context, 'Error loading account ID');
          return Center(child: Text('Error'));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          showToast(context, 'No Account ID found!');
          return Center(child: Text('No Account ID'));
        }

        final accountId = snapshot.data;

        return FutureBuilder<String?>(
          future: getAccountType(accountId!),
          builder: (context, typeSnapshot) {
            if (typeSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Color(0xFFfffffe),
              ));
            }

            if (typeSnapshot.hasError) {
              showToast(context, 'Error loading account type');
              return Center(child: Text('Error'));
            }

            if (!typeSnapshot.hasData || typeSnapshot.data == null) {
              showToast(context, 'Failed to get Account Type!');
              return Center(child: Text('Account Type Not Found'));
            }

            final accountTypeId = typeSnapshot.data;

            if (accountTypeId == '1') {
              return internLayout;
            }
            if (accountTypeId == '2') {
              return employerLayout;
            }

            return Center(child: Text('Invalid Account Type'));
          },
        );
      },
    );
  }
}
