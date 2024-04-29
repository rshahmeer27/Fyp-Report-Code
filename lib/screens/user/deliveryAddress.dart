import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import 'addNewAddress.dart';

class DeliveryAddress extends StatefulWidget {
  const DeliveryAddress({Key? key}) : super(key: key);

  @override
  State<DeliveryAddress> createState() => _DeliveryAddressState();
}

class _DeliveryAddressState extends State<DeliveryAddress> {
  Future<List<dynamic>> getAddress() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$port/view-deliveryaddress');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final featureData = json.decode(response.body);
      // featuredRestaurant = featureData;
      return featureData['addresses'];
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
        backgroundColor: isDark ? kDarkBg : kBG,
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
          'Delivery Addresses',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 32.w),
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: Column(
          children: [
            SizedBox(
              height: 26.h,
            ),
            SizedBox(
              height: 500,
              child: FutureBuilder<List<dynamic>>(
                future: getAddress(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final addresses = snapshot.data;

                    return ListView.builder(
                      itemCount: addresses!.length,
                      scrollDirection: Axis.vertical,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        final address = addresses[index];
                        print('=============adress $address');

                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context, addresses[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/icons/location_icon.png',
                                          width: 18.w,
                                          height: 20.h,
                                        ),
                                        SizedBox(
                                          width: 12.w,
                                        ),
                                        Text(
                                          address['location_name'] == ''
                                              ? 'Custom Location'
                                              : address['location_name'],
                                          style: GoogleFonts.manrope(
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w600,
                                            color: !isDark
                                                ? kSecondaryColor
                                                : kWhite,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(
                                      Icons.check_outlined,
                                      color: kPrimaryGreen,
                                      size: 20.w,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const Divider(
                              indent: 30,
                              endIndent: 30,
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
                      child: Text('Failed to fetch addresses'),
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
      ),
      bottomSheet: Container(
        height: 202.h,
        width: 390.w,
        color: isDark ? kDarkBg : kBG,
        // decoration: BoxDecoration(
        //   color: Colors.white,
        //   borderRadius: BorderRadius.only(
        //     topLeft: Radius.circular(30.r),
        //     topRight: Radius.circular(30.r),
        //   ),
        //   boxShadow: const [
        //     BoxShadow(
        //       color: kBG,
        //       spreadRadius: 20,
        //       blurRadius: 10,
        //       offset: Offset(0, 0), // changes position of shadow
        //     ),
        //   ],
        // ),
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
                      Image.asset(
                        'assets/icons/locWhite.png',
                        width: 18.w,
                        height: 20.h,
                      ),
                      SizedBox(
                        width: 12.w,
                      ),
                      Text(
                        'Add New Address',
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
                onTap: () async {
                  bool result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNewAddress()),
                  );
                  if (result) {
                    setState(() {});
                  }
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
