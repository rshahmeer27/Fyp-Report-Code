// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/restaurantDetails.dart';
import 'package:skoop/screens/user/singleFoodItem.dart';
import 'package:skoop/toast.dart';

import '../../constant.dart';

class RestaurantMenu extends StatefulWidget {
  var restaurant;
  RestaurantMenu(this.restaurant);

  ///get category name
  @override
  State<RestaurantMenu> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  var imgg;
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

  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  Future<List<dynamic>> fetchFeaturedRestaurants() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url =
        Uri.parse('$port/getrestaurantdetails/${widget.restaurant['_id']}');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final featureData = json.decode(response.body);
      return featureData;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch restaurants');
    }
  }

  Future<void> addToFavourite() async {
    // final bytes = await imageFile.readAsBytes();
    // final base64Image = base64Encode(bytes);
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      final token = sp.getString('token').toString();
      final userId = sp.getString('id').toString();

      final url = Uri.parse('$port/set-favourite/${widget.restaurant['_id']}');
      // final body = {'rid': widget.restaurant['_id']};
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.patch(url, headers: headers);

      if (response.statusCode == 204) {
        showToastShort('Added to favourite successfully', kPrimaryGreen);
      } else {
        showToastShort('Request Failed. Error: ${response.body}', Colors.red);
      }
    } catch (e) {
      showToastShort('Error occurred: $e', Colors.red);
    }
  }

  getId() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    print('user id');
    print(sp.get('id'));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // fetchFeaturedRestaurants();
    getId();
    print('ridabc ');
    print(widget.restaurant['_id']);
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
              widget.restaurant['picture'] == ''
                  ? Container(
                      width: 390.w,
                      height: 289.h,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/rest1.png'),
                            fit: BoxFit.fill),
                      ),
                    )
                  : Container(
                      width: 390.w,
                      height: 289.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(stringToUint8List(
                                widget.restaurant['picture'])),
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
                      GestureDetector(
                        onTap: () {
                          addToFavourite();
                        },
                        child: Container(
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
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 250.h,
                child: Container(
                  height: MediaQuery.of(context).size.height,
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
                        Text(
                          'Open',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            fontSize: 10.sp,
                            color: kPrimaryGreen,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 28.w, right: 29.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // GestureDetector(
                              //   onTap: () {
                              //     // rateRestaurant(context);
                              //   },
                              //   child: Row(
                              //     children: [
                              //       Image.asset(
                              //         'assets/icons/star_icon.png',
                              //         width: 11.w,
                              //         height: 11.h,
                              //       ),
                              //       Text(
                              //         averageRating.toString() == 'NaN'
                              //             ? ' 0.0'
                              //             : ' ${averageRating.toString().substring(0, 3)}',
                              //         style: GoogleFonts.manrope(
                              //           fontSize: 12.sp,
                              //           fontWeight: FontWeight.w600,
                              //           color: !isDark
                              //               ? kSecondaryColor
                              //               : kSupportiveGrey,
                              //         ),
                              //       ),
                              //     ],
                              //   ),
                              // ),
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
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => RestaurantDetails(
                                              widget.restaurant)));
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Details',
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
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    RestaurantDetails(
                                                        widget.restaurant)));
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
                          height: MediaQuery.of(context).size.height,
                          child: FutureBuilder<List<dynamic>>(
                            future: fetchFeaturedRestaurants(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final restaurants = snapshot.data;

                                return ListView.builder(
                                  itemCount: restaurants!.length,
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final restaurantCategory =
                                        restaurants[index];
                                    // final restaurantsItems = snapshot.data;
                                    final restaurantCategoriesItems =
                                        restaurantCategory['data'];
                                    // print('restaurant item length');
                                    // print(restaurantCategoriesItems.length);
                                    return Column(
                                      children: [
                                        ///major categories
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 31.w, right: 33.w),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                restaurantCategory['title']
                                                    .toString()
                                                    .toUpperCase(),
                                                style: GoogleFonts.manrope(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w700,
                                                  color: !isDark
                                                      ? kSecondaryColor
                                                      : kWhite,
                                                ),
                                              ),
                                              // GestureDetector(
                                              //   onTap: () {
                                              //     Navigator.push(context, MaterialPageRoute(builder: (_) => const SeeAllItemScreen()));
                                              //   },
                                              //   child: Text(
                                              //     'See all',
                                              //     style: GoogleFonts.manrope(
                                              //       fontWeight: FontWeight.w500,
                                              //       fontSize: 14.sp,
                                              //       color: kSupportiveGrey2,
                                              //     ),
                                              //   ),
                                              // )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),

                                        ///for categories items
                                        SizedBox(
                                          height: 192.h,
                                          child: ListView.builder(
                                            itemCount: restaurantCategoriesItems
                                                .length,
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemBuilder: (context, index1) {
                                              final restaurantsItems =
                                                  snapshot.data;
                                              final restaurantData =
                                                  restaurantsItems![index]
                                                      ['data'];
                                              // print('index1');
                                              // print(index1);
                                              imgg = stringToUint8List(
                                                  restaurantData[index1]
                                                      ['image']);
                                              return restaurantCategoriesItems
                                                          .length ==
                                                      0
                                                  ? Text(
                                                      'No items for now',
                                                      style: TextStyle(
                                                          color: !isDark
                                                              ? kDarkBG
                                                              : kWhite),
                                                    )
                                                  : Row(
                                                      children: [
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            print(
                                                                restaurantData[
                                                                        index1]
                                                                    ['_id']);
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (_) =>
                                                                        SingleFoodItem(restaurantData[index1]
                                                                            [
                                                                            '_id'])));
                                                          },
                                                          child: SizedBox(
                                                            height: 192.h,
                                                            width: 147.w,
                                                            child: Card(
                                                              elevation: 2,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10.r)),
                                                              color: !isDark
                                                                  ? kWhite
                                                                  : kcardColor,
                                                              child: Column(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 4.h,
                                                                  ),
                                                                  ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0),
                                                                    child: Image
                                                                        .memory(
                                                                      imgg,
                                                                      width:
                                                                          145.w,
                                                                      height:
                                                                          100.h,
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 8.h,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20.w),
                                                                        child:
                                                                            Text(
                                                                          restaurantData[index1]
                                                                              [
                                                                              'name'],
                                                                          style:
                                                                              GoogleFonts.manrope(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            color: !isDark
                                                                                ? kSupportiveGrey
                                                                                : kWhite,
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
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20.w),
                                                                        child: widget.restaurant['restaurant_name'] ==
                                                                                ''
                                                                            ? Text(
                                                                                'Restaurant',
                                                                                style: GoogleFonts.manrope(
                                                                                  fontSize: 9.sp,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: !isDark ? kSupportiveGrey : kWhite,
                                                                                ),
                                                                              )
                                                                            : Text(
                                                                                widget.restaurant['restaurant_name'] ?? 'Restaurant',
                                                                                style: GoogleFonts.manrope(
                                                                                  fontSize: 9.sp,
                                                                                  fontWeight: FontWeight.w500,
                                                                                  color: !isDark ? kSecondaryColor : kWhite,
                                                                                ),
                                                                              ),
                                                                        //     Text(
                                                                        //   restaurant[
                                                                        //       'name'],
                                                                        //   style:
                                                                        //       GoogleFonts.manrope(
                                                                        //     fontSize:
                                                                        //         9.sp,
                                                                        //     fontWeight:
                                                                        //         FontWeight.w500,
                                                                        //     color:
                                                                        //         kSupportiveGrey,
                                                                        //   ),
                                                                        // ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                    height:
                                                                        11.h,
                                                                  ),
                                                                  Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                20.w),
                                                                        child:
                                                                            Text(
                                                                          '\$ ${restaurantData[index1]['price']}',
                                                                          style:
                                                                              GoogleFonts.manrope(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight:
                                                                                FontWeight.w800,
                                                                            color: !isDark
                                                                                ? kSecondaryColor
                                                                                : kPrimaryGreen,
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
                                                        const SizedBox(
                                                          width: 20,
                                                        ),
                                                      ],
                                                    );
                                            },
                                          ),
                                        ),

                                        SizedBox(
                                          height: 10.h,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return const Center(
                                  child: Text('Failed to fetch restaurants'),
                                );
                              }

                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 31.w, right: 33.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Burgers',
                        //         style: GoogleFonts.manrope(
                        //           fontSize: 20.sp,
                        //           fontWeight: FontWeight.w700,
                        //           color:
                        //               !isDark ? kSecondaryColor : kSupportiveGrey,
                        //         ),
                        //       ),
                        //       Text(
                        //         'See all',
                        //         style: GoogleFonts.manrope(
                        //           fontWeight: FontWeight.w500,
                        //           fontSize: 14.sp,
                        //           color: kSupportiveGrey2,
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 14.h,
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 32.w, right: 32.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       GestureDetector(
                        //         onTap: () {
                        //           Navigator.push(
                        //               context,
                        //               MaterialPageRoute(
                        //                   builder: (_) => const OrderDetails()));
                        //         },
                        //         child: SizedBox(
                        //           height: 192.h,
                        //           width: 147.w,
                        //           child: Card(
                        //             elevation: 5,
                        //             shape: RoundedRectangleBorder(
                        //                 borderRadius:
                        //                     BorderRadius.circular(10.r)),
                        //             child: Column(
                        //               children: [
                        //                 SizedBox(
                        //                   height: 4.h,
                        //                 ),
                        //                 Image.asset(
                        //                   'assets/images/burger.png',
                        //                   width: 145.w,
                        //                   height: 100.h,
                        //                 ),
                        //                 SizedBox(
                        //                   height: 8.h,
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Container(
                        //                       margin: EdgeInsets.only(left: 20.w),
                        //                       child: Text(
                        //                         'Beef Burger',
                        //                         style: GoogleFonts.manrope(
                        //                           fontSize: 14.sp,
                        //                           fontWeight: FontWeight.w600,
                        //                           color: kSecondaryColor,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 5.h,
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Container(
                        //                       margin: EdgeInsets.only(left: 20.w),
                        //                       child: Text(
                        //                         'McDonalds',
                        //                         style: GoogleFonts.manrope(
                        //                           fontSize: 9.sp,
                        //                           fontWeight: FontWeight.w500,
                        //                           color: kSupportiveGrey,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //                 SizedBox(
                        //                   height: 11.h,
                        //                 ),
                        //                 Row(
                        //                   children: [
                        //                     Container(
                        //                       margin: EdgeInsets.only(left: 20.w),
                        //                       child: Text(
                        //                         '\$ 33.00',
                        //                         style: GoogleFonts.manrope(
                        //                           fontSize: 14.sp,
                        //                           fontWeight: FontWeight.w800,
                        //                           color: kSecondaryColor,
                        //                         ),
                        //                       ),
                        //                     ),
                        //                   ],
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 192.h,
                        //         width: 147.w,
                        //         child: Card(
                        //           elevation: 5,
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10.r)),
                        //           child: Column(
                        //             children: [
                        //               SizedBox(
                        //                 height: 4.h,
                        //               ),
                        //               Image.asset(
                        //                 'assets/images/burger.png',
                        //                 width: 145.w,
                        //                 height: 100.h,
                        //               ),
                        //               SizedBox(
                        //                 height: 8.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       'Beef Burger',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.w600,
                        //                         color: kSecondaryColor,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 height: 5.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       'McDonalds',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 9.sp,
                        //                         fontWeight: FontWeight.w500,
                        //                         color: kSupportiveGrey,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 height: 11.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       '\$ 33.00',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.w800,
                        //                         color: kSecondaryColor,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 20.h,
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 31.w, right: 33.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text(
                        //         'Pasta',
                        //         style: GoogleFonts.manrope(
                        //           fontSize: 20.sp,
                        //           fontWeight: FontWeight.w700,
                        //           color:
                        //               !isDark ? kSecondaryColor : kSupportiveGrey,
                        //         ),
                        //       ),
                        //       Text(
                        //         'See all',
                        //         style: GoogleFonts.manrope(
                        //           fontWeight: FontWeight.w500,
                        //           fontSize: 14.sp,
                        //           color: const Color(0xffB6B2B2),
                        //         ),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 14.h,
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(left: 32.w, right: 32.w),
                        //   child: Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       SizedBox(
                        //         height: 192.h,
                        //         width: 147.w,
                        //         child: Card(
                        //           elevation: 5,
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10.r)),
                        //           child: Column(
                        //             children: [
                        //               SizedBox(
                        //                 height: 4.h,
                        //               ),
                        //               Image.asset(
                        //                 'assets/images/burger.png',
                        //                 width: 145.w,
                        //                 height: 100.h,
                        //               ),
                        //               SizedBox(
                        //                 height: 8.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       'Beef Burger',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.w600,
                        //                         color: kSecondaryColor,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 height: 5.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       'McDonalds',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 9.sp,
                        //                         fontWeight: FontWeight.w500,
                        //                         color: kSupportiveGrey,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 height: 11.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       '\$ 33.00',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.w800,
                        //                         color: kSecondaryColor,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //       SizedBox(
                        //         height: 192.h,
                        //         width: 147.w,
                        //         child: Card(
                        //           elevation: 5,
                        //           shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10.r)),
                        //           child: Column(
                        //             children: [
                        //               SizedBox(
                        //                 height: 4.h,
                        //               ),
                        //               Image.asset(
                        //                 'assets/images/burgur.png',
                        //                 width: 145.w,
                        //                 height: 100.h,
                        //               ),
                        //               SizedBox(
                        //                 height: 8.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       'Beef Burger',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.w600,
                        //                         color: kSecondaryColor,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 height: 5.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       'McDonalds',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 9.sp,
                        //                         fontWeight: FontWeight.w500,
                        //                         color: kSupportiveGrey,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //               SizedBox(
                        //                 height: 11.h,
                        //               ),
                        //               Row(
                        //                 children: [
                        //                   Container(
                        //                     margin: EdgeInsets.only(left: 20.w),
                        //                     child: Text(
                        //                       '\$ 33.00',
                        //                       style: GoogleFonts.manrope(
                        //                         fontSize: 14.sp,
                        //                         fontWeight: FontWeight.w800,
                        //                         color: kSecondaryColor,
                        //                       ),
                        //                     ),
                        //                   ),
                        //                 ],
                        //               ),
                        //             ],
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        SizedBox(
                          height: 400.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
