// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';
import 'package:skoop/screens/skooper/skooperNavigationBar.dart';
import 'package:skoop/screens/user/login.dart';
import 'package:skoop/screens/user/widgets/navBar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token;
  bool isSkooper = false;
  @override
  void initState() {
    super.initState();
    getValidation().whenComplete(() => Timer(
          const Duration(seconds: 5),
          () {
            token == null
                ? Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()))
                : isSkooper
                    ? Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => SkooperBottomNavigationBar()))
                    : Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => bottomNavigationBar()));
          },
        ));
  }

  Future getValidation() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    var obtainedToken = sp.getString('token');
    bool? isSkoop = sp.getBool('isSkooper');
    setState(() {
      token = obtainedToken;
      isSkooper = isSkoop!;
    });
    print('token');
    print(token);
    print(token);
    print(token);
    print('isSkooper');
    print(isSkooper);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBG,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text('SKOOP',
                style: GoogleFonts.manrope(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
          SizedBox(
            height: 30.0,
          ),
          CircularProgressIndicator(
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
