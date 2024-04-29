import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';

class CheckOutS extends StatefulWidget {
  var cartItemList;
  var price;
  CheckOutS(this.cartItemList, this.price);

  @override
  State<CheckOutS> createState() => _CheckOutSState();
}

class _CheckOutSState extends State<CheckOutS> {
  TextEditingController specialInstruction = TextEditingController();
  // var payment;
  // var showCardTitle = 'Add Card';
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
                height: 27.h,
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
                    controller: specialInstruction,
                    maxLines: 4,
                    style: GoogleFonts.manrope(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                    ),
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
                            color: !isDark ? kSupportiveGrey : kWhite)),
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
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
              // SizedBox(
              //   height: 16.h,
              // ),
              // GestureDetector(
              //   // onTap: () async {
              //   onTap: () async {
              //     payment = await Navigator.push(
              //       context,
              //       MaterialPageRoute(
              //           builder: (context) => const PaymentMethodScreen()),
              //     );
              //     setState(() {
              //       showCardTitle = payment['card_title'];
              //     });
              //     if (!mounted) return;
              //     print('cardTitle on checkout');
              //     print(payment['card_title']);
              //     print(payment['_id']);
              //   },
              //   // print(payment);
              //   // },
              //   child: SizedBox(
              //     width: 340.w,
              //     height: 70.h,
              //     child: Card(
              //       elevation: 2,
              //       child: Row(
              //         children: [
              //           SizedBox(
              //             width: 15.w,
              //           ),
              //           Container(
              //             child: Row(
              //               children: [
              //                 Container(
              //                   width: 38.w,
              //                   height: 38.h,
              //                   decoration: BoxDecoration(
              //                       color: kPrimaryGreen,
              //                       borderRadius: BorderRadius.circular(10.r)),
              //                 ),
              //                 SizedBox(
              //                   width: 9.w,
              //                 ),
              //                 Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     SizedBox(
              //                       height: 10.h,
              //                     ),
              //                     Text(
              //                       showCardTitle ?? 'Add Card',
              //                       style: GoogleFonts.manrope(
              //                         fontSize: 16.sp,
              //                         fontWeight: FontWeight.w600,
              //                         color: kSecondaryColor,
              //                       ),
              //                     ),
              //                     Text(
              //                       'Mastercard ****7462',
              //                       style: GoogleFonts.manrope(
              //                         fontSize: 10.sp,
              //                         fontWeight: FontWeight.w600,
              //                         color: kSupportiveGrey,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ),
              //           SizedBox(
              //             width: 150.w,
              //           ),
              //           Icon(
              //             Icons.arrow_forward_ios_outlined,
              //             color: kSupportiveGrey,
              //             size: 20.w,
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SizedBox(
              //   height: 28.h,
              // ),
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
                      '\$${widget.price}',
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
                height: 40.h,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        height: 70.0,
        color: !isDark ? kWhite : kcardColor,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  orderFood();
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
                      Text(
                        'Pay \$${widget.price}',
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
            ],
          ),
        ),
      ),
    );
  }

  orderFood() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString('token').toString();
    final userId = sp.getString('id').toString();
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };
    print('widget.cartItemList.runtimeType.toString()');
    print(widget.cartItemList.runtimeType.toString());
    var request = http.Request('POST', Uri.parse('$port/create-order'));
    request.body = json.encode({
      "type": "pickup",
      // "payment_method": "cod",
      "special_instructions": specialInstruction.text,
      "foodItems": widget.cartItemList,
      // "tax": tax,
      "total": widget.price,
      "subtotal": widget.price,
      // "card": payment['_id']
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
