import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skoop/screens/user/singleFoodItem.dart';

import '../../constant.dart';

class SeeAllItemScreen extends StatefulWidget {
  const SeeAllItemScreen({Key? key}) : super(key: key);

  @override
  State<SeeAllItemScreen> createState() => _SeeAllItemScreenState();
}

class _SeeAllItemScreenState extends State<SeeAllItemScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: 390.w,
              height: 289.h,
              decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/rest1.png'),
                    fit: BoxFit.fill),
              ),
            ),
            Positioned(
              child: Container(
                margin: EdgeInsets.only(left: 24.w, right: 24.w, top: 21.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 37.w,
                      height: 37.h,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/back_icon.png',
                              width: 7.w,
                              height: 14.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: 37.w,
                      height: 37.h,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(24.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/heart1.png',
                            width: 20.w,
                            height: 18.h,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 170.h,
              child: Container(
                height: 600.h,
                width: 390.w,
                decoration: BoxDecoration(
                  color: kBG,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.r),
                    topRight: Radius.circular(35.r),
                  ),
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 9.h,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 28.w, right: 29.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'McDonalds',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontSize: 20.sp,
                                color:
                                    !isDark ? kSecondaryColor : kSupportiveGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Text(
                        'Restaurant',
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                          color: kSupportiveGrey,
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 32.w, right: 32.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SingleFoodItem('')));
                              },
                              child: SizedBox(
                                height: 192.h,
                                width: 147.w,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Image.asset(
                                        'assets/images/burger.png',
                                        width: 145.w,
                                        height: 100.h,
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20.w),
                                            child: Text(
                                              'Beef Burger',
                                              style: GoogleFonts.manrope(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: kSecondaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20.w),
                                            child: Text(
                                              'McDonalds',
                                              style: GoogleFonts.manrope(
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.w500,
                                                color: kSupportiveGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 11.h,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20.w),
                                            child: Text(
                                              '\$ 33.00',
                                              style: GoogleFonts.manrope(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w800,
                                                color: kSecondaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 192.h,
                              width: 147.w,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Image.asset(
                                      'assets/images/burger.png',
                                      width: 145.w,
                                      height: 100.h,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            'Beef Burger',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            'McDonalds',
                                            style: GoogleFonts.manrope(
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w500,
                                              color: kSupportiveGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 11.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            '\$ 33.00',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 32.w, right: 32.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SingleFoodItem('')));
                              },
                              child: SizedBox(
                                height: 192.h,
                                width: 147.w,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.r)),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Image.asset(
                                        'assets/images/burger.png',
                                        width: 145.w,
                                        height: 100.h,
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20.w),
                                            child: Text(
                                              'Beef Burger',
                                              style: GoogleFonts.manrope(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w600,
                                                color: kSecondaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20.w),
                                            child: Text(
                                              'McDonalds',
                                              style: GoogleFonts.manrope(
                                                fontSize: 9.sp,
                                                fontWeight: FontWeight.w500,
                                                color: kSupportiveGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 11.h,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 20.w),
                                            child: Text(
                                              '\$ 33.00',
                                              style: GoogleFonts.manrope(
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w800,
                                                color: kSecondaryColor,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 192.h,
                              width: 147.w,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Image.asset(
                                      'assets/images/burger.png',
                                      width: 145.w,
                                      height: 100.h,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            'Beef Burger',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            'McDonalds',
                                            style: GoogleFonts.manrope(
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w500,
                                              color: kSupportiveGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 11.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            '\$ 33.00',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 32.w, right: 32.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 192.h,
                              width: 147.w,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Image.asset(
                                      'assets/images/burger.png',
                                      width: 145.w,
                                      height: 100.h,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            'Beef Burger',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            'McDonalds',
                                            style: GoogleFonts.manrope(
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w500,
                                              color: kSupportiveGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 11.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            '\$ 33.00',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 192.h,
                              width: 147.w,
                              child: Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                    Image.asset(
                                      'assets/images/burgur.png',
                                      width: 145.w,
                                      height: 100.h,
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            'Beef Burger',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            'McDonalds',
                                            style: GoogleFonts.manrope(
                                              fontSize: 9.sp,
                                              fontWeight: FontWeight.w500,
                                              color: kSupportiveGrey,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 11.h,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(left: 20.w),
                                          child: Text(
                                            '\$ 33.00',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w800,
                                              color: kSecondaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 33.h,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
