import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fl_sevengen_society_guard_app/localization/localization_const.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../api.dart';
import '../../api/notification.dart';
import '../../theme/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isMounted = false;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  DateTime? backPressTime;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _isMounted = false;
    super.dispose();
  }

  Future<void> _login() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter your credentials')),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}api/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userName': username,
          'userPassword': password,
        }),
      );

      if (response.statusCode == 200) {
        final userData = json.decode(response.body);
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        await prefs.setInt('society_id', userData['society_id']);
        await prefs.setInt('user_id', userData['id']);
        await prefs.setString('userName', username);

        final fcmToken = await FirebaseMessaging.instance.getToken();
        print("fcmToken>, $fcmToken");

        // Register FCM token
        if (fcmToken != null) {
          try {
            final tokenResponse = await http.post(
              Uri.parse('${ApiConfig.baseUrl}api/flutterNotification/register'),
              headers: {'Content-Type': 'application/json'},
              body: json.encode({
                'id': userData['id'],
                'token': fcmToken,
              }),
            );
            if (!_isMounted) return;
            if (tokenResponse.statusCode == 200) {
              print('FCM token registered successfully');
              bool notificationSent = await sendNotifications(
                fcmToken: fcmToken,
                title: "Welcome 😊",
                body: "You have successfully logged in!",
              );
              if (_isMounted) {
                if (notificationSent) {
                  print("Welcome notification sent successfully");
                }
              } else {
                if (_isMounted) {
                  print("Failed to send welcome notification");
                }
              }
            } else {
              print(
                  'Failed to register FCM token. Status code: ${tokenResponse.statusCode}');
              print('Response body: ${tokenResponse.body}');
            }
          } catch (e) {
            print('Error registering FCM token: $e');
          }
        }

        // Fetch additional details from another API
        final detailsResponse = await http.get(
          Uri.parse(
              '${ApiConfig.baseUrl}api/societyManagement/details/allusers'),
          headers: {'Content-Type': 'application/json'},
        );

        if (detailsResponse.statusCode == 200) {
          final detailsData = json.decode(detailsResponse.body);

          // Find the details for the current user
          final userDetail = detailsData.firstWhere(
            (detail) => detail['user']['userName'] == username,
            orElse: () => null,
          );

          if (userDetail != null && userDetail['flat'] != null) {
            final flat = userDetail['flat'];
            await prefs.setString('block_name', flat['block_name']);
            await prefs.setString('tower_name', flat['tower_name']);
            await prefs.setInt('floor_number', flat['floor_number']);
            await prefs.setString('flat_number', flat['flat_number']);
          } else {
            // Clear any existing flat data if the user doesn't have flat information
            await prefs.remove('block_name');
            await prefs.remove('tower_name');
            await prefs.remove('floor_number');
            await prefs.remove('flat_number');
          }

          // Navigate to the next screen if login is successful
          if (userData['userType'] == 3 && userData['parkingType'] == 2) {
            Navigator.pushReplacementNamed(
              context,
              '/bottombar',
              arguments: userData,
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('You do not have permission to log in.')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to fetch user details.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvoked: (bool key) {
        bool backStatus = onWillPop();
        if (backStatus) {
          exit(0);
        }
      },
      child: Scaffold(
        body: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/auth/bg.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(fixPadding * 2.0),
            physics: const BouncingScrollPhysics(),
            children: [
              heightBox(fixPadding * 6),
              loginTitle(),
              heightSpace,
              pleaseText(),
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
              usernameField(),
              heightSpace,
              passwordField(),
              heightSpace,
              // phoneField(),
              height5Space,
              verificationText(),
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
              heightSpace,
              height5Space,
              loginButton(),
              heightSpace,
              dontHaveAccountText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget usernameField() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: TextField(
        controller: _usernameController,
        cursorColor: primaryColor,
        style: semibold16Black33,
        textAlign: languageValue == 4 ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: getTranslate(context, 'login.enter_username'),
          hintStyle: medium16Grey,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: fixPadding, vertical: fixPadding * 1.4),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: 12.0,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: TextField(
        controller: _passwordController,
        cursorColor: primaryColor,
        style: semibold16Black33,
        obscureText: true,
        textAlign: languageValue == 4 ? TextAlign.right : TextAlign.left,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: getTranslate(context, 'login.enter_password'),
          hintStyle: medium16Grey,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: fixPadding, vertical: fixPadding * 1.4),
        ),
      ),
    );
  }

  loginButton() {
    return GestureDetector(
      // onTap: () {
      //   Navigator.pushNamed(context, '/register');
      // },
      onTap: _login,
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.symmetric(
            horizontal: fixPadding * 2.0, vertical: fixPadding * 1.4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.1),
              blurRadius: 12.0,
              offset: const Offset(0, 6),
            )
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          getTranslate(context, 'login.login'),
          style: semibold18White,
        ),
      ),
    );
  }

  verificationText() {
    return Text(
      getTranslate(context, 'login.login_text'),
      style: medium14Primary,
    );
  }

  // phoneField() {
  //   return Container(
  //     width: double.maxFinite,
  //     decoration: BoxDecoration(
  //       color: whiteColor,
  //       borderRadius: BorderRadius.circular(10.0),
  //       boxShadow: [
  //         BoxShadow(
  //           color: blackColor.withOpacity(0.1),
  //           blurRadius: 12.0,
  //           offset: const Offset(0, 6),
  //         )
  //       ],
  //     ),
  //     child: IntlPhoneField(
  //       cursorColor: primaryColor,
  //       style: semibold16Black33,
  //       dropdownIconPosition: IconPosition.trailing,
  //       dropdownIcon: const Icon(
  //         Icons.keyboard_arrow_down_outlined,
  //         color: blackColor,
  //       ),
  //       textAlign: languageValue == 4 ? TextAlign.right : TextAlign.left,
  //       flagsButtonPadding:
  //           const EdgeInsets.symmetric(horizontal: fixPadding * 0.8),
  //       disableLengthCheck: true,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: getTranslate(context, 'login.enter_mobile_number'),
  //         hintStyle: medium16Grey,
  //       ),
  //     ),
  //   );
  // }

  pleaseText() {
    return Text(
      getTranslate(context, 'login.please_text'),
      style: medium14Grey77,
      textAlign: TextAlign.center,
    );
  }

  loginTitle() {
    return Text(
      getTranslate(context, 'login.LOGIN'),
      style: semibold21Primary,
      textAlign: TextAlign.center,
    );
  }

  onWillPop() {
    DateTime now = DateTime.now();
    if (backPressTime == null ||
        now.difference(backPressTime!) >= const Duration(seconds: 2)) {
      backPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: blackColor,
          content: Text(
            getTranslate(context, 'exit_app.exit_text'),
            style: semibold15White,
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1500),
        ),
      );
      return false;
    } else {
      return true;
    }
  }

  dontHaveAccountText() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/register');
      },
      child: Center(
        child: RichText(
          text: TextSpan(
            text: "Don't have an account? ",
            style: TextStyle(
              color: Colors.black, // Color for "Don't have an account?"
            ),
            children: [
              TextSpan(
                text: 'Register',
                style: TextStyle(
                  color: Colors.blue, // Blue color for "Register"
                  decoration:
                      TextDecoration.underline, // Underline for "Register"
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
