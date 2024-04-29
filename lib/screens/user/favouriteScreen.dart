// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/restrauntMenu.dart';
import 'package:skoop/screens/user/singleFoodItem.dart';

import '../../constant.dart';
import '../../toast.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({Key? key}) : super(key: key);

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  bool isSelected = false;
  var foodIde;
  int? selectedIndex;
  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  void deleteFoodItem(var foodId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString('token').toString();
    // final id = sp.getString('id').toString();
    print('foodId');
    print(foodId);
    final url = Uri.parse('$port/remove-favourite/$foodId');
    final headers = {'Authorization': 'Bearer $token'};
    // final body = {'restaurant': id};
    final response = await http.patch(url, headers: headers);
    if (response.statusCode == 204) {
      // Parse the response body to extract the user data
      final featureData = json.decode(response.body);

      showToastShort('Restaurant Removed', Colors.red);
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch favourite restaurants');
    }
  }

  Future<void> deleteItem(var foodId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Restaurant',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                  'Are you sure you want to delete this restaurant',
                  textAlign: TextAlign.center,
                ),
                // Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes',
                style: kAppbarStyle.copyWith(color: Colors.red),
              ),
              onPressed: () {
                // Navigator.of(context).pop();
                deleteFoodItem(foodId);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'No',
                style: kAppbarStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBG,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: !isDark ? kSecondaryColor : kSupportiveGrey,
              ),
              // Within the `FirstRoute` widget
              onPressed: () {
                // Navigator.pop(context);
              }),
          title: Row(
            children: [
              SizedBox(
                width: 80.w,
              ),
              Text(
                'Favourite',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 22.sp,
                  color: !isDark ? kSecondaryColor : kSupportiveGrey,
                ),
              ),
            ],
          ),
          actions: [
            isSelected
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            deleteItem(foodIde);
                          },
                          child: Image.asset(
                            'assets/icons/delete_icon.png',
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(),
          ],
        ),
        body: Container(
          color: kBG,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TabBar(
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
                        'Favorites',
                        style: GoogleFonts.manrope(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w800,
                          color: !isDark ? kSecondaryColor : kSupportiveGrey,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Quick Orders',
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
                  children: [
                    Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: FutureBuilder<List<dynamic>>(
                            future: fetchFeaturedRestaurants(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final favoriteRestaurant = snapshot.data;

                                return ListView.builder(
                                  itemCount: favoriteRestaurant!.length,
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final restaurant =
                                        favoriteRestaurant[index];
                                    List<dynamic> opening =
                                        restaurant['rid']['opening_hours'];
                                    print('opening');
                                    print(opening[0]['timeEnd']);
                                    List<dynamic> reviews =
                                        restaurant['rid']['reviews'];
                                    double totalStars = 0;
                                    for (var review in reviews) {
                                      totalStars += review['stars'];
                                    }
                                    double averageRating =
                                        totalStars / reviews.length;
                                    print('picture');
                                    final image = stringToUint8List(
                                        restaurant['rid']['picture']);
                                    return Column(
                                      children: [
                                        GestureDetector(
                                          // onLongPress: () {
                                          //   print('index');
                                          //   print(index);
                                          //
                                          //   if (isSelected) {
                                          //     setState(() {
                                          //       isSelected = false;
                                          //     });
                                          //   } else {
                                          //     setState(() {
                                          //       selectedIndex = index;
                                          //       isSelected = true;
                                          //       foodIde =
                                          //           restaurant['rid']['_id'];
                                          //       print('foodIde');
                                          //       print(foodIde);
                                          //     });
                                          //   }
                                          // },
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        RestaurantMenu(
                                                            restaurant[
                                                                'rid'])));
                                          },
                                          child: Container(
                                            height: 90,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            decoration: BoxDecoration(
                                              color:
                                                  !isDark ? kWhite : kcardColor,
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
                                                restaurant['rid']['picture'] ==
                                                        ''
                                                    ? Image.asset(
                                                        'assets/images/f1.png',
                                                        width: 91,
                                                      )
                                                    : ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                        child: Image.memory(
                                                          image,
                                                          width: 91,
                                                        )),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        // mainAxisAlignment:
                                                        //     MainAxisAlignment.spaceEvenly,
                                                        // crossAxisAlignment:
                                                        //     CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            restaurant['rid'][
                                                                    'restaurant_name'] ??
                                                                'Null',
                                                            style: GoogleFonts.manrope(
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w800,
                                                                color: !isDark
                                                                    ? kSecondaryColor
                                                                    : kWhite),
                                                          ),
                                                          // const SizedBox(
                                                          //   width: 20.0,
                                                          // ),
                                                          // Image.asset(
                                                          //   'assets/icons/heart.png',
                                                          //   width: 16,
                                                          // ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      Text(
                                                        'Opens until ${opening[0]['timeEnd']}',
                                                        style: GoogleFonts.manrope(
                                                            fontSize: 12.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: !isDark
                                                                ? kWhite
                                                                : kSupportiveGrey),
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
                                                          Icon(
                                                            Icons.star,
                                                            color: !isDark
                                                                ? kWhite
                                                                : kSecondaryColor,
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
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: !isDark
                                                                      ? kWhite
                                                                      : kSupportiveGrey), // default text style
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
                                                                      color: !isDark
                                                                          ? kWhite
                                                                          : kSupportiveGrey),
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
                      ],
                    ),
                    FavouriteRestaurantTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  var imgg;

  // Uint8List stringToUint8List(String input) {
  //   final decoded = base64.decode(input);
  //   return Uint8List.fromList(decoded);
  // }

  Future<List<dynamic>> fetchFeaturedRestaurants() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString('token').toString();

    final url = Uri.parse('$port/view-favouriterestaurants/');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final featureData = json.decode(response.body);
      // featuredRestaurant = featureData;
      print('featureData');
      print(featureData);
      return featureData['favourite'];
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch restaurants');
    }
  }
}

