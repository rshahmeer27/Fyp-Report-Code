import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant.dart';
import 'notificaitonsOptions.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CartScreen()),
              // );
            }),
        title: Text(
          'Notifications',
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
            Container(
              height: 100.h,
              width: 329.w,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/notification1.png',
                    width: 91.w,
                    height: 74.h,
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      // Text(
                      //   'Beef Burger',
                      //   style: GoogleFonts.manrope(
                      //     fontWeight: FontWeight.w800,
                      //     fontSize: 16.sp,
                      //     color: kSecondaryColor,
                      //   ),
                      // ),
                      Text.rich(
                        TextSpan(
                          text: 'David Astol',
                          style: GoogleFonts.manrope(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: !isDark
                                  ? kSecondaryColor
                                  : kSupportiveGrey), // default text style
                          children: [
                            TextSpan(
                              text:
                                  ' , I has picked\nyour order and he is on the\nway. Please wait',
                              style: GoogleFonts.manrope(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: kSecondaryColor),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      // Text(
                      //   'Espresso Cafe',
                      //   style: GoogleFonts.manrope(
                      //     fontSize: 12.sp,
                      //     fontWeight: FontWeight.w600,
                      //     color: kSupportiveGrey,
                      //   ),
                      // ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Just Now',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: kSupportiveGrey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      notificationOption(context);
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: kSupportiveGrey,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 30.0,
              endIndent: 30.0,
            ),
            Container(
              height: 100.h,
              width: 329.w,
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/notification2.png',
                    width: 91.w,
                    height: 74.h,
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5.h,
                      ),
                      // Text(
                      //   'Beef Burger',
                      //   style: GoogleFonts.manrope(
                      //     fontWeight: FontWeight.w800,
                      //     fontSize: 16.sp,
                      //     color: kSecondaryColor,
                      //   ),
                      // ),
                      Text.rich(
                        TextSpan(
                          text: 'Expresso Cafe',
                          style: GoogleFonts.manrope(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w800,
                              color: !isDark
                                  ? kSecondaryColor
                                  : kSupportiveGrey), // default text style
                          children: [
                            TextSpan(
                              text:
                                  ' , your\norder and he is on the way.\nPlease wait',
                              style: GoogleFonts.manrope(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: kSecondaryColor),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(
                      //   height: 3.h,
                      // ),
                      // Text(
                      //   'Espresso Cafe',
                      //   style: GoogleFonts.manrope(
                      //     fontSize: 12.sp,
                      //     fontWeight: FontWeight.w600,
                      //     color: kSupportiveGrey,
                      //   ),
                      // ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Text(
                            'Just Now',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              color: kSupportiveGrey,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    width: 40.w,
                  ),
                  GestureDetector(
                    onTap: () {
                      notificationOption(context);
                    },
                    child: Icon(
                      Icons.more_vert,
                      size: 20,
                      color: kSupportiveGrey,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              indent: 30.0,
              endIndent: 30.0,
            ),
          ],
        ),
      ),
      // bottomSheet: Container(
      //   height: 202.h,
      //   width: 390.w,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30.r),
      //       topRight: Radius.circular(30.r),
      //     ),
      //     boxShadow: const [
      //       BoxShadow(
      //         color: kBG,
      //         spreadRadius: 20,
      //         blurRadius: 10,
      //         offset: Offset(0, 0), // changes position of shadow
      //       ),
      //     ],
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       SizedBox(
      //         height: 25.h,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               Text(
      //                 '\$',
      //                 style: GoogleFonts.manrope(
      //                   fontWeight: FontWeight.w800,
      //                   fontSize: 22.sp,
      //                   color: kSecondaryColor,
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Text(
      //             '62.00',
      //             style: GoogleFonts.manrope(
      //               fontWeight: FontWeight.w800,
      //               fontSize: 30.sp,
      //               color: kSecondaryColor,
      //             ),
      //           )
      //         ],
      //       ),
      //       Text(
      //         '2 Items',
      //         style: GoogleFonts.manrope(
      //           fontSize: 15.sp,
      //           fontWeight: FontWeight.w600,
      //           color: kSupportiveGrey,
      //         ),
      //       ),
      //       GestureDetector(
      //           child: Container(
      //             width: 326.w,
      //             height: 50.h,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(10.r),
      //               color: kPrimaryGreen,
      //             ),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Image.asset(
      //                   'assets/icons/cart_icon.png',
      //                   width: 25.w,
      //                   height: 26.h,
      //                 ),
      //                 SizedBox(
      //                   width: 14.w,
      //                 ),
      //                 Text(
      //                   'Check Out',
      //                   style: GoogleFonts.manrope(
      //                     fontSize: 17.sp,
      //                     fontWeight: FontWeight.w700,
      //                     color: kWhite,
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //
      //           // Within the `FirstRoute` widget
      //           onTap: () {
      //             // Navigator.push(
      //             //   context,
      //             //   MaterialPageRoute(
      //             //       builder: (context) => const CheckOutScreen()),
      //             // );
      //           }),
      //       SizedBox(
      //         height: 20.h,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
