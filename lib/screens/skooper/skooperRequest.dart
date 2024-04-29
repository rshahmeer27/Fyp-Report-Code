// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/skooper/skooperNavigationBar.dart';
import 'package:skoop/screens/skooper/skooperRideRequestDetails.dart';
import 'package:skoop/toast.dart';

import '../../constant.dart';
import 'accptedOrderSkooper/accpetedSkooperOrdersRequests.dart';

class SkooperRequestScreen extends StatefulWidget {
  var rideRuest;
  SkooperRequestScreen(this.rideRuest);

  @override
  State<SkooperRequestScreen> createState() => _SkooperRequestScreenState();
}

class _SkooperRequestScreenState extends State<SkooperRequestScreen> {
  bool isAcceptedOrder = false;
  bool isAccept = false;
  var acceptedListA;
  // Future<List<dynamic>> fetchAcceptedRideRequests() async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   var token = sp.getString('token').toString();
  //
  //   final url = Uri.parse('$portSkooper/currentacceptedrequests');
  //   // final body = {'$key': value};
  //   final headers = {'Authorization': 'Bearer $token'};
  //   final response = await http.get(url, headers: headers);
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     print('data in accepeted list');
  //     print(data);
  //     print(data['acceptedRequests']);
  //     acceptedListA = data['acceptedRequests'];
  //     // if (data['acceptedRequests'][0]['_id'] == widget.rideRuest[0]['_id']) {
  //     //   setState(() {
  //     //     isAcceptedOrder = true;
  //     //     print('isAcceptedOrder');
  //     //     print(isAcceptedOrder);
  //     //   });
  //     // }
  //     return data['acceptedRequests'];
  //   } else {
  //     print('response.statusCode.toString()');
  //     print(response.statusCode.toString());
  //     throw Exception('Failed to load ride requests');
  //   }
  // }
  Future<List<dynamic>> fetchAcceptedRideRequests() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$portSkooper/currentacceptedrequests');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['acceptedRequests'];
    } else {
      throw Exception('Failed to load ride requests');
    }
  }

  void handleRideRequests() async {
    // final rideRequests = await fetchRideRequests();
    final acceptedRideRequests = await fetchAcceptedRideRequests();
    if (acceptedRideRequests.isEmpty) {
      showToastShort('That order is assigned to another rider', kPrimaryGreen);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => SkooperBottomNavigationBar()));
    } else {
      // showAcceptedRides = true;
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  AcceptedSkooperRequestScreen(acceptedRideRequests, true)));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.rideRuest');
    print(widget.rideRuest);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage("assets/images/skooperProfileBG.png"),
                scale: 1.5,
                // fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 195.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: !isDark ? kWhite : kcardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RIDE REQUEST',
                        style: GoogleFonts.manrope(
                          color: !isDark ? kSecondaryColor : kWhite,
                          fontWeight: FontWeight.w800,
                          fontSize: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 24.h,
                  ),

                  ///order details
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => SkooperRideRequestDetails(
                                  widget.rideRuest, isAcceptedOrder)));
                    },
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 32.w, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Order Details',
                            style: kFieldStyleSec,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Text(
                            'Tap to view order details',
                            style: kFieldStyleSupp,
                          ),
                          const Divider(
                            height: 1.0,
                          ),
                        ],
                      ),
                    ),
                  ),

                  ///number
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Destination',
                          style: kFieldStyleSupp,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          widget.rideRuest['address']['location_name']
                              .toString(),
                          style: kFieldStyleSec,
                        ),
                        const Divider(
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),

                  ///ID
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Total Order Cost',
                          style: kFieldStyleSupp,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '\$ ${widget.rideRuest['total'].toString()}.00',
                          style: kFieldStyleSec,
                        ),
                        const Divider(
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),

                  ///Role
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.w, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Minimum Payment',
                          style: kFieldStyleSupp,
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          '\$ ${widget.rideRuest['total'].toString()}.00',
                          style: kFieldStyleSec,
                        ),
                        const Divider(
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),
                  !isAccept
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 55, vertical: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    // Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //         builder: (_) =>
                                    //             const MapToRestaurantScreen()));
                                    showToastShort(
                                        'Please wait a minute', kPrimaryGreen);
                                    if (isAccept == false) {
                                      acceptRideRequest(
                                          widget.rideRuest['_id']);
                                    } else {
                                      print('no action');
                                    }
                                    setState(() {
                                      isAccept = true;
                                    });

                                    print('isAccept');
                                    print(isAccept);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 117.w,
                                    decoration: BoxDecoration(
                                      color: kPrimaryGreen,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Accept',
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            color: kWhite,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                    // cancelRideRequest(widget.rideRuest[0]['_id']);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    width: 117.w,
                                    decoration: BoxDecoration(
                                      color: kSupportiveGrey,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Decline',
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            color: kWhite,
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : CupertinoPageScaffold(
                          child: TimerCountdown(
                            format: CountDownTimerFormat.secondsOnly,
                            endTime: DateTime.now().add(
                              const Duration(
                                // days: 5,
                                // hours: 14,
                                seconds: 59,
                              ),
                            ),
                            onEnd: () {
                              handleRideRequests();
                            },
                          ),
                        ),
                  // !isAccept
                  //     ? SizedBox()
                  //     : CupertinoPageScaffold(
                  //         child: TimerCountdown(
                  //           format: CountDownTimerFormat.minutesSeconds,
                  //           endTime: DateTime.now().add(
                  //             const Duration(
                  //               // days: 5,
                  //               // hours: 14,
                  //               minutes: 1,
                  //               seconds: 59,
                  //             ),
                  //           ),
                  //           onEnd: () {
                  //             fetchAcceptedRideRequests().then((value) {
                  //               print('value');
                  //               print(value);
                  //             });
                  //             // print('============acceptedList after edn');
                  //             // print(acceptedListA);
                  //           },
                  //         ),
                  //       ),
                  const SizedBox(
                    height: 100.0,
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              top: 135.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/skooperReqImage.png',
                  scale: 2.0,
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 25.0, right: 300.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/icons/backIcon.png',
                  scale: 2.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> acceptRideRequest(String id) async {
    print('id');
    print(id);
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$portSkooper/acceptrequest/$id');
    // final body = {'$key': value};
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.patch(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Ride accepted');
      // showToastShort('Ride Accepted', kPrimaryGreen);
      final accpetedOrder = fetchAcceptedRideRequests();
      print('accpetedOrder on tap');
      print(accpetedOrder);
    } else {
      print(response.body);
      print('Failed to accept ride request: ${response.statusCode}');
    }
  }

  Future<void> cancelRideRequest(String idwe) async {
    print('order id');
    print(idwe);
    print('order id original');
    print(widget.rideRuest[0]['_id']);
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$portSkooper/cancelride/$idwe');
    // final body = {'$key': value};
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.patch(
      url,
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('Ride cancelled successfully');
    } else {
      print('Failed to accept ride request: ${response.statusCode}');
    }
  }
}
