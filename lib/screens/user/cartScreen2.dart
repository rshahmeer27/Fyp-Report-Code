import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant.dart';

class CartScreen2 extends StatefulWidget {
  const CartScreen2({Key? key}) : super(key: key);

  @override
  State<CartScreen2> createState() => _CartScreen2State();
}

class _CartScreen2State extends State<CartScreen2> {
  int _count = 1;
  int _count1 = 1;
  int _count2 = 1;
  int _count3 = 1;
  void _increamentCounter() {
    setState(() {
      _count++;
    });
  }

  void _increamentCounter1() {
    setState(() {
      _count1++;
    });
  }

  void _increamentCounter2() {
    setState(() {
      _count2++;
    });
  }

  void _increamentCounter3() {
    setState(() {
      _count3++;
    });
  }

  void _decreamentCounter() {
    setState(() {
      _count--;
    });
  }

  void _decreamentCounter1() {
    setState(() {
      _count1--;
    });
  }

  void _decreamentCounter2() {
    setState(() {
      _count2--;
    });
  }

  void _decreamentCounter3() {
    setState(() {
      _count3--;
    });
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
          'Cart',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 32.w),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/delete_icon.png',
                  width: 22.w,
                  height: 27.h,
                ),
                SizedBox(
                  width: 17.w,
                ),
                Image.asset(
                  'assets/icons/list_icon.png',
                  width: 25.w,
                  height: 17.h,
                )
              ],
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 32.w),
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 26.h,
            ),
            Container(
              height: 90.h,
              width: 329.w,
              child: Card(
                color: kPrimaryGreen,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/burgur.png',
                      width: 91.w,
                      height: 74.h,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Beef Burger',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                            color: kWhite,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          'Espresso Cafe',
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: kWhite,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Text(
                              '\$33.00',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                                color: kWhite,
                              ),
                            ),
                            SizedBox(
                              width: 88.w,
                            ),
                            GestureDetector(
                              onTap: _decreamentCounter,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 2.h),
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.minimize,
                                      color: kPrimaryGreen,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              '$_count',
                              style: GoogleFonts.manrope(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                              onTap: _increamentCounter,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 2.h),
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: const Icon(
                                  Icons.add,
                                  color: kPrimaryGreen,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              height: 90.h,
              width: 329.w,
              child: Card(
                color: kWhite,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/burgur.png',
                      width: 91.w,
                      height: 74.h,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Beef Burger',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                            color: kSecondaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          'Espresso Cafe',
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: kSupportiveGrey,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Text(
                              '\$33.00',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                                color: kSecondaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 88.w,
                            ),
                            GestureDetector(
                              onTap: _decreamentCounter1,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 2.h),
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: kSupportiveGrey,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.minimize,
                                      color: kWhite,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              '$_count1',
                              style: GoogleFonts.manrope(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                              onTap: _increamentCounter1,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 2.h),
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: kSupportiveGrey,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: const Icon(
                                  Icons.add,
                                  color: kWhite,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              height: 90.h,
              width: 329.w,
              child: Card(
                color: kWhite,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/burgur.png',
                      width: 91.w,
                      height: 74.h,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Beef Burger',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                            color: kSecondaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          'Espresso Cafe',
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: kSupportiveGrey,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Text(
                              '\$33.00',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                                color: kSecondaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 88.w,
                            ),
                            GestureDetector(
                              onTap: _decreamentCounter2,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 2.h),
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: kSupportiveGrey,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.minimize,
                                      color: kWhite,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              '$_count2',
                              style: GoogleFonts.manrope(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                              onTap: _increamentCounter2,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 2.h),
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: kSupportiveGrey,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: const Icon(
                                  Icons.add,
                                  color: kWhite,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Container(
              height: 90.h,
              width: 329.w,
              child: Card(
                color: kPrimaryGreen,
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/burgur.png',
                      width: 91.w,
                      height: 74.h,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          'Beef Burger',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                            color: kWhite,
                          ),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        Text(
                          'Espresso Cafe',
                          style: GoogleFonts.manrope(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: kWhite,
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Row(
                          children: [
                            Text(
                              '\$33.00',
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontSize: 14.sp,
                                color: kWhite,
                              ),
                            ),
                            SizedBox(
                              width: 88.w,
                            ),
                            GestureDetector(
                              onTap: _decreamentCounter3,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 2.h),
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: Column(
                                  children: const [
                                    Icon(
                                      Icons.minimize,
                                      color: kPrimaryGreen,
                                      size: 10,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Text(
                              '$_count3',
                              style: GoogleFonts.manrope(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: kSecondaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            GestureDetector(
                              onTap: _increamentCounter3,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 2.h),
                                height: 18.h,
                                width: 15.w,
                                decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(25.r)),
                                child: const Icon(
                                  Icons.add,
                                  color: kPrimaryGreen,
                                  size: 10,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        height: 202.h,
        width: 390.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          boxShadow: [
            BoxShadow(
              color: kBG,
              spreadRadius: 20,
              blurRadius: 10,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 25.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '\$',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w800,
                        fontSize: 22.sp,
                        color: kSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  '62.00',
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    fontSize: 30.sp,
                    color: kSecondaryColor,
                  ),
                )
              ],
            ),
            Text(
              '2 Items',
              style: GoogleFonts.manrope(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: kSupportiveGrey,
              ),
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
                      Image.asset(
                        'assets/icons/cart_icon.png',
                        width: 25.w,
                        height: 26.h,
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Text(
                        'Check Out',
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
