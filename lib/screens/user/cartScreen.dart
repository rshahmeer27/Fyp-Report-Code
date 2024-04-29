// ignore_for_file: prefer_final_fields, prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/widgets/tabBar.dart';
import 'package:skoop/toast.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItemList = [];
  List<Map<String, dynamic>> itemDetails = [];

  ///
  _getCartItemsWithQuantity() {
    for (var item in cartItemList) {
      dynamic itemId = item['_id'];
      itemDetails.add({
        "item": itemId.toString(),
        "quantity": item['quantity'],
        "price": item['price'],
      });
    }

    String jsonString = json.encode(itemDetails);
    // String jsonString = json.encode({"foodItems": itemDetails});
    print('jsonString in function');
    print(jsonString);
    return itemDetails;
  }

  double totalPrice = 0.0;
  // void _updateCartItemsWithQuantity() {
  //   Map<String, dynamic> cartData = _getCartItemsWithQuantity();
  //   List<Map<String, dynamic>> updatedCartItems = cartData['cartItems'];
  //   double updatedTotalPrice = cartData['totalPrice'];
  //
  //   setState(() {
  //     cartItemList = updatedCartItems;
  //     totalPrice = updatedTotalPrice;
  //     print('cartItemList');
  //     print(cartItemList);
  //     print('totalPrice');
  //     print(totalPrice);
  //   });
  // }

  // Future<List<Map<String, dynamic>>> getItemListFromPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final encodedItemList = prefs.getStringList('itemList') ?? [];
  //   final itemList = encodedItemList
  //       .map((item) => Map<String, dynamic>.from(json.decode(item)))
  //       .toList();
  //   return itemList;
  // }
  // Future<List<Map<String, dynamic>>> getItemListFromPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final encodedItemList = prefs.getStringList('itemList1') ?? [];
  //   final itemList = encodedItemList.map((item) => json.decode(item)).toList();
  //   return itemList.cast<Map<String, dynamic>>();
  // }
  Future<List<Map<String, dynamic>>> getItemListFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItemList = prefs.getStringList('itemListCartA') ?? [];
    final itemList = encodedItemList.map((item) => json.decode(item)).toList();
    print('itemList');
    print(itemList);
    return itemList.cast<Map<String, dynamic>>();
  }

  @override
  void initState() {
    super.initState();
    _loadItemList().then((_) {
      totalPrice = _calculateTotalPrice();
    });
    // _updateTotalPrice();
  }

  Future<void> _loadItemList() async {
    final itemList = await getItemListFromPreferences();
    setState(() {
      cartItemList = itemList;
      _updateTotalPrice();
    });
  }

  void removeItemFromList(String itemId) async {
    setState(() {
      cartItemList.removeWhere((item) => item['_id'] == itemId);
    });

    await saveItemList();
  }

  List<Map<String, dynamic>> globalItemDetails = [];

  Future<void> saveItemList() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItemList =
        cartItemList.map((item) => json.encode(item)).toList();
    await prefs.setStringList('itemListCartA', encodedItemList);
    print('encodedItemList');
    print(encodedItemList);
    print('itemList1 sp value');
    print(prefs.getStringList('itemListCartA'));
  }

  var imgg;
  bool isSelected = false;
  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  var selectedItemId;
  Future<List<Map<String, dynamic>>> _cartItemListFuture =
      _getItemListFromPreferences();

  static Future<List<Map<String, dynamic>>>
      _getItemListFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedItemList = prefs.getStringList('itemListCartA') ?? [];
    final itemList = encodedItemList.map((item) => json.decode(item)).toList();
    return itemList.cast<Map<String, dynamic>>();
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
          'Cart',
          style: kAppbarStyle.copyWith(
              color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
        actions: [
          isSelected
              ? Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // removeItemFromList(selectedItemId);
                          // showToastShort('Item Deleted', kRedColor);
                          setState(() {
                            removeItemFromList(selectedItemId);
                            showToastShort('Item Deleted', kRedColor);
                            isSelected = false;
                            selectedItemId = null;
                          });
                        },
                        child: Image.asset(
                          'assets/icons/delete_icon.png',
                          width: 20,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Image.asset(
                        'assets/icons/list_icon.png',
                        width: 25,
                      )
                    ],
                  ),
                )
              : SizedBox(),
        ],
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 32.w),
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: _cartItemListFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final cartItemList = snapshot.data!;
                return ListView.builder(
                  itemCount: cartItemList.length,
                  itemBuilder: (context, index) {
                    final item = cartItemList[index];
                    // final item = cartItemList[index];
                    print('item ddetails');
                    imgg = stringToUint8List(item['image']);
                    return Column(
                      children: [
                        GestureDetector(
                          onLongPress: () {
                            // setState(() {
                            //   if (isSelected) {
                            //     isSelected = false;
                            //     selectedItemId = null;
                            //   } else {
                            //     isSelected = true;
                            //     selectedItemId = item['_id'];
                            //   }
                            // });
                            setState(() {
                              isSelected = true;
                              selectedItemId = item['_id'];
                              print('selectedItemId');
                              print(selectedItemId);
                            });
                          },
                          child: SizedBox(
                            height: 90.h,
                            width: 329.w,
                            child: Card(
                              color: !isDark ? kWhite : kcardColor,
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r)),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.memory(
                                      imgg,
                                      width: 91.w,
                                      height: 74.h,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.w,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Text(item['name'],
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 16.sp,
                                            color: !isDark
                                                ? kSecondaryColor
                                                : kWhite,
                                          )),
                                      SizedBox(
                                        height: 3.h,
                                      ),
                                      Text(
                                        'Espresso Cafe',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600,
                                          color: kSupportiveGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            '\$${item['price']}.00',
                                            style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14.sp,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kPrimaryGreen,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 88.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _decrementItemQuantity(item);
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 2.h),
                                              height: 18.h,
                                              width: 15.w,
                                              decoration: BoxDecoration(
                                                  color: kSupportiveGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.r)),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Icon(
                                                    Icons.minimize,
                                                    color: kWhite,
                                                    size: 10,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                            '${item['quantity']}',
                                            style: GoogleFonts.manrope(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.w500,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kWhite,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _incrementItemQuantity(item);
                                            },
                                            child: Container(
                                              padding:
                                                  EdgeInsets.only(bottom: 2.h),
                                              height: 18.h,
                                              width: 15.w,
                                              decoration: BoxDecoration(
                                                  color: kSupportiveGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25.r)),
                                              child: const Icon(
                                                Icons.add,
                                                color: kWhite,
                                                size: 10,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                      ],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return const Center(
                    child: CircularProgressIndicator(color: kPrimaryGreen));
              }
            },
          ),
        ),
      ),
      bottomSheet: Container(
        height: 202.h,
        width: 390.w,
        decoration: BoxDecoration(
          color: !isDark ? kBG : kcardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          boxShadow: [
            BoxShadow(
              color: kBG,
              spreadRadius: 20,
              blurRadius: 10,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 25.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      '\$',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w800,
                        fontSize: 22.sp,
                        color: !isDark ? kSecondaryColor : kPrimaryGreen,
                      ),
                    ),
                  ],
                ),
                Text(
                  totalPrice.toStringAsFixed(2),
                  style: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    fontSize: 30.sp,
                    color: !isDark ? kSecondaryColor : kWhite,
                  ),
                )
              ],
            ),
            Text(
              '${_calculateTotalItems()} Items',
              style: GoogleFonts.manrope(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: kSupportiveGrey,
              ),
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
                        'assets/icons/cart_icon.png',
                        width: 25.w,
                        height: 26.h,
                      ),
                      SizedBox(
                        width: 14.w,
                      ),
                      Text(
                        'Check Out',
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
                  // _updateCartItemsWithQuantity();
                  // Map<String, dynamic> cartData = _getCartItemsWithQuantity();
                  // List<Map<String, dynamic>> updatedCartItems =
                  //     cartData['cartItems'];
                  // double totalPrice = cartData['totalPrice'];
                  //
                  // // Now you can use the updatedCartItems and totalPrice as needed.
                  // // For example, you can print the updated quantity of the first item:
                  // print('Updated Quantity of First Item: ${updatedCartItems}');
                  //
                  // // Or you can print the total price:
                  // print('Total Price: $totalPrice');
                  print('cartItemList');
                  print(cartItemList);
                  final listOfObjects = _getCartItemsWithQuantity();
                  print('listOfObjects');
                  print(listOfObjects);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckOutScreen(
                            listOfObjects, totalPrice.toStringAsFixed(2))),
                  );
                }),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }

  int _calculateTotalItems() {
    int totalItems = 0;
    for (var item in cartItemList) {
      totalItems += item['quantity'] as int;
    }
    return totalItems;
  }

  double _calculateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in cartItemList) {
      totalPrice += item['price'] * item['quantity'];
    }
    return totalPrice;
  }

  void _incrementItemQuantity(Map<String, dynamic> item) {
    setState(() {
      item['quantity']++; // Increase the quantity by 1
      totalPrice += item['price']; // Add the item price to the total price
    });
    saveItemList(); // Save the updated cart items to SharedPreferences
  }

  void _decrementItemQuantity(Map<String, dynamic> item) {
    setState(() {
      if (item['quantity'] > 1) {
        item[
            'quantity']--; // Decrease the quantity by 1, but keep it at least 1
        totalPrice -=
            item['price']; // Deduct the item price from the total price
      }
    });
    saveItemList(); // Save the updated cart items to SharedPreferences
  }

  void _updateTotalPrice() {
    double totalPrice = 0.0;
    for (var item in cartItemList) {
      totalPrice += item['price'] * item['quantity'];
    }
    setState(() {
      this.totalPrice = totalPrice;
    });
  }
}
