// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables, depend_on_referenced_packages

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';

class RestaurantDetails extends StatefulWidget {
  var restaurant;
  RestaurantDetails(this.restaurant, {super.key});

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

class _RestaurantDetailsState extends State<RestaurantDetails> {
  double averageRating = 0.0;
  List<dynamic> reviews = [];
  getRating() {
    reviews = widget.restaurant['reviews'];
    double totalStars = 0;
    for (var review in reviews) {
      totalStars += review['stars'];
    }
    averageRating = totalStars / reviews.length;

    print('Average Rating: $averageRating');
  }

  getCustomerById(String userId) async {
    final url = Uri.parse('$port/getcustomer/$userId');

    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> customerData = json.decode(response.body);
      username = customerData['full_name'];
      return customerData['full_name'];
    } else {
      throw Exception('Failed to load customer data');
    }
  }

  var username;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRating();
  }

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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Image.asset(
                              'assets/icons/back_icon.png',
                              width: 7.w,
                              height: 14.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   width: 37.w,
                    //   height: 37.h,
                    //   decoration: BoxDecoration(
                    //     color: kWhite,
                    //     borderRadius: BorderRadius.circular(24.r),
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Image.asset(
                    //         'assets/icons/heart1.png',
                    //         width: 20.w,
                    //         height: 18.h,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 250.h,
              child: Container(
                height: 500.h,
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
                      // Text(
                      //   'Open',
                      //   style: GoogleFonts.manrope(
                      //     fontWeight: FontWeight.w600,
                      //     fontSize: 10.sp,
                      //     color: kPrimaryGreen,
                      //   ),
                      // ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 28.w, right: 29.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // rateRestaurant(context);
                              },
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/icons/star_icon.png',
                                    width: 11.w,
                                    height: 11.h,
                                  ),
                                  Text(
                                    averageRating.toString() == 'NaN'
                                        ? ' 0.0'
                                        : ' ${averageRating.toString().substring(0, 3)}',
                                    style: GoogleFonts.manrope(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: !isDark
                                          ? kSecondaryColor
                                          : kSupportiveGrey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            widget.restaurant['restaurant_name'] == ''
                                ? Text(
                                    'Restaurant',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.sp,
                                      color: !isDark
                                          ? kSecondaryColor
                                          : kSupportiveGrey,
                                    ),
                                  )
                                : Text(
                                    widget.restaurant['restaurant_name'] ??
                                        'Restaurant',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20.sp,
                                      color: !isDark
                                          ? kSecondaryColor
                                          : kSupportiveGrey,
                                    ),
                                  ),
                            // Text(
                            //   'McDonalds',
                            //   style: GoogleFonts.manrope(
                            //     fontWeight: FontWeight.w800,
                            //     fontSize: 20.sp,
                            //     color:
                            //         !isDark ? kSecondaryColor : kSupportiveGrey,
                            //   ),
                            // ),
                            GestureDetector(
                              onTap: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (_) => RestaurantDetails(
                                //             widget.restaurant)));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    '',
                                    style: GoogleFonts.manrope(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.w600,
                                      color: !isDark
                                          ? kSecondaryColor
                                          : kSupportiveGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  GestureDetector(
                                    // onTap: (){
                                    onTap: () {
                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (_) => RestaurantDetails(
                                      //             widget.restaurant)));
                                    },
                                    // },
                                    child: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: const Color(0xff2A353D),
                                      size: 9.w,
                                    ),
                                  )
                                ],
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
                        height: 24.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 32.w, right: 32.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Description',
                              style: GoogleFonts.manrope(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.w700,
                                color:
                                    !isDark ? kSecondaryColor : kSupportiveGrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 32.w, right: 32.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text:
                                    widget.restaurant['description'].toString(),
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                    color: kSecondaryColor),
                                children: [
                                  TextSpan(
                                      text: '',
                                      style: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 13.sp,
                                          color: kPrimaryGreen)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 31.w, right: 33.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Rating & Reviews ',
                                style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: !isDark
                                        ? kSecondaryColor
                                        : kSupportiveGrey),
                                children: [
                                  TextSpan(
                                    text: ' (${reviews.length.toString()})',
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20.sp,
                                        color: kSupportiveGrey),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      SizedBox(
                        height: 300,
                        child: ListView.builder(
                          itemCount: reviews.length,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            final restaurant = reviews[index];
                            return Column(
                              children: [
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 32.w, right: 32.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      FutureBuilder<dynamic>(
                                        future: getCustomerById(
                                            restaurant['customer']),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const CircularProgressIndicator(); // You can show a loading indicator
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else {
                                            return Text(
                                              username.toString(),
                                              style: GoogleFonts.manrope(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w700,
                                                color: kSupportiveGrey,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                      RatingStars(restaurant['stars'])
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 6.h,
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(left: 32.w, right: 32.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text.rich(
                                        TextSpan(
                                          text: restaurant['message'],
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 13.sp,
                                              color: kSecondaryColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 22.h,
                                ),
                              ],
                            );
                          },
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

class RatingStars extends StatelessWidget {
  final int rating;

  const RatingStars(this.rating, {super.key});
  @override
  Widget build(BuildContext context) {
    List<Widget> starWidgets = [];

    // Generate yellow stars
    for (int i = 0; i < rating; i++) {
      starWidgets.add(const Icon(
        Icons.star,
        color: kPrimaryGreen,
        size: 12,
      ));
    }

    // Generate grey stars
    for (int i = rating; i < 5; i++) {
      starWidgets.add(const Icon(
        Icons.star_border_outlined,
        color: kPrimaryGreen,
        size: 12,
      ));
    }

    return Row(children: starWidgets);
  }
}
