// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';
import 'package:skoop/screens/user/widgets/navBar.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';

import '../../toast.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool checkedValue = false;
  TextEditingController passC1 = TextEditingController();
  TextEditingController passC2 = TextEditingController();
  signUpHere({var pass1, var pass2}) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      final token = sp.getString('token');
      final email = sp.getString('email');
      final url = Uri.parse('http://$port/change-password/');
      final body = {'email': email, 'password': pass1, 'new_password': pass2};
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.patch(url, body: body, headers: headers);
      if (response.statusCode == 204) {
        // print('pass reset successfully');
        showToastShort('Password Changed successfully', kPrimaryGreen);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => bottomNavigationBar()));
      } else {
        print('response.statusCode');
        print(response.statusCode);
        showToastShort('Error: ${response.statusCode.toString()}', Colors.red);
        // var token = jsonDecode(response.body.toString());
        // print('token');
        // print(token);
        // print('error');
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
            'Change Password',
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
                        hintText: 'New Password',
                        controller: passC2,
                        obsecureText: false,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    getCtaButton(
                      text: 'Change Password',
                      onPress: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => bottomNavigationBar()));
                        if (passC1.text.isNotEmpty && passC2.text.isNotEmpty) {
                          signUpHere(pass1: passC1.text, pass2: passC2.text);
                        } else {
                          showToastShort('Fill All Fields', Colors.red);
                        }
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
