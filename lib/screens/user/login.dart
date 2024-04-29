// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';
import 'package:skoop/screens/skooper/skooperNavigationBar.dart';
import 'package:skoop/screens/user/forgotPass.dart';
import 'package:skoop/screens/user/signup.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';
import 'package:skoop/screens/user/widgets/navBar.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';

import '../../toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // var fcmToken;
  // getFcm() async {
  //   fcmToken = await FirebaseMessaging.instance.getToken();
  //   print(fcmToken);
  //   print(fcmToken);
  // }

  bool checkedValue = false;
  bool isSkooper = false;
  bool passwordObscured = true;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  signinHere({var email, var pass, var tokenn}) async {
    // Request permission for notifications
    final NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    } else {}
    try {
      // final tokenn = await FirebaseMessaging.instance.getToken();
      http.Response response = await http.post(
        Uri.parse('$port/sign-in/'),
        body: {'email': email, 'password': pass, 'token': tokenn},
      );
      if (response.statusCode == 200) {
        SharedPreferences sp = await SharedPreferences.getInstance();
        // print(jsonDecode(response.body.toString()));
        showToastShort('Login Successful', kPrimaryGreen);
        var user = jsonDecode(response.body.toString());
        sp.setString('token', user['token']);

        sp.setString('email', email).whenComplete(() {
          getProfile();
        });
      } else {
        showToastShort(
            jsonDecode(response.body.toString())["message"], Colors.red);
        var token = jsonDecode(response.body.toString());
        print(token);
      }
    } catch (e) {
      print('e.toString()');
      print(e.toString());
      showToastShort("Server Error", Colors.red);
    }
  }

  getProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$port/customer/');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      final user = userData;
      isSkooper = user['customer']['role'] == "skooper";
      print('user');
      print(user);
      sp.setString('id', user['customer']['_id']);
      sp.setString('user', json.encode(user));
      sp.setBool('isSkooper', user['customer']['role'] == "skooper");
      print('id');
      print(sp.get('id'));
      print('user stored');
      print(sp.get('user'));
      print("=================user role ${sp.get("isSkooper")}");

      if (isSkooper) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => SkooperBottomNavigationBar()));
      } else {
        print("Customer");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => bottomNavigationBar()));
      }
      // Return the user object
      // return user;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch restaurant data');
    }
  }

  @override
  void dispose() {
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getFcm();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBG,
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      'Welcome Back',
                      style: kTitleStyle.copyWith(
                          color: !isDark ? kcardColor : kWhite),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      'Login to continue ',
                      style: kSubTitleStyle,
                    ),
                    SizedBox(
                      height: 85.h,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: getTextField(
                        hintText: 'Email',
                        controller: emailC,
                        obsecureText: false,
                      ),
                    ),
                    Container(
                      padding:
                          const EdgeInsets.only(left: 30, right: 30, bottom: 0),
                      child: getTextField(
                        hintText: 'Password',
                        controller: passC,
                        obsecureText: passwordObscured,
                        icon: IconButton(
                          onPressed: () {
                            setState(() {
                              passwordObscured = !passwordObscured;
                            });
                          },
                          icon: Icon(
                            passwordObscured
                                ? Icons.remove_red_eye_rounded
                                : Icons.visibility_off,
                            color: Color(0xffcecece),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // SizedBox(
                          //   width: 10.0,
                          // ),
                          Container(
                            margin: EdgeInsets.only(left: 1.0),
                            child: Checkbox(
                              value: checkedValue,
                              onChanged: (value) {
                                setState(() {
                                  checkedValue = value!;
                                });
                              },
                            ),
                          ),
                          Text(
                            "Remember Me",
                            style: GoogleFonts.manrope(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: !isDark ? kcardColor : kWhite,
                            ),
                          ),
                          SizedBox(
                            width: 100.0,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ForgotScreen()));
                            },
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: Color(0xffafafaf)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Checkbox(
                    //   title: Text(
                    //     "Remember Me",
                    //     style: GoogleFonts.manrope(
                    //       fontSize: 12.sp,
                    //       fontWeight: FontWeight.w500,
                    //       color: kGreyTextColor,
                    //     ),
                    //   ),
                    //   secondary: GestureDetector(
                    //     onTap: () {
                    //       Navigator.push(context,
                    //           MaterialPageRoute(builder: (_) => ForgotScreen()));
                    //     },
                    //     child: Text(
                    //       'Forgot Password',
                    //       style: GoogleFonts.manrope(
                    //           fontWeight: FontWeight.w600,
                    //           fontSize: 12.sp,
                    //           color: Color(0xffafafaf)),
                    //     ),
                    //   ),
                    //   tristate: true,
                    //   value: checkedValue,
                    //   onChanged: (newValue) {
                    //     setState(() {
                    //       checkedValue = newValue!;
                    //     });
                    //   },
                    //   controlAffinity: ListTileControlAffinity
                    //       .leading, //  <-- leading Checkbox
                    // ),
                    SizedBox(
                      height: 20.0,
                    ),
                    getCtaButton(
                        onPress: () async {
                          // print('pressed');
                          // FirebaseMessaging.instance.getToken().then((value) {
                          // signinHere(email: emailC.text, pass: passC.text);
                          // });
                          // final fcmToken =
                          //     await FirebaseMessaging.instance.getToken();
                          // print('fcmToken on tap');
                          // print(fcmToken);
                          print("AT LOGIN");
                          try {
                            if (emailC.text.isEmpty && passC.text.isEmpty) {
                              showToastShort(
                                  "Email and Password is required", Colors.red);
                            } else if (emailC.text.isEmpty) {
                              showToastShort("Email is required", Colors.red);
                            } else if (passC.text.isEmpty) {
                              showToastShort(
                                  "Password is required", Colors.red);
                            } else {
                              final token =
                                  await FirebaseMessaging.instance.getToken();
                              signinHere(
                                email: emailC.text,
                                pass: passC.text,
                                tokenn: token,
                              );
                            }
                          } catch (e) {
                            // Handle the exception here, show an error message or set a default token.
                            print('Failed to get FCM token: $e');
                          }
                        },
                        color: kPrimaryGreen,
                        text: 'Login'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account ? ',
                          style: GoogleFonts.dmSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff868889),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'Sign Up',
                            style: GoogleFonts.dmSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryGreen,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SignupScreen()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        // bottomSheet: Container(
        //   height: 100.0,
        //   color: kBG,
        //   child: GestureDetector(
        //     onTap: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (_) => SkooperLoginScreen()));
        //     },
        //     child: Center(
        //       child: Text(
        //         'Login as Skooper',
        //         style: kSubTitleStyle,
        //       ),
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
