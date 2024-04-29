// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skoop/screens/skooper/skooperRideRequestDetails.dart';

import '../../../constant.dart';

class AcceptedSkooperRequestScreen extends StatefulWidget {
  var rideRuest;
  bool isAcceptedOrder;
  AcceptedSkooperRequestScreen(this.rideRuest, this.isAcceptedOrder);

  @override
  State<AcceptedSkooperRequestScreen> createState() =>
      _AcceptedSkooperRequestScreenState();
}

class _AcceptedSkooperRequestScreenState
    extends State<AcceptedSkooperRequestScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.rideRuestAAA');
    print(widget.rideRuest);
    print('widget.isAccepted');
    print(widget.isAcceptedOrder);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryGreen,
      // appBar: AppBar(
      //   centerTitle: true,
      //   elevation: 0,
      //   backgroundColor: kPrimaryGreen,
      //   leading: IconButton(
      //     icon: const Icon(
      //       Icons.arrow_back_ios,
      //       color: kWhite,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
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
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
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
                        'ACCEPTED RIDE REQUEST',
                        style: GoogleFonts.manrope(
                          color: kSecondaryColor,
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
                                  widget.rideRuest[0],
                                  widget.isAcceptedOrder)));
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
                          'sdlkn',
                          // widget.rideRuest['address']['location_name'].toString(),
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
                          '\$ ${widget.rideRuest[0]['total'].toString()}.00',
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
                          '\$ ${widget.rideRuest[0]['total'].toString()}.00',
                          style: kFieldStyleSec,
                        ),
                        const Divider(
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),
                  // widget.isAcceptedOrder == false
                  //     ? Padding(
                  //         padding: const EdgeInsets.symmetric(
                  //             horizontal: 55, vertical: 20.0),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //           children: [
                  //             GestureDetector(
                  //                 onTap: () {
                  //                   // Navigator.push(
                  //                   //     context,
                  //                   //     MaterialPageRoute(
                  //                   //         builder: (_) =>
                  //                   //             const MapToRestaurantScreen()));
                  //                   acceptRideRequest(
                  //                       widget.rideRuest[0]['_id']);
                  //                 },
                  //                 child: Container(
                  //                   height: 40.h,
                  //                   width: 117.w,
                  //                   decoration: BoxDecoration(
                  //                     color: kPrimaryGreen,
                  //                     borderRadius: BorderRadius.circular(10.r),
                  //                   ),
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       Text(
                  //                         'Accept',
                  //                         style: GoogleFonts.manrope(
                  //                           fontWeight: FontWeight.w600,
                  //                           fontSize: 15.sp,
                  //                           color: kWhite,
                  //                         ),
                  //                       )
                  //                     ],
                  //                   ),
                  //                 )),
                  //             GestureDetector(
                  //                 onTap: () {
                  //                   Navigator.pop(context);
                  //                   // cancelRideRequest(widget.rideRuest[0]['_id']);
                  //                 },
                  //                 child: Container(
                  //                   height: 40.h,
                  //                   width: 117.w,
                  //                   decoration: BoxDecoration(
                  //                     color: kSupportiveGrey,
                  //                     borderRadius: BorderRadius.circular(10.r),
                  //                   ),
                  //                   child: Row(
                  //                     mainAxisAlignment:
                  //                         MainAxisAlignment.center,
                  //                     children: [
                  //                       Text(
                  //                         'Decline',
                  //                         style: GoogleFonts.manrope(
                  //                           fontWeight: FontWeight.w600,
                  //                           fontSize: 15.sp,
                  //                           color: kWhite,
                  //                         ),
                  //                       )
                  //                     ],
                  //                   ),
                  //                 )),
                  //           ],
                  //         ),
                  //       )
                  //     : const SizedBox(),
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
          // GestureDetector(
          //   onTap: () {
          //     Navigator.pop(context);
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.only(top: 25.0, right: 300.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Image.asset(
          //           'assets/icons/backIcon.png',
          //           scale: 2.0,
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // Future<void> acceptRideRequest(String id) async {
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   var token = sp.getString('token').toString();
  //
  //   final url = Uri.parse('$portSkooper/acceptrequest/$id');
  //   // final body = {'$key': value};
  //   final headers = {'Authorization': 'Bearer $token'};
  //   final response = await http.patch(
  //     url,
  //     headers: headers,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Ride accepted');
  //     showToastShort('Ride Accepted', kPrimaryGreen);
  //     final accpetedOrder = fetchAcceptedRideRequests();
  //     print('accpetedOrder on tap');
  //     print(accpetedOrder);
  //   } else {
  //     print('Failed to accept ride request: ${response.statusCode}');
  //   }
  // }

  // Future<void> cancelRideRequest(String idwe) async {
  //   print('order id');
  //   print(idwe);
  //   print('order id original');
  //   print(widget.rideRuest[0]['_id']);
  //   SharedPreferences sp = await SharedPreferences.getInstance();
  //   var token = sp.getString('token').toString();
  //
  //   final url = Uri.parse('$portSkooper/cancelride/$idwe');
  //   // final body = {'$key': value};
  //   final headers = {'Authorization': 'Bearer $token'};
  //   final response = await http.patch(
  //     url,
  //     headers: headers,
  //   );
  //
  //   if (response.statusCode == 200) {
  //     print('Ride cancelled successfully');
  //   } else {
  //     print('Failed to accept ride request: ${response.statusCode}');
  //   }
  // }
}
