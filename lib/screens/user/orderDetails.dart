import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/orderStatusScreen.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';
import 'package:skoop/toast.dart';

import '../../constant.dart';

class OrderDetails extends StatefulWidget {
  var order;
  var itemNamee;
  OrderDetails(this.order, this.itemNamee);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  ///get address info by id
  var restId;
  // var itemName;
  Future<Map<String, dynamic>> getSingleAddress(String id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$port/get-singleaddress/$id');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return responseData['address'];
    } else {
      throw Exception('Failed to load address');
    }
  }

  ///get order details from list of ids

  Future<Map<String, dynamic>> getItem(String foodId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/get-singlefooditem/$foodId');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print('food item single $foodId');
      print(userData);
      print(userData['restaurant']);
      restId = userData['restaurant'];
      // itemName = userData['restaurant']['name'];
      // print('itemName');
      // print(itemName);
      return userData;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
    }
  }

  var restaurant;
  Future<Map<String, dynamic>> getRestaurant(String Id) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/getrestaurant/$Id');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print('Restaurant info');
      print(userData);
      // print(userData['restaurant']);
      restaurant = userData;
      print('restaurant on function whole');
      print(restaurant);
      return userData;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
    }
  }

  List<Map<String, dynamic>> foodItems = [];
  getFoodItemssss() {
    var foodItems1 = widget.order['foodItems'];
    foodItems = List<Map<String, dynamic>>.from(foodItems1);
    print('foodItems on tap afterrrrrrrrrrrrrrr');
    print(foodItems);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.order');
    print(widget.order);
    getFoodItemssss();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen,
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
          widget.itemNamee,
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: kBG,
                // borderRadius: BorderRadius.only(
                //   topLeft: Radius.circular(16),
                //   topRight: Radius.circular(16),
                // ),
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60.0,
                    ),
                    // SizedBox(
                    //   height: 24.h,
                    // ),

                    // DetailsComponents('Costumer Name', 'Alex Costa'),
                    DetailsComponents('Order ID', '#${widget.order['_id']}'),
                    FutureBuilder(
                      future: getSingleAddress(widget.order['address']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else {
                          final addressData =
                              snapshot.data as Map<String, dynamic>;
                          return DetailsComponents(
                              'Destination',
                              addressData['location_name'] ??
                                  'Unknown Location');
                        }
                      },
                    ),

                    DetailsComponents(
                        'Remaining Time',
                        widget.order['remainingTime'] == ''
                            ? 'Not Available'
                            : widget.order['remainingTime']),
                    DetailsComponents('Special Instructions',
                        widget.order['special_instructions']),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: kFieldStyleSupp,
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            height: 80.0,
                            child: ListView.builder(
                              itemCount: foodItems.length,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final foodItem = foodItems[index];
                                return FutureBuilder(
                                  future: getItem(foodItem['item']),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child:
                                              CircularProgressIndicator()); // Loading indicator while fetching data
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (!snapshot.hasData) {
                                      return const Text('No data available');
                                    } else {
                                      final itemData =
                                          snapshot.data as Map<String, dynamic>;
                                      restId = itemData['restaurant'];
                                      print('restId');
                                      print(restId);
                                      getRestaurant(restId);

                                      final itemName = itemData['name'];
                                      return Row(
                                        children: [
                                          Container(
                                            width: 105,
                                            height: 30,
                                            decoration: BoxDecoration(
                                                color: kPrimaryGreen,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.0)),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    itemName,
                                                    style: kOrderComponentStyle,
                                                  ),
                                                  Text(
                                                    ' (${foodItem['quantity'].toString()})',
                                                    style: kOrderComponentStyle,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          // Text('Item Name: ${itemName}'),
                                          // const SizedBox(width: 10),
                                          // Text(
                                          //     'Quantity: ${foodItem['quantity']}'),
                                        ],
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    widget.order['status'] == 1 || widget.order['status'] == 0
                        ? getCtaButton(
                            onPress: () {
                              cancelOrder(context);
                            },
                            color: kSupportiveGrey,
                            text: 'Cancel Order')
                        : const SizedBox(),

                    const SizedBox(
                      height: 10,
                    ),
                    widget.order['status'] == 4
                        ? getCtaButton(
                            onPress: () {
                              cancelOrder(context);
                            },
                            color: kRedColor,
                            text: 'Order Cancelled')
                        : getCtaButton(
                            onPress: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => OrderStatusScreen(
                                          widget.order, restaurant)));
                            },
                            color: kPrimaryGreen,
                            text: 'Track Order'),
                    const SizedBox(
                      height: 100.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextEditingController cancelReasonController = TextEditingController();
  Future<void> cancelOrder(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBG,
          title: Column(
            children: [
              Text(
                'Cancel Order',
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: kSecondaryColor,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              const Divider(
                height: 1,
                indent: 5,
                endIndent: 5,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    // margin: EdgeInsets.only(right: 7.w),
                    width: MediaQuery.of(context).size.width * 0.89,
                    height: 109.h,
                    decoration: BoxDecoration(
                        color: !isDark ? kWhite : kcardColor,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: TextField(
                      controller: cancelReasonController,
                      style: kFieldStyle.copyWith(
                          color: !isDark ? kcardColor : kWhite),
                      decoration: InputDecoration(
                        fillColor: !isDark ? kWhite : kcardColor,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        hintText:
                            'Tell us why do you want to cancel the order (Required)',
                        hintStyle: kFieldStyle.copyWith(
                            color: !isDark ? kcardColor : kWhite),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 46.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: kPrimaryGreen,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cancel Now',
                        style: GoogleFonts.manrope(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: kWhite,
                        ),
                      )
                    ],
                  ),
                ),

                // Within the `FirstRoute` widget
                onTap: () {
                  cancelOrderById(
                          widget.order['_id'], cancelReasonController.text)
                      .whenComplete(() => Navigator.pop(context));

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const OrderStatusScreen()),
                  // );
                }),
          ],
        );
      },
    );
  }

  Future<void> cancelOrderById(String orderId, String cancelReason) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/cancel-order/$orderId');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final patchData = {
      'reason': cancelReason,
    };

    final response = await http.patch(
      url,
      headers: headers,
      body: json.encode(patchData),
    );

    if (response.statusCode == 204) {
      print('Order cancelled successfully');
      showToastShort('Order cancelled successfully', kRedColor);
      Navigator.pop(context);
    } else {
      throw Exception('Failed to cancel order');
    }
  }
}

Widget DetailsComponents(var heading, var subHead) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          heading,
          style: kFieldStyleSupp,
        ),
        const SizedBox(
          height: 5.0,
        ),
        Text(
          subHead,
          style: kFieldStyleSec,
        ),
        const Divider(
          height: 1.0,
        ),
      ],
    ),
  );
}
