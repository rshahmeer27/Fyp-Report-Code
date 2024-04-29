// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, sized_box_for_whitespace, depend_on_referenced_packages
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/mobileTopupScreen.dart';
import 'package:skoop/screens/user/withdrawScreen.dart';

// import 'package:stripe_payment/stripe_payment.dart';

import '../../../constant.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  Map<String, dynamic>? paymentIntentData;
  Future<dynamic> getProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/customer/');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      print('userData');
      // walletAmount = userData['restaurant']['balance'];
      return userData['customer']['balance'];
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  Future<List<Map<String, dynamic>>> getPastOrders() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$port/past-orders');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<Map<String, dynamic>> activeOrders =
          List<Map<String, dynamic>>.from(responseData['pastOrders']);
      return activeOrders;
    } else {
      throw Exception('Failed to fetch active orders');
    }
  }

  Future<Map<String, dynamic>> getItem(var foodId) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    // var id = sp.getString('id').toString();
    final url = Uri.parse('$port/get-singlefooditem/$foodId');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      return userData;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const CartScreen()),
              // );
            }),
        title: Text(
          'Wallet',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 32.w),
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: 26.h,
              ),
              FutureBuilder(
                future: getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      width: 328.w,
                      height: 128.h,
                      decoration: BoxDecoration(
                        color: kSecondaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.only(left: 21),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total Balance',
                            style: GoogleFonts.manrope(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                              color: kBalance,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: '\$ ${snapshot.data.toString()}',
                              style: GoogleFonts.manrope(
                                  fontSize: 36.sp,
                                  fontWeight: FontWeight.w700,
                                  color: kWhite), // default text style
                              children: [
                                TextSpan(
                                  text: '.00',
                                  style: GoogleFonts.manrope(
                                      fontSize: 24.sp,
                                      fontWeight: FontWeight.w400,
                                      color: kWhite),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    // An error occurred while fetching user data
                    return Text('Error: ${snapshot.error}');
                  }

                  // Data is still loading
                  return const Center(
                      child: CircularProgressIndicator(
                    color: kPrimaryGreen,
                  ));
                },
              ),
              SizedBox(
                height: 18.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      addPrice(context);
                      // await makePayment();
                      // addPrice(context);
                    },
                    child: Container(
                      width: 97.w,
                      height: 97.h,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/deposit.png',
                            width: 32.w,
                            height: 38.h,
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            'Deposit',
                            style: GoogleFonts.manrope(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: kSupportiveGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const MobileTopUpScreen()));
                    },
                    child: Container(
                      width: 97.w,
                      height: 97.h,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/mobileTopup.png',
                            width: 32.w,
                            height: 38.h,
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            'Mobile Top Up',
                            style: GoogleFonts.manrope(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: kSupportiveGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WithdrawScreen()));
                    },
                    child: Container(
                      width: 97.w,
                      height: 97.h,
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/withdraw.png',
                            width: 32.w,
                            height: 38.h,
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          Text(
                            'Withdraw',
                            style: GoogleFonts.manrope(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: kSupportiveGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              Container(
                margin: EdgeInsets.only(left: 31.w, right: 33.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Latest Transactions',
                      style: GoogleFonts.manrope(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                    Text(
                      'See all',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w500,
                        fontSize: 14.sp,
                        color: kSupportiveGrey2,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 19.h,
              ),
              SizedBox(
                height: 300,
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getPastOrders(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No orders available.'));
                    } else {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final order = snapshot.data![index];
                          final foodItems = order['foodItems'] as List<dynamic>;
                          final firstFoodItem = foodItems[0]['item'];

                          return FutureBuilder<Map<String, dynamic>>(
                            future: getItem(firstFoodItem),
                            builder: (context, foodItemSnapshot) {
                              if (foodItemSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (foodItemSnapshot.hasError) {
                                return Text('Error: ${foodItemSnapshot.error}');
                              } else if (!foodItemSnapshot.hasData) {
                                return const Text('Food item not found.');
                              } else {
                                final foodItemData = foodItemSnapshot.data!;
                                final image =
                                    stringToUint8List(foodItemData['image']);
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 100.h,
                                      width: 329.w,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            child: Image.memory(
                                              image,
                                              width: 63.w,
                                              height: 52.h,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 9.w,
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Text(
                                                foodItemData['name'],
                                                style: GoogleFonts.manrope(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w800,
                                                  color: !isDark
                                                      ? kSecondaryColor
                                                      : kSupportiveGrey,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 3.h,
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '1 day ago',
                                                    style: GoogleFonts.manrope(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 12.sp,
                                                      color: kSupportiveGrey,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          Text(
                                            '\$ ${order['total']}',
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16.sp,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kSupportiveGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(
                                      indent: 30.0,
                                      endIndent: 30.0,
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      // bottomSheet: Container(
      //   height: 202.h,
      //   width: 390.w,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.only(
      //       topLeft: Radius.circular(30.r),
      //       topRight: Radius.circular(30.r),
      //     ),
      //     boxShadow: const [
      //       BoxShadow(
      //         color: kBG,
      //         spreadRadius: 20,
      //         blurRadius: 10,
      //         offset: Offset(0, 0), // changes position of shadow
      //       ),
      //     ],
      //   ),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       SizedBox(
      //         height: 25.h,
      //       ),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Column(
      //             mainAxisAlignment: MainAxisAlignment.start,
      //             children: [
      //               Text(
      //                 '\$',
      //                 style: GoogleFonts.manrope(
      //                   fontWeight: FontWeight.w800,
      //                   fontSize: 22.sp,
      //                   color: kSecondaryColor,
      //                 ),
      //               ),
      //             ],
      //           ),
      //           Text(
      //             '62.00',
      //             style: GoogleFonts.manrope(
      //               fontWeight: FontWeight.w800,
      //               fontSize: 30.sp,
      //               color: kSecondaryColor,
      //             ),
      //           )
      //         ],
      //       ),
      //       Text(
      //         '2 Items',
      //         style: GoogleFonts.manrope(
      //           fontSize: 15.sp,
      //           fontWeight: FontWeight.w600,
      //           color: kSupportiveGrey,
      //         ),
      //       ),
      //       GestureDetector(
      //           child: Container(
      //             width: 326.w,
      //             height: 50.h,
      //             decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(10.r),
      //               color: kPrimaryGreen,
      //             ),
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 Image.asset(
      //                   'assets/icons/cart_icon.png',
      //                   width: 25.w,
      //                   height: 26.h,
      //                 ),
      //                 SizedBox(
      //                   width: 14.w,
      //                 ),
      //                 Text(
      //                   'Check Out',
      //                   style: GoogleFonts.manrope(
      //                     fontSize: 17.sp,
      //                     fontWeight: FontWeight.w700,
      //                     color: kWhite,
      //                   ),
      //                 )
      //               ],
      //             ),
      //           ),
      //
      //           // Within the `FirstRoute` widget
      //           onTap: () {
      //             // Navigator.push(
      //             //   context,
      //             //   MaterialPageRoute(
      //             //       builder: (context) => const CheckOutScreen()),
      //             // );
      //           }),
      //       SizedBox(
      //         height: 20.h,
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  TextEditingController priceController = TextEditingController();
  addPrice(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Enter Deposit Amount',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: TextFormField(
              controller: priceController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff000000),
                // height: 22.h
              ),
              decoration: InputDecoration(
                labelText: 'Ammount',
                labelStyle: GoogleFonts.nunitoSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff000000),
                  // height: 22.h
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Continue'),
                onPressed: () async {
                  // StripePaymentModule stripe = StripePaymentModule();
                  // stripe.initialize();
                  makePayment(priceController.text);
                  // updateWallet(double.parse(priceController.text));
                  // await makePayment(priceController.text);
                  // makeStripePayment(context);
                },
              )
            ],
          );
        });
  }

  Future<void> makePayment(String ammount) async {
    try {
      paymentIntentData =
          await createPaymentIntent(ammount); //json.decode(response.body);
      // print('Response body==>${response.body.toString()}');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  setupIntentClientSecret: secretKey,
                  paymentIntentClientSecret:
                      paymentIntentData!['client_secret'],
                  //applePay: PaymentSheetApplePay.,
                  //googlePay: true,
                  //testEnv: true,
                  customFlow: true,
                  style: ThemeMode.dark,
                  // merchantCountryCode: 'US',
                  merchantDisplayName: 'Spencer Steinbrecher'))
          .then((value) {});

      ///now finally display payment sheeet
      displayPaymentSheet(ammount);
    } catch (e, s) {
      print('Payment exception:$e$s');
    }
  }

  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance
          .presentPaymentSheet(
              //       parameters: PresentPaymentSheetParameters(
              // clientSecret: paymentIntentData!['client_secret'],
              // confirmPayment: true,
              // )
              )
          .then((newValue) {
        print('payment intent' + paymentIntentData!['id'].toString());
        print(
            'payment intent' + paymentIntentData!['client_secret'].toString());
        print('payment intent' + paymentIntentData!['amount'].toString());
        print('payment intent' + paymentIntentData.toString());
        //orderPlaceApi(paymentIntentData!['id'].toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("paid successfully")));
        double am = double.parse(amount);
        updateWallet(am).whenComplete(() => Navigator.pop(context));
        // showTo('',kPrimaryGreen);
        // var uid = FirebaseAuth.instance.currentUser!.uid;
        // var expireDate = isSelected == 1
        //     ? calculatePackageExpirationDate('monthly')
        //     : calculatePackageExpirationDate('yearly');
        // print('expireDate');
        // print(expireDate);
        //
        // ///add that info to firebase
        // FirebaseFirestore.instance.collection('users').doc(uid).update({
        //   'paymentDate': DateTime.now().toIso8601String().substring(0, 10),
        //   // 'subscriptionType': amount == '35' ? 'Monthly' : 'Yearly',
        //   'subscribed': true,
        //   'expireOn': expireDate,
        // }).whenComplete(() {
        //   Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute(
        //         builder: (context) => const PersonalityFormScreen()),
        //   );
        // });

        paymentIntentData = null;
      }).onError((error, stackTrace) {
        print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
      });
    } on StripeException catch (e) {
      print('Exception/DISPLAYPAYMENTSHEET==> $e');
      showDialog(
          context: context,
          builder: (_) => const AlertDialog(
                content: Text("Cancelled "),
              ));
    } catch (e) {
      print('$e');
    }
  }

  //  Future<Map<String, dynamic>>
  createPaymentIntent(String amount) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': 'USD',
        'payment_method_types[]': 'card',
      };
      print(body);
      var response = await http.post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': 'Bearer $secretKey',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      print('Create Intent reponse ===> ${response.body.toString()}');

      return jsonDecode(response.body);
    } catch (err) {
      print('err charging user: ${err.toString()}');
    }
  }
  // Future<void> makePayment() async {
  //   try {
  //     paymentIntentData =
  //         await createPaymentIntent('20', 'USD'); //json.decode(response.body);
  //     // print('Response body==>${response.body.toString()}');
  //     await Stripe.instance
  //         .initPaymentSheet(
  //             paymentSheetParameters: SetupPaymentSheetParameters(
  //                 setupIntentClientSecret: secretKey,
  //                 paymentIntentClientSecret:
  //                     paymentIntentData!['client_secret'],
  //                 //applePay: PaymentSheetApplePay.,
  //                 //googlePay: true,
  //                 //testEnv: true,
  //                 customFlow: true,
  //                 style: ThemeMode.dark,
  //                 // merchantCountryCode: 'US',
  //                 merchantDisplayName: 'Kashif'))
  //         .then((value) {});
  //
  //     ///now finally display payment sheeet
  //     displayPaymentSheet();
  //   } catch (e, s) {
  //     print('Payment exception:$e$s');
  //   }
  // }
  //
  // displayPaymentSheet() async {
  //   try {
  //     await Stripe.instance
  //         .presentPaymentSheet(
  //             //       parameters: PresentPaymentSheetParameters(
  //             // clientSecret: paymentIntentData!['client_secret'],
  //             // confirmPayment: true,
  //             // )
  //             )
  //         .then((newValue) {
  //       print('payment intent' + paymentIntentData!['id'].toString());
  //       print(
  //           'payment intent' + paymentIntentData!['client_secret'].toString());
  //       print('payment intent' + paymentIntentData!['amount'].toString());
  //       print('payment intent' + paymentIntentData.toString());
  //       //orderPlaceApi(paymentIntentData!['id'].toString());
  //       ScaffoldMessenger.of(context)
  //           .showSnackBar(const SnackBar(content: Text("paid successfully")));
  //
  //       paymentIntentData = null;
  //     }).onError((error, stackTrace) {
  //       print('Exception/DISPLAYPAYMENTSHEET==> $error $stackTrace');
  //     });
  //   } on StripeException catch (e) {
  //     print('Exception/DISPLAYPAYMENTSHEET==> $e');
  //     showDialog(
  //         context: context,
  //         builder: (_) => const AlertDialog(
  //               content: Text("Cancelled "),
  //             ));
  //   } catch (e) {
  //     print('$e');
  //   }
  // }
  //
  // //  Future<Map<String, dynamic>>
  // createPaymentIntent(String amount, String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': calculateAmount('20'),
  //       'currency': currency,
  //       'payment_method_types[]': 'card',
  //     };
  //     print(body);
  //     var response = await http.post(
  //         Uri.parse('https://api.stripe.com/v1/payment_intents'),
  //         body: body,
  //         headers: {
  //           'Authorization': 'Bearer $secretKey',
  //           'Content-Type': 'application/x-www-form-urlencoded'
  //         });
  //     print('Create Intent reponse ===> ${response.body.toString()}');
  //     return jsonDecode(response.body);
  //   } catch (err) {
  //     print('err charging user: ${err.toString()}');
  //   }
  // }

  // calculateAmount(String amount) {
  //   final a = (int.parse(amount)) * 100;
  //   return a.toString();
  // }

  Future<void> updateWallet(double amount) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final Uri uri = Uri.parse('$port/update-wallet');

    final response = await http.patch(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'amount': amount}),
    );

    if (response.statusCode == 204) {
      print('Wallet updated successfully');
    } else {
      print('Failed to update wallet: ${response.statusCode}');
    }
  }
}
