// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/getCodeScreen.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';
import 'package:skoop/toast.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({Key? key}) : super(key: key);

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  bool checkedValue = false;
  TextEditingController emailAddress = TextEditingController();
  TextEditingController passC = TextEditingController();
  getOTP(var email) async {
    final url = Uri.parse('$port/otp/$email');
    // final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      showToastShort('Check Your Email', kPrimaryGreen);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => GetCodeScreen(email)));
    } else {
      showToastShort('${response.statusCode}:Invalid Email', Colors.red);
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
            'Forgot Password',
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
                      'Your Email Here',
                      style: kTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      'Enter the email address associated\n'
                      'with your account',
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
                        hintText: 'Email Address',
                        controller: emailAddress,
                        obsecureText: false,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    getCtaButton(
                      text: 'Recover Password',
                      onPress: () {
                        getOTP(emailAddress.text);
                      },
                      color: kPrimaryGreen,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
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
