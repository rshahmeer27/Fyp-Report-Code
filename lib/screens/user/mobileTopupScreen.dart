import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';

import '../../constant.dart';

class MobileTopUpScreen extends StatefulWidget {
  const MobileTopUpScreen({Key? key}) : super(key: key);

  @override
  State<MobileTopUpScreen> createState() => _MobileTopUpScreenState();
}

class _MobileTopUpScreenState extends State<MobileTopUpScreen> {
  TextEditingController numberController = TextEditingController();
  Future<dynamic> getProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/customer/');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      print('userData');
      // walletAmount = userData['restaurant']['balance'];
      return userData['customer']['balance'];
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

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
          'Mobile Top Up',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 32.w),
        decoration: BoxDecoration(
          color: isDark ? kDarkBg : kBG,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 26.h,
            ),
            FutureBuilder(
              future: getProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    width: 328.w,
                    height: 128.h,
                    decoration: BoxDecoration(
                      color: kSecondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.only(left: 21),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Balance',
                          style: GoogleFonts.manrope(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: kBalance,
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            text: '\$ ${snapshot.data.toString()}',
                            style: GoogleFonts.manrope(
                                fontSize: 36.sp,
                                fontWeight: FontWeight.w700,
                                color: kWhite), // default text style
                            children: [
                              TextSpan(
                                text: '.84',
                                style: GoogleFonts.manrope(
                                    fontSize: 24.sp,
                                    fontWeight: FontWeight.w400,
                                    color: kWhite),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  // An error occurred while fetching user data
                  return Text('Error: ${snapshot.error}');
                }

                // Data is still loading
                return const Center(
                    child: CircularProgressIndicator(
                  color: kPrimaryGreen,
                ));
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              margin: EdgeInsets.only(left: 31.w, right: 33.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Latest Transactions',
                    style: GoogleFonts.manrope(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: !isDark ? kSecondaryColor : kSupportiveGrey,
                    ),
                  ),
                  // Text(
                  //   'See all',
                  //   style: GoogleFonts.manrope(
                  //     fontWeight: FontWeight.w500,
                  //     fontSize: 14.sp,
                  //     color: kSupportiveGrey2,
                  //   ),
                  // )
                ],
              ),
            ),
            SizedBox(
              height: 19.h,
            ),
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
              child: getTextField(
                hintText: 'Enter Phone Number',
                controller: numberController,
                obsecureText: false,
                icon: null,
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 202.h,
        width: 390.w,
        decoration: BoxDecoration(
          color: kBG,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          // boxShadow: const [
          //   BoxShadow(
          //     color: kBG,
          //     spreadRadius: 20,
          //     blurRadius: 10,
          //     offset: Offset(0, 0), // changes position of shadow
          //   ),
          // ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 25.h,
            ),
            GestureDetector(
                child: Container(
                  width: 326.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: kPrimaryGreen,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset(
                      //   'assets/icons/cart_icon.png',
                      //   width: 25.w,
                      //   height: 26.h,
                      // ),
                      // SizedBox(
                      //   width: 14.w,
                      // ),
                      Text(
                        'Continue',
                        style: GoogleFonts.manrope(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: kWhite,
                        ),
                      )
                    ],
                  ),
                ),

                // Within the `FirstRoute` widget
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const CheckOutScreen()),
                  // );
                }),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
