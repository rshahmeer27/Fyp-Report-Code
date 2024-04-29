import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constant.dart';
import '../../stripeService.dart';

class WithdrawScreen extends StatefulWidget {
  const WithdrawScreen({Key? key}) : super(key: key);

  @override
  State<WithdrawScreen> createState() => _WithdrawScreenState();
}

class _WithdrawScreenState extends State<WithdrawScreen> {
  TextEditingController numberController = TextEditingController();
  final String _accountId = 'skoop-lhnmr.zensmb';
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

  void _withdraw() async {
    try {
      final response =
          await StripeService.createPayout(_accountId, numberController.text);
      print('Payout response: $response');
      // Handle success or error cases
    } catch (e) {
      print('Payout error: $e');
      // Handle error cases
    }
  }

  // withDrawAmount(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             'Enter Deposit Amount',
  //             style: GoogleFonts.nunitoSans(
  //               fontSize: 16.sp,
  //               fontWeight: FontWeight.w700,
  //               color: const Color(0xff000000),
  //               // height: 22.h
  //             ),
  //           ),
  //           content: Column(
  //             children: [
  //               TextField(
  //                 decoration: const InputDecoration(labelText: 'Recipient Account ID'),
  //                 onChanged: (value) {
  //                   setState(() {
  //                     _accountId = value;
  //                   });
  //                 },
  //               ),
  //               const SizedBox(height: 16),
  //               TextField(
  //                 decoration: const InputDecoration(labelText: 'Withdraw Amount'),
  //                 keyboardType: TextInputType.number,
  //                 onChanged: (value) {
  //                   setState(() {
  //                     _withdrawAmount = int.tryParse(value) ?? 0;
  //                   });
  //                 },
  //               ),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //               child: const Text(
  //                 'Cancel',
  //                 style: TextStyle(color: Colors.red),
  //               ),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //             TextButton(
  //               onPressed: _withdraw,
  //               child: const Text('Continue'),
  //             )
  //           ],
  //         );
  //       });
  // }
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
          'Withdraw',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 32.w),
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
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
                child: Container(
                  height: 50.0,
                  width: 327.0,
                  child: TextFormField(
                    controller: numberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      suffixIcon: Image.asset(
                        'assets/icons/dollarField.png',
                        scale: 2.3,
                      ),
                      fillColor: kWhite,
                      filled: true,
                      labelText: 'Enter Amount',
                      hintStyle: kFieldStyle,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 19.h,
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
                      'Credit Card',
                      style: GoogleFonts.manrope(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w800,
                        color: kSupportiveGrey,
                      ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      color: kSupportiveGrey,
                      size: 18,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 11.h,
              ),
              Container(
                width: 326.w,
                height: 220.h,
                decoration: BoxDecoration(
                    color: kPrimaryGreen,
                    borderRadius: BorderRadius.circular(24)),
                padding:
                    EdgeInsets.only(left: 27, right: 24, top: 31, bottom: 6),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/icons/chip.png',
                          width: 38,
                          height: 26,
                        ),
                        SizedBox(
                          width: 85,
                        ),
                        Image.asset(
                          'assets/icons/payment.png',
                          width: 120,
                          height: 26,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      '**** **** **** 1234',
                      style: TextStyle(
                        fontFamily: 'ocra',
                        fontWeight: FontWeight.w400,
                        fontSize: 24.sp,
                        color: kWhite,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'VALID\nTHRU',
                                  style: GoogleFonts.ibmPlexSans(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 8.sp,
                                    color: kWhite,
                                  ),
                                ),
                                SizedBox(
                                  width: 8.w,
                                ),
                                Text(
                                  '12/24',
                                  style: TextStyle(
                                    fontFamily: 'ocra',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 24.sp,
                                    color: kWhite,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'ABDUL HANNAN',
                              style: GoogleFonts.manrope(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w400,
                                color: kWhite,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 90.w,
                        ),
                        Image.asset(
                          'assets/icons/mastercardA.png',
                          width: 40.0,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 160.h,
        width: 390.w,
        decoration: BoxDecoration(
          color: kBG,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 25.h,
            ),
            GestureDetector(
              onTap: _withdraw,
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
                    Text(
                      'Send Request',
                      style: GoogleFonts.manrope(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w700,
                        color: kWhite,
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 14.h,
            ),
            GestureDetector(
                child: Container(
                  width: 326.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: kSupportiveGrey,
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
                        'Cancel',
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
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
