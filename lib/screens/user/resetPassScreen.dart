// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';

import '../../toast.dart';
import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  var email;
  ResetPasswordScreen(this.email);

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool checkedValue = false;
  TextEditingController passC1 = TextEditingController();
  TextEditingController passC2 = TextEditingController();
  signUpHere({var pass}) async {
    try {
      http.Response response = await http.patch(
        Uri.parse('$port/reset-password/'),
        body: {
          'email': widget.email,
          'password': pass,
        },
      );
      if (response.statusCode == 204) {
        print('pass reset successfully');
        showToastShort('Password reset successfully', kPrimaryGreen);
        var token = jsonDecode(response.body.toString());
        print('token');
        print(token);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        print('response.statusCode');
        print(response.statusCode);
        showToastShort(response.statusCode.toString(), Colors.red);
        var token = jsonDecode(response.body.toString());
        print('token');
        print(token);
        print('error');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBG,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kBG,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kSecondaryColor,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Reset Password',
            style: kAppbarStyle,
          ),
        ),
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
                      height: MediaQuery.of(context).size.height * .1,
                    ),
                    Text(
                      'New Password',
                      style: kTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      'New password must be different from\n'
                      'previously used password.',
                      textAlign: TextAlign.center,
                      style: kSubTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .07,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: getTextField(
                        hintText: 'Password',
                        controller: passC1,
                        obsecureText: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: getTextField(
                        hintText: 'Confirm Password',
                        controller: passC2,
                        obsecureText: false,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    getCtaButton(
                      text: 'Continue',
                      onPress: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => bottomNavigationBar()));
                        if (passC1.text == passC2.text) {
                          signUpHere(pass: passC1.text);
                        } else {
                          showToastShort('Password does not match', Colors.red);
                        }
                      },
                      color: kPrimaryGreen,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       'Don\'t have an account ? ',
                    //       style: GoogleFonts.dmSans(
                    //         fontSize: 15.sp,
                    //         fontWeight: FontWeight.w400,
                    //         color: const Color(0xff868889),
                    //       ),
                    //     ),
                    //     GestureDetector(
                    //       child: Text(
                    //         'Sign Up',
                    //         style: GoogleFonts.dmSans(
                    //           fontSize: 15.sp,
                    //           fontWeight: FontWeight.w700,
                    //           color: kPrimaryGreen,
                    //         ),
                    //       ),
                    //       onTap: () {
                    //         Navigator.push(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (_) => SignupScreen()));
                    //       },
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
