// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/forgotPass.dart';
import 'package:skoop/screens/user/resetPassScreen.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';

import '../../toast.dart';

class GetCodeScreen extends StatefulWidget {
  var email;
  GetCodeScreen(this.email);

  @override
  State<GetCodeScreen> createState() => _GetCodeScreenState();
}

class _GetCodeScreenState extends State<GetCodeScreen> {
  bool checkedValue = false;
  TextEditingController otpController = TextEditingController();
  enterOtp(var otp) async {
    final url = Uri.parse('$port/otpVerify/${widget.email}/$otp');
    // final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      showToastShort('OTP Matched', kPrimaryGreen);
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => ResetPasswordScreen(widget.email)));
    } else {
      showToastShort('${response.statusCode}:Invalid OTP', Colors.red);
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
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
            'Email Verification',
            style: kAppbarStyle,
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .004,
                    ),
                    Text(
                      'Get Your Code',
                      style: kTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      'Enter the 4 digit code that send\n'
                      'to your email address.',
                      textAlign: TextAlign.center,
                      style: kSubTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .07,
                    ),

                    ///otp screen
                    OtpTextField(
                      fillColor: kWhite,
                      filled: true,
                      numberOfFields: 4,
                      // borderColor: kSecondaryColor,
                      //set to true to show as box or false to show as dash
                      showFieldAsBox: true,
                      //runs when a code is typed in
                      onCodeChanged: (String code) {
                        //handle validation or checks here
                      },
                      //runs when every textfield is filled
                      onSubmit: (String verificationCode) {
                        otpController.text = verificationCode;
                      }, // end onSubmit
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    getCtaButton(
                      text: 'Verify',
                      onPress: () {
                        enterOtp(otpController.text);
                      },
                      color: kPrimaryGreen,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'If you don\'t recieve code! ',
                          style: GoogleFonts.dmSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff868889),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'Resend',
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
                                    builder: (_) => ForgotScreen()));
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
      ),
    );
  }
}