class FavouriteRestaurantTab extends StatefulWidget {
  const FavouriteRestaurantTab({Key? key}) : super(key: key);
  @override
  State<FavouriteRestaurantTab> createState() => _FavouriteRestaurantTabState();
}

class _FavouriteRestaurantTabState extends State<FavouriteRestaurantTab> {
  var imgg;
  List<Map<String, dynamic>> foodItemsList = [];
  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  Future<List<dynamic>> fetchFeaturedRestaurants() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString('token').toString();

    final url = Uri.parse('$port/view-favouriterestaurants/');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final featureData = json.decode(response.body);
      // featuredRestaurant = featureData;
      print('featureData');
      print(featureData);
      return featureData['favourite'];
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch restaurants');
    }
  }

  List<Map<String, dynamic>> quickFoodItemsList = [];
  Future<Map<String, dynamic>> getItem(var foodId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    // var id = sp.getString('id').toString();
    final url = Uri.parse('$port/get-singlefooditem/$foodId');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      return userData;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
    }
  }

  Future<List<Map<String, dynamic>>> getQuickOrders() async {
    quickFoodItemsList = [];
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/past-orders');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<Map<String, dynamic>> activeOrders =
          List<Map<String, dynamic>>.from(responseData['pastOrders']);
      //Added by sadaf
      for (int i = 0; i < activeOrders.length; i++) {
        final order = activeOrders[i];
        final foodItems = order['foodItems'] as List<dynamic>;
        final firstFoodItem = foodItems[0]['item'];
        quickFoodItemsList.add(await getItem(firstFoodItem));
        // print('===========length ${pastFoodItemsList.length}');
      }
      return activeOrders;
    } else {
      throw Exception('Failed to fetch active orders');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kBG,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            SingleChildScrollView(
              // scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ///featured body
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: FutureBuilder<List<Map<String, dynamic>>>(
                      future: getQuickOrders(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text('No orders available.'));
                        } else {
                          return quickFoodItemsList.isNotEmpty
                              ? ListView.builder(
                                  itemCount: quickFoodItemsList.length,
                                  itemBuilder: (context, index) {
                                    print('quickFoodItemsList');
                                    print(quickFoodItemsList);
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            print('snapshot.data![index]');
                                            print(snapshot.data![index]);
                                            print(snapshot.data![index]
                                                ['foodItems'][0]['item']);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => SingleFoodItem(
                                                  snapshot.data![index]
                                                      ['foodItems'][0]['item'],
                                                ),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            height: 90,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.85,
                                            decoration: BoxDecoration(
                                              color:
                                                  !isDark ? kWhite : kcardColor,
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
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  child: Image.memory(
                                                    stringToUint8List(
                                                        quickFoodItemsList[
                                                            index]["image"]),
                                                    width: 91,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10.0,
                                                ),
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        quickFoodItemsList[
                                                            index]['name'],
                                                        style: GoogleFonts.manrope(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            color: !isDark
                                                                ? kSecondaryColor
                                                                : kWhite),
                                                      ),
                                                      const SizedBox(
                                                        height: 5.0,
                                                      ),
                                                      quickFoodItemsList[index][
                                                                      'ingredient']
                                                                  .toString()
                                                                  .length >
                                                              15
                                                          ? Text(
                                                              '${quickFoodItemsList[index]['ingredient'].toString().substring(0, 13)}...',
                                                              style: GoogleFonts.manrope(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      kSupportiveGrey),
                                                            )
                                                          : Text(
                                                              quickFoodItemsList[
                                                                          index]
                                                                      [
                                                                      'ingredient']
                                                                  .toString(),
                                                              style: GoogleFonts.manrope(
                                                                  fontSize:
                                                                      12.sp,
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
                                                          // Image.asset(
                                                          //   'assets/icons/stars.png',
                                                          //   scale: 1.5,
                                                          // ),
                                                          // const SizedBox(
                                                          //   width: 5.0,
                                                          // ),
                                                          Text.rich(
                                                            TextSpan(
                                                              text:
                                                                  '\$ ${snapshot.data![index]['total']}',
                                                              style: GoogleFonts.manrope(
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800,
                                                                  color: !isDark
                                                                      ? kSecondaryColor
                                                                      : kPrimaryGreen), // default text style
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
                                )
                              : Text(
                                  'Food item not found.',
                                  style: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color: isDark ? kBalance : kDarkBG,
                                  ),
                                );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
