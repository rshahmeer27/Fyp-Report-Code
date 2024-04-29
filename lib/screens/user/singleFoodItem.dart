// ignore_for_file: must_be_immutable, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/toast.dart';

import '../../constant.dart';

class SingleFoodItem extends StatefulWidget {
  var foodId;
  SingleFoodItem(this.foodId);

  @override
  State<SingleFoodItem> createState() => _SingleFoodItemState();
}

class _SingleFoodItemState extends State<SingleFoodItem> {
  List<Map<String, dynamic>> globalItemDetails = [];
  // Function to initialize the globalItemDetails list from shared preferences
  Future<void> initializeItemDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItemList = prefs.getStringList('itemListCartA');
    if (encodedItemList != null) {
      globalItemDetails = encodedItemList
          .map((item) => json.decode(item) as Map<String, dynamic>)
          .toList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initializeItemDetails();
    print('widget.foodId');
    print(widget.foodId);
  }

  var item, categoryInfo;
  var catName;
  Future<dynamic> getItem() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    var id = sp.getString('id').toString();
    print('id');
    print(id);
    final url = Uri.parse('$port/get-singlefooditem/${widget.foodId}');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      item = userData;
      catName = await getCategory(item['food_category']);
      print('item');
      print(item);
      return item;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
    }
  }

  Future<dynamic> getCategory(var categoryId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    var id = sp.getString('id').toString();
    final url = Uri.parse('$port/get-singlefoodcategory/$categoryId');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      final categoryInfoA = userData;
      // imgg = stringToUint8List(user['customer']['picture']);
      print('title name category');
      print(categoryInfoA['title']);
      // Return the user object
      catName = categoryInfoA['title'];
      return categoryInfoA['title'];
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
    }
  }

  var imgg;

  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  int count = 1;
  increaseIt() {
    setState(() {
      count++;
    });
  }

  decreaseIt() {
    setState(() {
      count--;
    });
  }

  // List<Map<String, dynamic>> itemDetails = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? kDarkBG : kBG,
        body: FutureBuilder(
          future: getItem(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              imgg = stringToUint8List(snapshot.data['image']);
              if (item != null &&
                  globalItemDetails
                      .every((element) => element['_id'] != item['_id'])) {
                globalItemDetails.add({
                  '_id': snapshot.data['_id'],
                  'name': snapshot.data['name'],
                  'price': snapshot.data['price'],
                  'ingredient': snapshot.data['ingredient'],
                  'quantity': count,
                  'description': snapshot.data['description'],
                  'food_category': snapshot.data['food_category'],
                  'image': snapshot.data['image'],
                });
              }
              // itemDetails.add({
              //   '_id': snapshot.data['_id'],
              //   'name': snapshot.data['name'],
              //   'price': snapshot.data['price'],
              //   'ingredient': snapshot.data['ingredient'],
              //   'description': snapshot.data['description'],
              //   'food_category': snapshot.data['food_category'],
              //   // 'image': snapshot.data['image'],
              // });
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  children: [
                    Container(
                      width: 390.w,
                      height: 289.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: MemoryImage(imgg), fit: BoxFit.fill),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 24.w, right: 24.w, top: 21.h),
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
                                height: 18.h,
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: 28.w, right: 29.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      snapshot.data?['name'],
                                      style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 20.sp,
                                        color: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                catName!.toString(),
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                  color: kSupportiveGrey,
                                ),
                              ),
                              SizedBox(
                                height: 32.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Container(
                                    width: 94.w,
                                    height: 29.h,
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\$',
                                          style: GoogleFonts.manrope(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w700,
                                            color: kPrimaryGreen,
                                          ),
                                        ),
                                        Text(
                                          ' ${snapshot.data['price'].toString()}',
                                          style: GoogleFonts.manrope(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: kSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   width: 94.w,
                                  //   height: 29.h,
                                  //   decoration: BoxDecoration(
                                  //     color: kWhite,
                                  //     borderRadius: BorderRadius.circular(50.r),
                                  //   ),
                                  //   child: Row(
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: [
                                  //       Image.asset(
                                  //         'assets/icons/star_icon.png',
                                  //         width: 11.w,
                                  //         height: 11.h,
                                  //       ),
                                  //       Text(
                                  //         ' 4.9',
                                  //         style: GoogleFonts.manrope(
                                  //           fontSize: 12.sp,
                                  //           fontWeight: FontWeight.w600,
                                  //           color: kSecondaryColor,
                                  //         ),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  Container(
                                    width: 94.w,
                                    height: 29.h,
                                    decoration: BoxDecoration(
                                      color: kWhite,
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                          'assets/icons/time_icon.png',
                                          width: 11.w,
                                          height: 11.h,
                                        ),
                                        Text(
                                          ' 20',
                                          style: GoogleFonts.manrope(
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600,
                                            color: kSecondaryColor,
                                          ),
                                        ),
                                        Text(
                                          ' min',
                                          style: GoogleFonts.manrope(
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.w600,
                                            color: kSecondaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 33.h,
                              ),
                              Container(
                                margin:
                                    EdgeInsets.only(left: 32.w, right: 32.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Description',
                                      style: GoogleFonts.manrope(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                      ),
                                    ),
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
                                        text: snapshot.data?['description'],
                                        style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13.sp,
                                            color: kSecondaryColor),
                                        children: [
                                          // TextSpan(
                                          //     text: ' Read More ',
                                          //     style: GoogleFonts.manrope(
                                          //         fontWeight: FontWeight.w600,
                                          //         fontSize: 13.sp,
                                          //         color: kPrimaryGreen)),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              SizedBox(
                                height: 33.h,
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(left: 32.w, right: 32.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Quantity',
                                      style: GoogleFonts.manrope(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.w700,
                                        color: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                      ),
                                    ),
                                    Container(
                                      height: 27.h,
                                      width: 91.w,
                                      decoration: BoxDecoration(
                                          color: kSecondaryColor,
                                          borderRadius:
                                              BorderRadius.circular(50.r)),
                                      child: Center(
                                        child: Row(
                                          // crossAxisAlignment: CrossAxisAlignment.start,
                                          // mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              width: 2,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                decreaseIt();
                                              },
                                              child: CircleAvatar(
                                                radius: 13.r,
                                                backgroundColor: kWhite,
                                                child: Center(
                                                  child: Text(
                                                    '-',
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: kSecondaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            Text(
                                              count.toString(),
                                              style: GoogleFonts.manrope(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500,
                                                color: kWhite,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.w,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                increaseIt();
                                              },
                                              child: CircleAvatar(
                                                radius: 13.r,
                                                backgroundColor: kWhite,
                                                child: Center(
                                                  child: Text(
                                                    '+',
                                                    style: GoogleFonts.manrope(
                                                      fontSize: 18.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: kSecondaryColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 55.h,
                              ),
                              Container(
                                height: 202.h,
                                width: 390.w,
                                decoration: BoxDecoration(
                                  color: isDark ? kDarkBg : kBG,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: 25.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              '\$',
                                              style: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w800,
                                                fontSize: 22.sp,
                                                color: !isDark
                                                    ? kSecondaryColor
                                                    : kSupportiveGrey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          getPrice(
                                                  count, snapshot.data['price'])
                                              .toString(),
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 30.sp,
                                            color: !isDark
                                                ? kSecondaryColor
                                                : kSupportiveGrey,
                                          ),
                                        )
                                      ],
                                    ),
                                    // Text(
                                    //   '2 Items',
                                    //   style: GoogleFonts.manrope(
                                    //     fontSize: 15.sp,
                                    //     fontWeight: FontWeight.w600,
                                    //     color: kSupportiveGrey,
                                    //   ),
                                    // ),
                                    GestureDetector(
                                        child: Container(
                                          width: 326.w,
                                          height: 50.h,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            color: kPrimaryGreen,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                'Add to cart',
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
                                          saveItemList().whenComplete(() {
                                            showToastShort(
                                                'Added to cart', kPrimaryGreen);
                                            Navigator.pop(context);
                                          });
                                        }),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              ),

                              // SizedBox(
                              //   height: 33.h,
                              // ),
                            ],
                          ),
                        ),
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
        // bottomSheet: Container(
        //   height: 202.h,
        //   width: 390.w,
        //   decoration: BoxDecoration(
        //     color: isDark ? kDarkBg : kBG,
        //     borderRadius: BorderRadius.only(
        //       topLeft: Radius.circular(30.r),
        //       topRight: Radius.circular(30.r),
        //     ),
        //     // boxShadow: const [
        //     //   BoxShadow(
        //     //     color: kBG,
        //     //     spreadRadius: 20,
        //     //     blurRadius: 10,
        //     //     offset: Offset(0, 0), // changes position of shadow
        //     //   ),
        //     // ],
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
        //                   color: !isDark ? kSecondaryColor : kSupportiveGrey,
        //                 ),
        //               ),
        //             ],
        //           ),
        //           Text(
        //             getPrice(count, snapshot.data['price'].toString())
        //                 .toString(),
        //             style: GoogleFonts.manrope(
        //               fontWeight: FontWeight.w800,
        //               fontSize: 30.sp,
        //               color: !isDark ? kSecondaryColor : kSupportiveGrey,
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
        //                   'Add to cart',
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
        //             saveItemList().whenComplete(() {
        //               showToastShort('Added to cart', kPrimaryGreen);
        //               Navigator.pop(context);
        //             });
        //           }),
        //       SizedBox(
        //         height: 20.h,
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }

  // Future<void> saveItemList(List<Map<String, dynamic>> itemList) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final encodedItemList = itemList.map((item) => json.encode(item)).toList();
  //   await prefs.setStringList('itemList5', encodedItemList);
  //   print('encodedItemList');
  //   print(encodedItemList);
  //   print('itemList1 sp value');
  //   print(prefs.getStringList('itemList5'));
  // }
  double getPrice(int quantity, int price) {
    double totalPrice = 0.0;
    // setState(() {
    totalPrice =
        double.parse(quantity.toString()) * double.parse(price.toString());
    // });
    return totalPrice;
  }

  Future<void> saveItemList() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItemList =
        globalItemDetails.map((item) => json.encode(item)).toList();
    await prefs.setStringList('itemListCartA', encodedItemList);
    print('encodedItemList');
    print(encodedItemList);
    print('itemList1 sp value');
    print(prefs.getStringList('itemListCartA'));
  }
}
