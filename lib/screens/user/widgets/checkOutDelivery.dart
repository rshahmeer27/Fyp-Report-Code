// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/deliveryAddress.dart';
import 'package:skoop/toast.dart';

import '../orderConfirmedScreen.dart';
import '../walletScreen.dart';

class CheckOutD extends StatefulWidget {
  var cartItemList;
  var price;
  CheckOutD(this.cartItemList, this.price);

  @override
  State<CheckOutD> createState() => _CheckOutDState();
}

class _CheckOutDState extends State<CheckOutD>
    with AutomaticKeepAliveClientMixin {
  bool isOrdered = false;
  bool isLoad = false;
  TextEditingController specialInstructionController = TextEditingController();
  var location;
  // var payment;
  // var showCardTitle = 'Add Card';
  var showLocationTitle = 'Add Location';
  dynamic _count = 0;
  double tax = 10;
  double calculateTenPercent(double totalPrice) {
    double tenPercent = totalPrice * 0.1;
    return tenPercent;
  }

  void _increamentCounter() {
    setState(() {
      _count++;
    });
  }

  void _decreamentCounter() {
    if (_count == 0) {
    } else {
      setState(() {
        _count--;
      });
    }
  }

  double deliveryCharges = 0.0;
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.cartItemList as String');
    print(widget.cartItemList);
    deliveryCharges = calculateTenPercent(double.parse(widget.price));
    _calculateTotalPrice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            color: kBG,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 22.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 32.w),
                child: Row(
                  children: [
                    Text(
                      'Address',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 9.h,
              ),
              SizedBox(
                width: 340.w,
                height: 70.h,
                child: Card(
                  elevation: 2,
                  color: !isDark ? kWhite : kcardColor,
                  child: Center(
                    child: ListTile(
                      onTap: () async {
                        location = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DeliveryAddress()),
                        );
                        setState(() {
                          showLocationTitle =
                              location['location_name'].toString().isNotEmpty
                                  ? location['location_name']
                                  : "Custom Location";
                          print('location id is');
                          print(location['_id']);
                          print(location['location_name']);
                        });
                        if (!mounted) return;
                      },
                      // isThreeLine: true,
                      contentPadding: const EdgeInsets.only(
                          bottom: 10.0, left: 10.0, right: 10.0),
                      minLeadingWidth: 15.0,
                      horizontalTitleGap: 10,
                      minVerticalPadding: 0.0,
                      leading: Image.asset(
                        'assets/icons/location_icon.png',
                        // width: 18.w,
                        // height: 20.h,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: Text(
                          showLocationTitle ?? 'Add Location',
                          style: GoogleFonts.manrope(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: !isDark ? kSecondaryColor : kWhite,
                          ),
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: !isDark ? kSupportiveGrey : kWhite,
                        size: 20.w,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 32.w),
                child: Row(
                  children: [
                    Text(
                      'Special Instructions',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 16.h,
              ),
              SizedBox(
                // padding: EdgeInsets.only(right: 10.w,left: 10.w),
                // margin: EdgeInsets.only(right: 7.w),
                width: 340.w,
                height: 111.h,
                child: Card(
                  elevation: 2,
                  color: !isDark ? kWhite : kcardColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r)),
                  child: TextField(
                    controller: specialInstructionController,
                    maxLines: 4,
                    style: GoogleFonts.manrope(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: !isDark ? kDarkBG : kWhite),
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kWhite),
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: kWhite),
                        ),
                        hintText: 'Enter Special Instructions',
                        hintStyle: GoogleFonts.manrope(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            color: !isDark ? kDarkBG : kWhite)),
                  ),
                ),
              ),
              // SizedBox(
              //   height: 15.h,
              // ),
              // Container(
              //   margin: EdgeInsets.only(left: 32.w),
              //   child: Row(
              //     children: [
              //       Text(
              //         'Payment Method',
              //         style: GoogleFonts.manrope(
              //           fontWeight: FontWeight.w700,
              //           fontSize: 20.sp,
              //           color: !isDark ? kSecondaryColor : kSupportiveGrey,
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              // // SizedBox(
              // //   height: 16.h,
              // // ),
              // // GestureDetector(
              // //   // onTap: () async {
              // //   onTap: () async {
              // //     payment = await Navigator.push(
              // //       context,
              // //       MaterialPageRoute(
              // //           builder: (context) => const PaymentMethodScreen()),
              // //     );
              // //     setState(() {
              // //       showCardTitle = payment['card_title'];
              // //     });
              // //     if (!mounted) return;
              // //     print('cardTitle on checkout');
              // //     print(payment['card_title']);
              // //     print(payment['_id']);
              // //   },
              // //   // print(payment);
              // //   // },
              // //   child: SizedBox(
              // //     width: 340.w,
              // //     height: 70.h,
              // //     child: Card(
              // //       elevation: 2,
              // //       child: Row(
              // //         children: [
              // //           SizedBox(
              // //             width: 15.w,
              // //           ),
              // //           Container(
              // //             child: Row(
              // //               children: [
              // //                 Container(
              // //                   width: 38.w,
              // //                   height: 38.h,
              // //                   decoration: BoxDecoration(
              // //                       color: kPrimaryGreen,
              // //                       borderRadius: BorderRadius.circular(10.r)),
              // //                 ),
              // //                 SizedBox(
              // //                   width: 9.w,
              // //                 ),
              // //                 Column(
              // //                   crossAxisAlignment: CrossAxisAlignment.start,
              // //                   children: [
              // //                     SizedBox(
              // //                       height: 10.h,
              // //                     ),
              // //                     Text(
              // //                       showCardTitle ?? 'Add Card',
              // //                       style: GoogleFonts.manrope(
              // //                         fontSize: 16.sp,
              // //                         fontWeight: FontWeight.w600,
              // //                         color: kSecondaryColor,
              // //                       ),
              // //                     ),
              // //                     Text(
              // //                       'Mastercard ****7462',
              // //                       style: GoogleFonts.manrope(
              // //                         fontSize: 10.sp,
              // //                         fontWeight: FontWeight.w600,
              // //                         color: kSupportiveGrey,
              // //                       ),
              // //                     ),
              // //                   ],
              // //                 ),
              // //               ],
              // //             ),
              // //           ),
              // //           SizedBox(
              // //             width: 150.w,
              // //           ),
              // //           Icon(
              // //             Icons.arrow_forward_ios_outlined,
              // //             color: kSupportiveGrey,
              // //             size: 20.w,
              // //           )
              // //         ],
              // //       ),
              // //     ),
              // //   ),
              // // ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                  margin: EdgeInsets.only(left: 32.w, right: 31.w),
                  child: const Divider()),
              SizedBox(
                height: 32.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 32.w, right: 31.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                    Text(
                      '\$ ${widget.price}',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 32.w, right: 31.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delivery Charges',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                    Text(
                      '\$ ${deliveryCharges.toStringAsFixed(2)}',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 32.w, right: 31.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tax',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                    Text(
                      '\$${tax.toStringAsFixed(2)}',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 19.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 32.w, right: 31.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tip',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),

                    ///tip
                    Flexible(
                      child: Container(
                        width: 114.w,
                        height: 35.h,
                        decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10.r)),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _decreamentCounter,
                              child: Container(
                                height: 35.h,
                                width: 33.w,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.r),
                                  color: kSecondaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    '-',
                                    style: GoogleFonts.manrope(
                                      fontSize: 16.sp,
                                      color: kWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 13.w,
                            ),
                            Text(
                              '\$ $_count',
                              style: GoogleFonts.manrope(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                color: kSecondaryColor,
                              ),
                            ),
                            SizedBox(
                              width: 13.w,
                            ),
                            Flexible(
                              child: GestureDetector(
                                onTap: _increamentCounter,
                                child: Container(
                                  height: 35.h,
                                  width: 33.w,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    color: kSecondaryColor,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '+',
                                      style: GoogleFonts.manrope(
                                        fontSize: 16.sp,
                                        color: kWhite,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                  margin: EdgeInsets.only(left: 32.w, right: 31.w),
                  child: const Divider()),
              SizedBox(
                height: 12.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 32.w, right: 31.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                    Text(
                      '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 39.h,
              ),
              GestureDetector(
                onTap: () {
                  // setState(() {
                  //   isLoad = true;
                  // });
                  if (location != null) {
                    if (isOrdered) {
                      orderFood();
                    }
                  } else {
                    showToastLong("Please add the location to place the order",
                        Colors.red);
                  }
                  isOrdered = true;
                },
                child: Container(
                  height: 50.h,
                  width: 326.w,
                  decoration: BoxDecoration(
                    color: kPrimaryGreen,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      isLoad
                          ? const CircularProgressIndicator(
                              color: kWhite,
                            )
                          : Text(
                              'Pay \$${_calculateTotalPrice().toStringAsFixed(2)}',
                              style: GoogleFonts.manrope(
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w700,
                                color: kWhite,
                              ),
                            )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  dynamic _calculateTotalPrice() {
    double totalPrice = 0.0;
    double deliveryCharges = calculateTenPercent(double.parse(widget.price));
    setState(() {
      totalPrice = double.parse(widget.price) +
          deliveryCharges +
          double.parse(_count.toString()) +
          tax;
    });

    print('totalPrice of order');
    print(totalPrice);
    return totalPrice;
  }

  orderFood() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString('token').toString();
    final userId = sp.getString('id').toString();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    print('widget.cartItemList.runtimeType.toString() $location');
    print(widget.cartItemList.runtimeType.toString());
    var request = http.Request('POST', Uri.parse('$port/create-order'));
    request.body = json.encode({
      "address": location['_id'],
      "status": 0,
      "delivery_charges": deliveryCharges,
      // "type": "pickup",
      "tip": _count,
      // "payment_method": "cod",
      "special_instructions": specialInstructionController.text,
      "foodItems": widget.cartItemList,
      "tax": tax,
      "total": _calculateTotalPrice(),
      "subtotal": widget.price,
      // "card": payment['_id']
    });
    print('===============request ${jsonDecode(request.body).toString()}');
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 201) {
      print('await response.stream.bytesToString()');
      print(await response.stream.bytesToString());
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.remove('itemListCartA').whenComplete(() => print('sp removed'));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => OrderConfirmedScreen()));
    } else if (response.statusCode == 400) {
      showToastShort(
          'Insufficient Balance. Please deposit some amount in your wallet to place order',
          kRedColor);
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => WalletScreen()));
    } else {
      print('response.reasonPhrase');
      print(response.reasonPhrase);
      print('response.statusCode.toString()');
      print(response.statusCode.toString());
    }
  }
}
