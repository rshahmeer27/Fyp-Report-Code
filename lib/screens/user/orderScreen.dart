import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import 'orderDetails.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isChecked = false;
  bool isSelected = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController searchC = TextEditingController();
  var dropdownValue = 'Light';
  List<Map<String, dynamic>> foodItemsList = [];
  List<Map<String, dynamic>> pastFoodItemsList = [];
  List<Map<String, dynamic>> quickFoodItemsList = [];
  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  Future<List<Map<String, dynamic>>> getActiveOrders() async {
    foodItemsList = [];
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/active-orders');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<Map<String, dynamic>> activeOrders =
          List<Map<String, dynamic>>.from(responseData['activeOrders']);
      //Added by sadaf
      for (int i = 0; i < activeOrders.length; i++) {
        final order = activeOrders[i];
        final foodItems = order['foodItems'] as List<dynamic>;
        final firstFoodItem = foodItems[0]['item'];
        foodItemsList.add(await getItem(firstFoodItem));
      }
      return activeOrders;
    } else {
      throw Exception('Failed to fetch active orders');
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: dropdownValue != 'Dark' ? kBG : kDarkBG,
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
              // Navigator.pop(context);
            }),
        title: Text(
          'Orders',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),

              ///Featured
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Active Orders',
                      style: GoogleFonts.manrope(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),

              ///active body
              SizedBox(
                height: 250,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getActiveOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                        'No orders available.',
                        style: TextStyle(
                            color: !isDark ? kSecondaryColor : kWhite),
                      ));
                    } else {
                      dynamic order;

                      for (int i = 0; i < snapshot.data!.length; i++) {
                        order = snapshot.data![i];
                      }
                      //foodItemsList = [];

                      return foodItemsList.isNotEmpty
                          ? ListView.builder(
                              itemCount: foodItemsList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                print('snapshot');
                                print(snapshot.data![index]);
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print(foodItemsList[0]['name']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => OrderDetails(
                                                snapshot.data![index],
                                                foodItemsList[0]['name']),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 90,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        decoration: BoxDecoration(
                                          color: !isDark ? kWhite : kcardColor,
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
                                                  BorderRadius.circular(10.0),
                                              child: Image.memory(
                                                stringToUint8List(
                                                    foodItemsList[index]
                                                        ["image"]),
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
                                                    foodItemsList[index]
                                                        ['name'],
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
                                                  foodItemsList[index]
                                                                  ['ingredient']
                                                              .toString()
                                                              .length >
                                                          15
                                                      ? Text(
                                                          '${foodItemsList[index]['ingredient'].toString().substring(0, 13)}...',
                                                          style: GoogleFonts
                                                              .manrope(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      kSupportiveGrey),
                                                        )
                                                      : Text(
                                                          foodItemsList[index]
                                                                  ['ingredient']
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .manrope(
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
                                                              fontSize: 14.sp,
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

              const SizedBox(
                height: 30.0,
              ),

              ///past
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Past Orders',
                      style: GoogleFonts.manrope(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),

              ///past body
              SizedBox(
                height: 300,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getPastOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: Text(
                        'No orders available.',
                        style: TextStyle(
                            color: !isDark ? kSecondaryColor : kWhite),
                      ));
                    } else {
                      return pastFoodItemsList.isNotEmpty
                          ? ListView.builder(
                              itemCount: pastFoodItemsList.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                print('========past item index $index');
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        print(pastFoodItemsList[0]['name']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => OrderDetails(
                                                snapshot.data![index],
                                                pastFoodItemsList[0]['name']),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 90,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        decoration: BoxDecoration(
                                          color: !isDark ? kWhite : kcardColor,
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
                                                  BorderRadius.circular(10.0),
                                              child: Image.memory(
                                                stringToUint8List(
                                                    pastFoodItemsList[index]
                                                        ["image"]),
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
                                                    pastFoodItemsList[index]
                                                        ['name'],
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
                                                  pastFoodItemsList[index]
                                                                  ['ingredient']
                                                              .toString()
                                                              .length >
                                                          15
                                                      ? Text(
                                                          '${pastFoodItemsList[index]['ingredient'].toString().substring(0, 13)}...',
                                                          style: GoogleFonts
                                                              .manrope(
                                                                  fontSize:
                                                                      12.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      kSupportiveGrey),
                                                        )
                                                      : Text(
                                                          pastFoodItemsList[
                                                                      index]
                                                                  ['ingredient']
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .manrope(
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
                                                              fontSize: 14.sp,
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
              const SizedBox(
                height: 100.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getPastOrders() async {
    pastFoodItemsList = [];
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
        pastFoodItemsList.add(await getItem(firstFoodItem));
        print('===========length ${pastFoodItemsList.length}');
      }
      return activeOrders;
    } else {
      throw Exception('Failed to fetch active orders');
    }
  }
}
