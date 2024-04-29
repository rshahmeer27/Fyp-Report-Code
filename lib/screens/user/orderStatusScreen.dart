import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/models/active_orders_model.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';
import 'package:skoop/screens/user/widgets/navBar.dart';

import '../../toast.dart';

class OrderStatusScreen extends StatefulWidget {
  var order, restId;
  OrderStatusScreen(this.order, this.restId);

  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  bool isAccepted = false;
  bool isOrderPickup = false;
  bool isCompleted = false;
  getStatus() {
    int status = widget.order is ActiveOrder
        ? widget.order.status
        : widget.order['status'];

    switch (status) {
      case 1:
        isAccepted = true;
        break;
      case 2:
        isAccepted = true;
        isOrderPickup = true;
        break;
      case 3:
        isAccepted = true;
        isOrderPickup = true;
        isCompleted = true;
        break;
      default:
        isAccepted = true;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStatus();
    print(isAccepted);
    print(isOrderPickup);
    print(isCompleted);
    // print(isCompleted);
    print('widget.restId');
    print(widget.restId);
    // print(isCompleted);
  }

  @override
  Widget build(BuildContext context) {
    int orderStatus = widget.order is ActiveOrder
        ? widget.order.status
        : widget.order['status'];
    print('orderStatus');
    print(orderStatus);
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBG,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: 2,
                borderRadius: const BorderRadius.all(Radius.circular(35)),
                child: Container(
                  height: 187.h,
                  width: 390.w,
                  decoration: BoxDecoration(
                      color: !isDark ? kWhite : kcardColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(35.0),
                        bottomRight: Radius.circular(35.0),
                      )),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios,
                                color: kSecondaryColor,
                              ),
                              // Within the `FirstRoute` widget
                              onPressed: () {
                                widget.order is ActiveOrder
                                    ? Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const bottomNavigationBar()),
                                        (route) => false)
                                    : Navigator.pop(context);
                              }),
                          SizedBox(
                            width: 80.w,
                          ),
                          Text(
                            'Order Status',
                            style: kAppbarStyle,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Estimated Time',
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kSupportiveGrey,
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                '30 minutes',
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'Order Number',
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kSupportiveGrey,
                                ),
                              ),
                              SizedBox(
                                height: 3.h,
                              ),
                              Text(
                                '#${widget.order is ActiveOrder ? widget.order.id : widget.order['_id']}',
                                style: GoogleFonts.manrope(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: kSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 47.h,
              ),
              Padding(
                padding: EdgeInsets.only(left: 32.w),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ///order Accepted
                    Row(
                      children: [
                        orderStatus == 0 ||
                                orderStatus == 1 ||
                                orderStatus == 2 ||
                                orderStatus == 3
                            ? Image.asset(
                                'assets/icons/tickIcon.png',
                                width: 38,
                                height: 38,
                              )
                            : Image.asset(
                                'assets/icons/greyTick.png',
                                width: 38,
                                height: 38,
                              ),
                        SizedBox(
                          width: 13.w,
                        ),
                        Text(
                          'Order Accepted',
                          style: GoogleFonts.manrope(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7.h,
                    ),

                    ///order prepared
                    Container(
                      margin: const EdgeInsets.only(right: 290.0),
                      width: 5.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          color: orderStatus == 1 ||
                                  orderStatus == 2 ||
                                  orderStatus == 3
                              ? kPrimaryGreen
                              : kSupportiveGrey,
                          borderRadius: BorderRadius.circular(50.r)),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Row(
                      children: [
                        orderStatus == 1 || orderStatus == 2 || orderStatus == 3
                            ? Image.asset(
                                'assets/icons/tickIcon.png',
                                width: 38,
                                height: 38,
                              )
                            : Image.asset(
                                'assets/icons/greyTick.png',
                                width: 38,
                                height: 38,
                              ),
                        SizedBox(
                          width: 13.w,
                        ),
                        Text(
                          'Order Prepared',
                          style: GoogleFonts.manrope(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7.h,
                    ),

                    ///orderPicked up
                    Container(
                      margin: const EdgeInsets.only(right: 290.0),
                      width: 5.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          color: orderStatus == 2 || orderStatus == 3
                              ? kPrimaryGreen
                              : kSupportiveGrey,
                          borderRadius: BorderRadius.circular(50.r)),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Row(
                      children: [
                        orderStatus == 2 || orderStatus == 3
                            ? Image.asset(
                                'assets/icons/tickIcon.png',
                                width: 38,
                                height: 38,
                              )
                            : Image.asset(
                                'assets/icons/greyTick.png',
                                width: 38,
                                height: 38,
                              ),
                        SizedBox(
                          width: 13.w,
                        ),
                        Text(
                          'Order Picked by Skooper',
                          style: GoogleFonts.manrope(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 7.h,
                    ),

                    ///order completed
                    Container(
                      margin: const EdgeInsets.only(right: 290.0),
                      width: 5.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                          color: orderStatus == 3
                              ? kPrimaryGreen
                              : kSupportiveGrey,
                          borderRadius: BorderRadius.circular(50.r)),
                    ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Row(
                      children: [
                        orderStatus == 3
                            ? Image.asset(
                                'assets/icons/tickIcon.png',
                                width: 38,
                                height: 38,
                              )
                            : Image.asset(
                                'assets/icons/greyTick.png',
                                width: 38,
                                height: 38,
                              ),
                        SizedBox(
                          width: 13.w,
                        ),
                        Text(
                          'Order Arrived',
                          style: GoogleFonts.manrope(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: kSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomSheet: Container(
          height: 100.0,
          color: !isDark ? kWhite : kcardColor,
          child: Center(
            child: Visibility(
              visible: orderStatus == 3,
              child: Column(
                children: [
                  getCtaButton(
                      onPress: orderStatus == 3
                          ? () {
                              restaurantReview.text = "";
                              // cancelOrder(context);
                              rateRestaurant(context);
                            }
                          : null,
                      color: orderStatus == 3 ? kPrimaryGreen : kGreyTextColor,
                      text: 'Rate Restaurant'),
                  const SizedBox(
                    height: 5,
                  ),
                  orderStatus == 1
                      ? const SizedBox()
                      : getCtaButton(
                          onPress: () {
                            // cancelOrder(context);
                            rateSkooper(context);
                          },
                          color:
                              orderStatus == 3 ? kPrimaryGreen : kGreyTextColor,
                          text: 'Rate Skooper'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> rateSkooper(BuildContext context) async {
    restaurantReview.text = "";
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBG,
          title: Column(
            children: [
              Text(
                'Your opinion matters to us!',
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
                // Text(
                //   'Rate our skooper',
                //   style: GoogleFonts.manrope(
                //     fontSize: 15.sp,
                //     fontWeight: FontWeight.w600,
                //     color: kSupportiveGrey,
                //   ),
                // ),
                // SizedBox(
                //   height: 16.h,
                // ),
                // RatingBar.builder(
                //   initialRating: 3,
                //   minRating: 1,
                //   direction: Axis.horizontal,
                //   allowHalfRating: false,
                //   itemCount: 5,
                //   itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                //   itemBuilder: (context, _) => const Icon(
                //     Icons.star,
                //     color: Colors.amber,
                //     size: 15,
                //   ),
                //   onRatingUpdate: (rating) {
                //     print(rating);
                //     rating1 = rating;
                //     print('rating1');
                //     print(rating1);
                //   },
                // ),
                SizedBox(
                  height: 16.h,
                ),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    // margin: EdgeInsets.only(right: 7.w),
                    width: MediaQuery.of(context).size.width * 0.89,
                    height: 109.h,
                    decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: TextField(
                      controller: restaurantReview,
                      style: kFieldStyle,
                      decoration: InputDecoration(
                        fillColor: kWhite,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        // enabledBorder: OutlineInputBorder,
                        hintText: 'Leave a message (Optional)',
                        hintStyle: kFieldStyle,
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
                        'Submit',
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
                  addSkooperReview(
                      message: restaurantReview.text,
                      // rating: rating1!,
                      orderId: widget.order is ActiveOrder
                          ? widget.order.id
                          : widget.order['_id']);
                }),
            GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 46.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: kBG,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Maybe latter',
                        style: GoogleFonts.manrope(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: kSupportiveGrey,
                        ),
                      )
                    ],
                  ),
                ),

                // Within the `FirstRoute` widget
                onTap: () {
                  Navigator.pop(context);
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

  double? rating1;
  TextEditingController restaurantReview = TextEditingController();
  Future<void> rateRestaurant(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBG,
          title: Column(
            children: [
              Text(
                'Your opinion matters to us!',
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
                Image.asset(
                  'assets/images/restaurantLogo.png',
                  width: 110.0,
                ),
                SizedBox(
                  height: 7.h,
                ),
                Text(
                  widget.restId['restaurant_name'],
                  style: GoogleFonts.manrope(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: kSecondaryColor,
                  ),
                ),
                SizedBox(
                  height: 16.h,
                ),

                ///stars
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: const [
                //     Icon(
                //       Icons.star,
                //       color: kPrimaryGreen,
                //       size: 30.0,
                //     ),
                //     Icon(
                //       Icons.star,
                //       color: kPrimaryGreen,
                //       size: 30.0,
                //     ),
                //     Icon(
                //       Icons.star,
                //       color: kPrimaryGreen,
                //       size: 30.0,
                //     ),
                //     Icon(
                //       Icons.star,
                //       color: kPrimaryGreen,
                //       size: 30.0,
                //     ),
                //     Icon(
                //       Icons.star_border,
                //       color: kPrimaryGreen,
                //       size: 30.0,
                //     ),
                //   ],
                // ),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                    size: 15,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                    rating1 = rating;
                    print('rating1');
                    print(rating1);
                  },
                ),
                SizedBox(
                  height: 16.h,
                ),
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    // margin: EdgeInsets.only(right: 7.w),
                    width: MediaQuery.of(context).size.width * 0.89,
                    height: 109.h,
                    decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: TextField(
                      controller: restaurantReview,
                      style: kFieldStyle,
                      decoration: InputDecoration(
                        fillColor: kWhite,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        // enabledBorder: OutlineInputBorder,
                        hintText: 'Leave a message (Optional)',
                        hintStyle: kFieldStyle,
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
                        'Submit',
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
                  addReviewRestaurant(
                      message: restaurantReview.text,
                      restaurantId: widget.restId['_id'],
                      stars: rating1!,
                      orderId: widget.order is ActiveOrder
                          ? widget.order.id
                          : widget.order['_id']);
                }),
            GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 46.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: kBG,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Maybe latter',
                        style: GoogleFonts.manrope(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                          color: kSupportiveGrey,
                        ),
                      )
                    ],
                  ),
                ),

                // Within the `FirstRoute` widget
                onTap: () {
                  Navigator.pop(context);
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

  Future<void> addSkooperReview({
    required String orderId,
    // required double rating,
    required String message,
  }) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    // try{
    print("Adding Skooper Review");
    var headersList = {'Content-Type': 'application/json'};
    var url = Uri.parse('http://10.0.2.2:8000/analyze_reviews/');

    var body = ["${message}"];

    var req = http.Request('POST', url);
    req.headers.addAll(headersList);
    req.body = json.encode(body);

    var res = await req.send();

    var responsed = await http.Response.fromStream(res);
    final responseData = json.decode(responsed.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final url =
          '$port/addscooperreview/$orderId'; // Replace with your API endpoint
      final headers = {'Authorization': 'Bearer $token'};

      final body = {
        'rating': responseData[0]['rating'].toString(),
        'message': message,
      };

      print("Body " + body.toString());

      final response = await http.patch(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 201) {
        showToastShort('Skooper review added successfully.', kPrimaryGreen);
        Navigator.pop(context);
      } else {
        showToastShort(
            'Failed to add Skooper review. Status code: ${response.statusCode}',
            kRedColor);
      }

      print(responseData.toString());
      print(responseData[0]['rating']);
    } else {
      print(res.reasonPhrase);
    }
  }

  Future<void> addReviewRestaurant({
    required String restaurantId,
    required String message,
    required double stars,
    required String orderId,
  }) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    const url = '$port/add-review/';
    final headers = {'Authorization': 'Bearer $token'};

    final body = {
      'restaurantId': restaurantId,
      'message': message,
      'stars': stars.toString(),
      'orderId': orderId,
    };

    final response = await http.put(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 204) {
      showToastShort('Review added successfully.', kPrimaryGreen);
      Navigator.pop(context);
    } else {
      print('Failed to add review. Status code: ${response.statusCode}');
    }
  }
}
