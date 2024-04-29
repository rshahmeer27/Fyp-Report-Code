import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';
import 'package:skoop/toast.dart';

import '../../../constant.dart';

class AddNewCard extends StatefulWidget {
  const AddNewCard({Key? key}) : super(key: key);

  @override
  State<AddNewCard> createState() => _AddNewCardState();
}

class _AddNewCardState extends State<AddNewCard> {
  // List<Map<String, dynamic>> globalItemDetails = [];
  TextEditingController cardTitle = TextEditingController();
  TextEditingController cardNumber = TextEditingController();
  TextEditingController cvc = TextEditingController();
  TextEditingController expiryDate = TextEditingController();
  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        expiryDate.text = DateFormat('yyyy-MM-dd').format(picked);
        // age = DateTime.now().difference(_selectedDate!).inDays ~/ 365;
      });
    }
  }

  // Future<void> initializeItemDetails() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final encodedItemList = prefs.getStringList('paymentCollection');
  //   if (encodedItemList != null) {
  //     globalItemDetails = encodedItemList
  //         .map((item) => json.decode(item) as Map<String, dynamic>)
  //         .toList();
  //   }
  // }
  postCard() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString('token').toString();
    final id = sp.getString('id').toString();
    print('expiryDate.text');
    print(expiryDate.text);
    final url = Uri.parse('$port/addcard');
    final headers = {'Authorization': 'Bearer $token'};
    final body = {
      'card_title': cardTitle.text.toString(),
      'card_number': cardNumber.text.toString(),
      'cvc': cvc.text.toString(),
      'expiry_date': expiryDate.text.toString(),
      'user': id,
    };
    final response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 201) {
      // Parse the response body to extract the user data
      final featureData = json.decode(response.body);
      // return featureData['addresses'];
      showToastShort('Card Created Successfully', kPrimaryGreen);
      print(featureData);
      Navigator.pop(context);
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch restaurants');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initializeItemDetails();
    // getCardList();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    cardTitle.clear();
    cardNumber.clear();
    cvc.clear();
    expiryDate.clear();
  }

  @override
  Widget build(BuildContext context) {
    bool showHome = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: kBG,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: kSecondaryColor,
            ),
            // Within the `FirstRoute` widget
            onPressed: () {
              Navigator.pop(context);
            }),
        title: Text(
          'Credit/Debit Card',
          style: kAppbarStyle,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          // margin: EdgeInsets.only(left: 32.w),
          decoration: BoxDecoration(
            color: kBG,
          ),
          child: Column(
            children: [
              SizedBox(
                height: 40.h,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
                child: getTextField(
                  hintText: 'Card Title',
                  controller: cardTitle,
                  obsecureText: false,
                  icon: null,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
                child: getTextField(
                  hintText: 'Card Number',
                  controller: cardNumber,
                  obsecureText: false,
                  icon: null,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
                child: getTextField(
                  hintText: 'CVC',
                  controller: cvc,
                  obsecureText: false,
                  icon: null,
                ),
              ),
              SizedBox(
                height: 14.h,
              ),
              // Container(
              //   padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
              //   child: getTextField(
              //     hintText: 'Expiry Date',
              //     controller: expiryDate,
              //     obsecureText: false,
              //     icon: null,
              //   ),
              // ),
              SizedBox(
                height: 50.0,
                width: 300.0,
                child: TextFormField(
                  style: kFieldStyle,
                  readOnly: true,
                  controller: expiryDate,
                  onTap: () => _selectDate(context),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: kWhite,
                    filled: true,
                    labelText: expiryDate.text.isEmpty
                        ? 'Date'
                        : expiryDate.text.substring(0, 10),
                    labelStyle: kFieldStyle,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Visibility(
        visible: !showHome,
        child: Container(
          height: 150.h,
          width: 390.w,
          decoration: BoxDecoration(
            color: kBG,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.r),
              topRight: Radius.circular(30.r),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 25.h,
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
                          'Add',
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
                    if (cardTitle.text.isEmpty ||
                        cardNumber.text.isEmpty ||
                        cvc.text.isEmpty ||
                        expiryDate.text.isEmpty) {
                      showToastShort('Please fill all fields', kRedColor);
                    } else {
                      postCard();
                      // saveItemList().whenComplete(() {
                      //   showToastShort('Card Information saved successfully',
                      //       kPrimaryGreen);
                      //   Navigator.pop(context);
                      // });
                    }
                  }),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Future<void> saveItemList() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   globalItemDetails.add({
  //     'cardTitle': cardTitle.text.toString(),
  //     'cardNumber': cardNumber.text.toString(),
  //     'cvc': cvc.text.toString(),
  //     'expiryDate': expiryDate.text.toString(),
  //   });
  //   final encodedItemList =
  //       globalItemDetails.map((item) => json.encode(item)).toList();
  //   await prefs.setStringList('paymentCollection', encodedItemList);
  //   print('paymentCollection');
  //   print(encodedItemList);
  //   print('paymentCollection sp value');
  //   print(prefs.getStringList('paymentCollection'));
  // }

  // getCardList() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   print('paymentCollection sp value');
  //   print(prefs.getStringList('paymentCollection'));
  // }
}
