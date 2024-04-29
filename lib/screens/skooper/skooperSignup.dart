// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:skoop/constant.dart';
import 'package:skoop/screens/skooper/skooperLogin.dart';
import 'package:skoop/screens/user/login.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';
import 'package:skoop/toast.dart';

class SkooperSignupScreen extends StatefulWidget {
  const SkooperSignupScreen({Key? key}) : super(key: key);

  @override
  State<SkooperSignupScreen> createState() => _SkooperSignupScreenState();
}

class _SkooperSignupScreenState extends State<SkooperSignupScreen>
    with SingleTickerProviderStateMixin {
  bool passwordObscured = true;
  bool passwordObscured2 = true;
  AnimationController? _controller;
  Animation<double>? _animation;
  bool isCostumer = true;
  bool _isTapped2 = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!);
  }

  @override
  void dispose() {
    _controller!.dispose();
    emailC.dispose();
    passC.dispose();
    studentIdC.dispose();
    passC2.dispose();
    fullNameC.dispose();
    super.dispose();
  }

  void _onTap1() {
    setState(() {
      isCostumer = true;
      _isTapped2 = false;
    });
    _controller!.reset();
    _controller!.forward();
  }

  void _onTap2() {
    setState(() {
      isCostumer = false;
      _isTapped2 = true;
    });
    _controller!.reset();
    _controller!.forward();
  }

  // bool isCostumer = true;
  bool checkedValue = false;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController passC2 = TextEditingController();
  TextEditingController studentIdC = TextEditingController();
  TextEditingController fullNameC = TextEditingController();
  signUpHere({var email, var fullName, var studentId, var pass}) async {
    try {
      http.Response response = await http.post(
        Uri.parse('$port/register'),
        body: {
          'student_id': studentId,
          'full_name': fullName,
          'email': email,
          'password': pass,
        },
      );
      if (response.statusCode == 201) {
        print('acc created successfully');
        showToastShort('Account created successfully', kPrimaryGreen);
        var token = jsonDecode(response.body.toString());
        print('token');
        print(token);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => SkooperLoginScreen()));
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
                      height: MediaQuery.of(context).size.height * .15,
                    ),
                    Text(
                      'Welcome!',
                      style: kTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      'Please provide following\n'
                      'details for your new account',
                      textAlign: TextAlign.center,
                      style: kSubTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: getTextField(
                        hintText: 'Full Name',
                        controller: fullNameC,
                        obsecureText: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: getTextField(
                        hintText: 'Student ID',
                        controller: studentIdC,
                        obsecureText: false,
                      ),
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
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: Container(
                        height: 50.0,
                        width: 327.0,
                        child: TextFormField(
                          obscureText: passwordObscured,
                          controller: passC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordObscured = !passwordObscured;
                                });
                              },
                              icon: Icon(
                                passwordObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xffcecece),
                              ),
                            ),
                            fillColor: kWhite,
                            filled: true,
                            labelText: 'Password',
                            hintStyle: kFieldStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: Container(
                        height: 50.0,
                        width: 327.0,
                        child: TextFormField(
                          obscureText: passwordObscured2,
                          controller: passC2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordObscured2 = !passwordObscured2;
                                });
                              },
                              icon: Icon(
                                passwordObscured2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xffcecece),
                              ),
                            ),
                            fillColor: kWhite,
                            filled: true,
                            labelText: 'Confirm Password',
                            hintStyle: kFieldStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _onTap1,
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOut,
                              height: 50.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                  color: isCostumer ? kSecondaryColor : kWhite,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                child: Text(
                                  'Customer',
                                  style: GoogleFonts.manrope(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isCostumer
                                          ? kWhite
                                          : kSupportiveGrey),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _onTap2,
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOut,
                              height: 50.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                  color: _isTapped2 ? kSecondaryColor : kWhite,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                child: Text(
                                  'Skooper',
                                  style: GoogleFonts.manrope(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: _isTapped2
                                          ? kWhite
                                          : kSupportiveGrey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
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
                          RichText(
                            text: TextSpan(
                              text: 'I have read and agree to ',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w600,
                                fontSize: 25.sp,
                                color: kSupportiveGrey,
                              ),
                              children: <TextSpan>[
                                // TextSpan(
                                //     text: 'I have read and aggree to ',
                                //     style: GoogleFonts.manrope(
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 12.sp,
                                //       color: kSupportiveGrey,
                                //     )),
                                TextSpan(
                                    text: ' terms & conditions',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 25.sp,
                                      color: kPrimaryGreen,
                                    )),
                                // TextSpan(
                                //     text: 'com',
                                //     style: TextStyle(
                                //         decoration: TextDecoration.underline))
                              ],
                            ),
                            textScaleFactor: 0.5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    getCtaButton(
                        onPress: () {
                          signUpHere(
                              email: emailC.text.toString(),
                              studentId: studentIdC.text.toString(),
                              fullName: fullNameC.text.toString(),
                              pass: passC.text.toString());
                        },
                        color: kPrimaryGreen,
                        text: 'Signup'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account ? ',
                          style: GoogleFonts.dmSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff868889),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'Login',
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
                                    builder: (_) => LoginScreen()));
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
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
