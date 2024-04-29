// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/models/active_orders_model.dart';
import 'package:skoop/screens/user/widgets/navBar.dart';

import '../../constant.dart';
import 'orderStatusScreen.dart';

class OrderConfirmedScreen extends StatelessWidget {
  OrderConfirmedScreen({Key? key}) : super(key: key);
  String restId = "";
  dynamic restaurant;
  ActiveOrder? order;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 33, right: 31),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/orderPlacedIcon.png',
              width: 138.w,
              height: 138.h,
            ),
            SizedBox(
              height: 60.h,
            ),
            Text(
              'Order Placed!',
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
                fontSize: 30.sp,
                color: !isDark ? kSecondaryColor : kWhite,
              ),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              'Your order was placed successfully\n'
              'for more details, check delivery status.',
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w400,
                fontSize: 13.sp,
                color: !isDark ? kSecondaryColor.withOpacity(.8) : kWhite,
              ),
            ),
            SizedBox(
              height: 67.h,
            ),
            StatefulBuilder(builder: (context, setStateBtn) {
              return GestureDetector(
                  onTap: isLoading
                      ? null
                      : () {
                          //1: OrderStatusScreen
                          setStateBtn(() {
                            isLoading = true;
                          });
                          getActiveOrders(context);
                        },
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
                        isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                color: kBalance,
                              ))
                            : Text(
                                'Order Status',
                                style: GoogleFonts.manrope(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w700,
                                  color: kWhite,
                                ),
                              )
                      ],
                    ),
                  ));
            }),
            SizedBox(
              height: 20.h,
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
                      Text(
                        'Continue Ordering',
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
                  //1: OrderStatusScreen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const bottomNavigationBar()),
                  );
                }),
          ],
        ),
      ),
    );
  }

  void getActiveOrders(BuildContext context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/active-orders');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      //final Map<String, dynamic> responseData = json.decode(response.body);
      //final List<Map<String, dynamic>> activeOrders = List<Map<String, dynamic>>.from(responseData['activeOrders']);
      ActiveOrder order = activeOrdersModelFromJson(response.body).activeOrders[
          activeOrdersModelFromJson(response.body).activeOrders.length - 1];
      await getItem(order.foodItems[0].item);
      print('order');
      print(order);
      print('restaurant on order confirmation');
      print(restaurant);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderStatusScreen(order, restaurant)),
      );
    } else {
      throw Exception('Failed to fetch active orders');
    }
  }

  Future<Map<String, dynamic>> getItem(String foodId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/get-singlefooditem/$foodId');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      print('food item single');
      print(userData);
      print(userData['restaurant']);
      restId = userData['restaurant'];
      await getRestaurant(restId);
      return userData;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
    }
  }

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
}
