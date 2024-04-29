// ignore_for_file: depend_on_referenced_packages
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/singleFoodItem.dart';

import '../../../constant.dart';
import '../restrauntMenu.dart';

class SearchScreenHome extends StatefulWidget {
  const SearchScreenHome({Key? key}) : super(key: key);

  @override
  State<SearchScreenHome> createState() => _SearchScreenHomeState();
}

class _SearchScreenHomeState extends State<SearchScreenHome>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _restaurants = [];
  List<Map<String, dynamic>> _foodItems = [];
  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  void _searchRestaurants(var query) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/searchrestaurant?name=$query');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);
    // final response = await http.get(
    //   Uri.parse('$port/searchrestaurant?name=$query'),
    // );

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        _restaurants = List<Map<String, dynamic>>.from(responseData);
      });
    }
  }

  void _searchFoodItem(var query) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/searchfooditem?name=$query');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        _foodItems = List<Map<String, dynamic>>.from(responseData);
        print('_foodItems');
        print(_foodItems);
      });
    } else {
      print('error');
      print(response.statusCode);
    }
  }

  late TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

// var imgg;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: isDark ? kDarkBg : kBG,
          body: Container(
            color: kBG,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50.0),
                Center(
                  child: Container(
                    height: 45,
                    width: 327,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.r)),
                    child: TextFormField(
                      onChanged: (val) {
                        if (_tabController.index == 0) {
                          _searchRestaurants(val);
                        } else if (_tabController.index == 1) {
                          _searchFoodItem(val);
                        }
                      },
                      controller: _searchController,
                      decoration: InputDecoration(
                        // suffixIcon: icon,
                        prefixIcon: Image.asset(
                          'assets/icons/search.png',
                          scale: 1.8,
                        ),
                        fillColor: !isDark ? kWhite : const Color(0xff2A2C36),
                        filled: true,
                        hintText: 'Search',
                        hintStyle: kFieldStyle,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(26.r),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TabBar(
                    controller: _tabController,
                    unselectedLabelStyle: GoogleFonts.manrope(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: kSupportiveGrey,
                    ),
                    unselectedLabelColor: kSupportiveGrey,
                    indicatorSize: TabBarIndicatorSize.label,
                    tabs: [
                      Tab(
                        child: Text(
                          'Restaurants',
                          style: GoogleFonts.manrope(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: !isDark ? kSecondaryColor : kSupportiveGrey,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Foods',
                          style: GoogleFonts.manrope(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: !isDark ? kSecondaryColor : kSupportiveGrey,
                          ),
                        ),
                      ),
                    ]),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      ///restaurants
                      Container(
                        color: kBG,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _restaurants.length,
                                itemBuilder: (context, index) {
                                  final img = stringToUint8List(
                                      _restaurants[index]['picture']);
                                  final restaurantData = _restaurants[index];
                                  List<dynamic> opening =
                                      restaurantData['opening_hours'];
                                  // imgg = stringToUint8List(restaurantData['picture']);
                                  List<dynamic> reviews =
                                      restaurantData['reviews'];
                                  double totalStars = 0;
                                  for (var review in reviews) {
                                    totalStars += review['stars'];
                                  }
                                  double averageRating =
                                      totalStars / reviews.length;

                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      RestaurantMenu(
                                                          _restaurants[
                                                              index])));
                                        },
                                        child: Container(
                                          height: 90,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          decoration: BoxDecoration(
                                            color: kWhite,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              _restaurants[index]['picture'] ==
                                                      ''
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.asset(
                                                        'assets/images/f1.png',
                                                        width: 91,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.memory(
                                                        img,
                                                        width: 91,
                                                      ),
                                                    ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _restaurants[index]
                                                          ['restaurant_name'],
                                                      style: GoogleFonts.manrope(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              kSecondaryColor),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    opening.isEmpty
                                                        ? Text(
                                                            'Opens until 11:00 PM',
                                                            style: GoogleFonts.manrope(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    kSupportiveGrey),
                                                          )
                                                        : Text(
                                                            'Opens until ${opening[0]['timeEnd']}',
                                                            style: GoogleFonts.manrope(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    kSupportiveGrey),
                                                          ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      // crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Image.asset(
                                                          'assets/icons/stars.png',
                                                          scale: 1.5,
                                                        ),
                                                        const SizedBox(
                                                          width: 5.0,
                                                        ),
                                                        Text.rich(
                                                          TextSpan(
                                                            text: averageRating
                                                                        .toString() ==
                                                                    'NaN'
                                                                ? '0.0'
                                                                : averageRating
                                                                    .toString()
                                                                    .substring(
                                                                        0, 3),
                                                            style: GoogleFonts.manrope(
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color:
                                                                    kSecondaryColor), // default text style
                                                            children: [
                                                              TextSpan(
                                                                text:
                                                                    '(${reviews.length.toString()} Reviews)',
                                                                style: GoogleFonts.manrope(
                                                                    fontSize:
                                                                        10.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color:
                                                                        kSecondaryColor),
                                                              ),
                                                            ],
                                                          ),
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
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///foodItems
                      Container(
                        color: kBG,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: _foodItems.length,
                                itemBuilder: (context, index) {
                                  final img = stringToUint8List(
                                      _foodItems[index]['image']);
                                  print('_foodItems[index]');
                                  print(_foodItems[index]);
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      SingleFoodItem(
                                                          _foodItems[index]
                                                              ['_id'])));
                                        },
                                        child: Container(
                                          height: 90,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.85,
                                          decoration: BoxDecoration(
                                            color: kWhite,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              _foodItems[index]['image'] == ''
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.asset(
                                                        'assets/images/f1.png',
                                                        width: 91,
                                                      ),
                                                    )
                                                  : ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      child: Image.memory(
                                                        img,
                                                        width: 91,
                                                      ),
                                                    ),
                                              const SizedBox(
                                                width: 10.0,
                                              ),
                                              Container(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      _foodItems[index]['name'],
                                                      style: GoogleFonts.manrope(
                                                          fontSize: 16.sp,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color:
                                                              kSecondaryColor),
                                                    ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    _foodItems[index][
                                                                    'ingredient']
                                                                .toString()
                                                                .length >
                                                            15
                                                        ? Text(
                                                            '${_foodItems[index]['ingredient'].toString().substring(0, 13)}...',
                                                            style: GoogleFonts.manrope(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    kSupportiveGrey),
                                                          )
                                                        : Text(
                                                            _foodItems[index][
                                                                    'ingredient']
                                                                .toString(),
                                                            style: GoogleFonts.manrope(
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    kSupportiveGrey),
                                                          ),
                                                    const SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    // Row(
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment
                                                    //           .center,
                                                    //   // crossAxisAlignment: CrossAxisAlignment.center,
                                                    //   children: [
                                                    //     Image.asset(
                                                    //       'assets/icons/stars.png',
                                                    //       scale: 1.5,
                                                    //     ),
                                                    //     const SizedBox(
                                                    //       width: 5.0,
                                                    //     ),
                                                    //     Text.rich(
                                                    //       TextSpan(
                                                    //         text: '4.9',
                                                    //         style: GoogleFonts.manrope(
                                                    //             fontSize: 14.sp,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w800,
                                                    //             color:
                                                    //                 kSecondaryColor), // default text style
                                                    //         children: [
                                                    //           TextSpan(
                                                    //             text:
                                                    //                 '(13k Reviews)',
                                                    //             style: GoogleFonts.manrope(
                                                    //                 fontSize:
                                                    //                     10.sp,
                                                    //                 fontWeight:
                                                    //                     FontWeight
                                                    //                         .w600,
                                                    //                 color:
                                                    //                     kSecondaryColor),
                                                    //           ),
                                                    //         ],
                                                    //       ),
                                                    //     )
                                                    //   ],
                                                    // ),
                                                    Text.rich(
                                                      TextSpan(
                                                        text:
                                                            '\$ ${_foodItems[index]['price']}',
                                                        style: GoogleFonts.manrope(
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color:
                                                                kSecondaryColor), // default text style
                                                        // children: [
                                                        //   TextSpan(
                                                        //     text: '(13k Reviews)',
                                                        //     style: GoogleFonts.manrope(
                                                        //         fontSize: 10.sp,
                                                        //         fontWeight:
                                                        //             FontWeight.w600,
                                                        //         color: kSecondaryColor),
                                                        //   ),
                                                        // ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
