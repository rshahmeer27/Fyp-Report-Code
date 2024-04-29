import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/skooper/skooperRequest.dart';
import 'package:skoop/toast.dart';

import '../../constant.dart';

class ListForOrdersSkooper extends StatefulWidget {
  var rideRuest;
  int noOfOrders;
  ListForOrdersSkooper(this.rideRuest, this.noOfOrders);

  @override
  State<ListForOrdersSkooper> createState() => _ListForOrdersSkooperState();
}

class _ListForOrdersSkooperState extends State<ListForOrdersSkooper> {
  bool isAcceptedOrder = false;
  bool isAccept = false;
  Future<List<dynamic>> fetchAcceptedRideRequests() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$portSkooper/currentacceptedrequests');
    // final body = {'$key': value};
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('data in accpeted');
      print(data);
      print(data['acceptedRequests']);

      if (data['acceptedRequests'][0]['_id'] == widget.rideRuest[0]['_id']) {
        setState(() {
          isAcceptedOrder = true;
          print('isAcceptedOrder');
          print(isAcceptedOrder);
        });
      }
      return data['acceptedRequests'];
    } else {
      print('response.statusCode.toString()');
      print(response.statusCode.toString());
      throw Exception('Failed to load ride requests');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('widget.rideRequest');
    print(widget.rideRuest);
    print(widget.rideRuest[0]['_id']);
    print(widget.rideRuest);
    print('widget.rideRuest.toString().length');
    print(widget.rideRuest.toString().length);
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
            margin: const EdgeInsets.only(top: 175.0),
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
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'RIDE REQUESTS',
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
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: widget.noOfOrders,
                      itemBuilder: (context, index) {
                        print('widget.rideRuest');
                        print(widget.rideRuest);
                        // print(widget.rideRuest[index]['foodItems']['name']);
                        // List<dynamic> foodItem =
                        //     widget.rideRuest[index]['foodItems'][0]['item'];
                        // print('foodItem in loop');
                        // print(foodItem);
                        int no = index + 1;
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => SkooperRequestScreen(
                                            widget.rideRuest[index])));
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: 70,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: kPrimaryGreen.withOpacity(.41)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '#${no.toString()}',
                                      style: TextStyle(
                                          color: !isDark
                                              ? kSecondaryColor
                                              : kWhite),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.rideRuest[index]['foodItems']
                                              [0]['item']['name'],
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kWhite),
                                        ),
                                        const SizedBox(
                                          height: 3,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              widget.rideRuest[index]
                                                          ['foodItems'][0]
                                                      ['item']['restaurant']
                                                  ['restaurant_name'],
                                              style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w400,
                                                  color: !isDark
                                                      ? kGreyTextColor
                                                      : kWhite),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.rideRuest[index]['address']
                                                      ['location_name']
                                                  .toString(),
                                              style: GoogleFonts.manrope(
                                                  color: !isDark
                                                      ? kSecondaryColor
                                                      : kWhite),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              '\$ ${widget.rideRuest[index]['total'].toString()}',
                                              style: GoogleFonts.manrope(
                                                  color: Colors.deepOrange),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.arrow_forward_ios_sharp,
                                      color: !isDark ? kSecondaryColor : kWhite,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            )
                            // ListTile(
                            //   horizontalTitleGap: 0,
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (_) => SkooperRequestScreen(
                            //                 widget.rideRuest[index])));
                            //   },
                            //   leading: Text(
                            //     '#${no.toString()}',
                            //     style: GoogleFonts.manrope(
                            //         color: !isDark ? kSecondaryColor : kWhite),
                            //   ),
                            //   title: Column(
                            //     children: [
                            //       Text(
                            //         widget.rideRuest[index]['foodItems'][0]
                            //             ['item']['name'],
                            //         style: GoogleFonts.manrope(
                            //             color:
                            //                 !isDark ? kSecondaryColor : kWhite),
                            //       ),
                            //       Text(
                            //         widget.rideRuest[index]['total'].toString(),
                            //         style: GoogleFonts.manrope(
                            //             color:
                            //                 !isDark ? kSecondaryColor : kWhite),
                            //       ),
                            //     ],
                            //   ),
                            //   trailing: Icon(
                            //     Icons.arrow_forward_ios_sharp,
                            //     color: !isDark ? kSecondaryColor : kWhite,
                            //   ),
                            //   // Add more widgets to display additional information
                            // ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 100.0,
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   margin: const EdgeInsets.only(
          //     top: 135.0,
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Container(
          //         height: 128,
          //         width: 128,
          //         decoration: BoxDecoration(
          //             color: kWhite, borderRadius: BorderRadius.circular(100)),
          //         child: Image.asset(
          //           'assets/icons/logo.png',
          //           scale: 1.0,
          //         ),
          //       )
          //     ],
          //   ),
          // ),
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
      showToastShort('Ride Accepted', kPrimaryGreen);
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
