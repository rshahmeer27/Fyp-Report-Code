import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant.dart';
import 'checkOutDelivery.dart';
import 'checkOutSelfPick.dart';

class CheckOutScreen extends StatefulWidget {
  var cartItemList;
  var price;
  CheckOutScreen(this.cartItemList, this.price);

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kBG,
          elevation: 0,
          leading: GestureDetector(
              child: Icon(
                Icons.arrow_back_ios,
                size: 25.w,
                color: !isDark ? kSecondaryColor : kSupportiveGrey,
              ),

              // Within the `FirstRoute` widget
              onTap: () {
                Navigator.pop(context);
              }),
          title: Row(
            children: [
              SizedBox(
                width: 80.w,
              ),
              Text(
                'Check out',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 22.sp,
                  color: !isDark ? kSecondaryColor : kSupportiveGrey,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: isDark ? kDarkBg : kBG,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TabBar(unselectedLabelColor: kSupportiveGrey, tabs: [
                Tab(
                  child: Text(
                    'Delivery',
                    style: GoogleFonts.manrope(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: !isDark ? kSecondaryColor : kSupportiveGrey,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'Self Picking',
                    style: GoogleFonts.manrope(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                      color: !isDark ? kSecondaryColor : kSupportiveGrey,
                    ),
                  ),
                ),
              ]),
              Expanded(
                child: TabBarView(
                  children: [
                    CheckOutD(widget.cartItemList, widget.price),
                    CheckOutS(widget.cartItemList, widget.price),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
