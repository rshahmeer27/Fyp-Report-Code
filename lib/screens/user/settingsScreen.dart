// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/paymentMethods.dart';
import 'package:skoop/toast.dart';

import '../../constant.dart';
import 'changePassScreen.dart';
import 'login.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBG,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: !isDark ? kSecondaryColor : kSupportiveGrey,
            ),
            // Within the `FirstRoute` widget
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Settings',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 32.w),
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 26.h,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => PaymentMethodScreen()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Add Payment Method',
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              indent: 30,
              endIndent: 30,
            ),
            SizedBox(
              height: 26.h,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChangePasswordScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Change Password',
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              indent: 30,
              endIndent: 30,
            ),
            SizedBox(
              height: 26.h,
            ),
            GestureDetector(
              onTap: () {
                deleteAcc(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Delete Profile',
                      style: GoogleFonts.manrope(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(
              indent: 30,
              endIndent: 30,
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }

  deleteAcc(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Delete Account',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: Text(
              'Are you sure you want to Delete Account?',
              style: GoogleFonts.nunitoSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff000000),
                // height: 22.h
              ),
            ),
            actions: [
              Center(
                child: TextButton(
                  child: const Text(
                    'No',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              Center(
                child: TextButton(
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () async {
                    SharedPreferences sp =
                        await SharedPreferences.getInstance();
                    final id = sp.getString('id').toString();
                    deleteAccount(id);
                  },
                ),
              )
            ],
          );
        });
  }

  Future<void> deleteAccount(String id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/delete/$id');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 204) {
      showToastShort('Account deleted successfully', kRedColor);
      sp.remove('token');
      sp.remove('id');
      sp.remove('itemListCartA');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      showToastShort(
          'Failed to delete account. Status code: ${response.statusCode}',
          kRedColor);
      print('Response body: ${response.body}');
    }
  }
}
