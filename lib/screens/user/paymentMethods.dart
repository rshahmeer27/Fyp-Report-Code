import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import 'addNewCard.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  // Future<List<Map<String, dynamic>>> _cartItemListFuture =
  //     _getItemListFromPreferences();
  //
  // static Future<List<Map<String, dynamic>>>
  //     _getItemListFromPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final encodedItemList = prefs.getStringList('paymentCollection') ?? [];
  //   final itemList = encodedItemList.map((item) => json.decode(item)).toList();
  //   return itemList.cast<Map<String, dynamic>>();
  // }

  Future<List<dynamic>> getCards() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$port/getallcards');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final featureData = json.decode(response.body);
      // featuredRestaurant = featureData;
      return featureData;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch restaurants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Payment Method',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 32.w, right: 31.w),
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<List<dynamic>>(
            future: getCards(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final paymenta = snapshot.data;

                return ListView.builder(
                  itemCount: paymenta!.length,
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    final payment = paymenta[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            print('payment inscreen');
                            print(payment);
                            Navigator.pop(context, paymenta[index]);
                          },
                          child: Card(
                            elevation: 1,
                            child: Container(
                              height: 70.h,
                              width: 329.w,
                              decoration: BoxDecoration(
                                  color: kWhite,
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 13.w,
                                  ),
                                  Container(
                                    width: 38.w,
                                    height: 38.h,
                                    decoration: BoxDecoration(
                                        color: kPrimaryGreen,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                  ),
                                  SizedBox(
                                    width: 9.w,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(
                                      //   height: 5.h,
                                      // ),
                                      Text(
                                        payment['card_title'],
                                        style: GoogleFonts.manrope(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600,
                                          color: kSecondaryColor,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Mastercard ****${payment['card_number'].toString().substring(3, 7)}',
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 10.sp,
                                              color: kSupportiveGrey,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  // SizedBox(
                                  //   width: 100.w,
                                  // ),
                                  // Icon(
                                  //   Icons.arrow_forward_ios_rounded,
                                  //   color: kSupportiveGrey,
                                  //   size: 20.w,
                                  // )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 17.h,
                        ),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('Failed to fetch addresses'),
                );
              }

              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      bottomSheet: Container(
        height: 202.h,
        width: 390.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 35.h,
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
                        'Add New Card',
                        style: GoogleFonts.manrope(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                          color: kWhite,
                        ),
                      ),
                    ],
                  ),
                ),

                // Within the `FirstRoute` widget
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddNewCard()),
                  );
                }),
            SizedBox(
              height: 10.h,
            ),
          ],
        ),
      ),
    );
  }
}
