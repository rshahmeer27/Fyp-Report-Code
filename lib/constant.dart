import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kPrimaryGreen = Color(0xffFEA900);
const Color kRedColor = Color(0xffFF0000);
const Color kPrimary1 = Color(0xff40C165);
const Color kBalance = Color(0xfff2f2f2);
const Color kInbox = Color(0xffD3D2D2);
Color kBG = const Color(0xffF9F9F9);
Color kDarkBG = const Color(0xff1e1f28);
const Color kWhite = Color(0xffffffff);
const Color kSupportiveGrey = Color(0xffAFAFAF);
const Color kSupportiveGrey2 = Color(0xffb6b2b2);
const Color kcardColor = Color(0xff2A2C36);
Color kSecondaryColor = isDark ? kBG : const Color(0xff48525B);
const Color kDarkBg = Color(0xff1e1f28);
Color kGreyTextColor = const Color(0xff48525B).withOpacity(0.8);
bool isDark = false;
TextStyle kAppbarStyle = GoogleFonts.manrope(
  fontWeight: FontWeight.w700,
  fontSize: 22.sp,
  color: kSecondaryColor,
);
TextStyle kAppbarStyleDark = GoogleFonts.manrope(
  fontWeight: FontWeight.w700,
  fontSize: 22.sp,
  color: kSupportiveGrey,
);
TextStyle kButtonStyle = GoogleFonts.manrope(
  fontWeight: FontWeight.w700,
  fontSize: 17.sp,
  color: kWhite,
);
TextStyle kTitleStyle = GoogleFonts.manrope(
  fontWeight: FontWeight.w700,
  fontSize: 35.sp,
  color: kSecondaryColor,
);
TextStyle kSubTitleStyle = GoogleFonts.manrope(
  fontWeight: FontWeight.w400,
  fontSize: 15.sp,
  color: kGreyTextColor,
);
TextStyle kFieldStyle = GoogleFonts.manrope(
  fontWeight: FontWeight.w500,
  fontSize: 13.sp,
  color: kSupportiveGrey,
);
TextStyle kFieldStyleSec = GoogleFonts.manrope(
  fontWeight: FontWeight.w800,
  fontSize: 15.sp,
  color: kSecondaryColor,
);
TextStyle kFieldStyleSupp = GoogleFonts.manrope(
  fontWeight: FontWeight.w800,
  fontSize: 15.sp,
  color: kSupportiveGrey,
);
TextStyle kOrderComponentStyle = GoogleFonts.manrope(
  fontWeight: FontWeight.w500,
  fontSize: 12.sp,
  color: kWhite,
);
// 192.168.18.41
// 192.168.18.41
const port = 'http://192.168.18.67:4000/customers';
const portSkooper = 'http://192.168.18.67:4000/skooper';
const portChat = 'http://192.168.18.67:4000/chat';
const apiCall = 'http://192.168.18.67:4000/';
const pythonApi = 'http://127.0.0.1:8000/';
// const port =
//     "http://ec2-54-208-226-145.compute-1.amazonaws.com:4000/customers"; //'http://192.168.18.42:4000/customers';
// const apiCall = 'http://ec2-54-208-226-145.compute-1.amazonaws.com:4000/';
// const portSkooper =
//     'http://ec2-54-208-226-145.compute-1.amazonaws.com:4000/skooper'; //'http://192.168.18.42:4000/skooper';
// const portChat = 'http://ec2-54-208-226-145.compute-1.amazonaws.com:4000/chat';
//
const apiKey =
    'pk_test_51NPXRcH0xKBs3Eu5CcSCjyyckBsgl1o9z54Z5ktTT3PMlirbjzE3QKyJ4eWJ45stgKLQODX1V7FYWQXaYItr5cqO00v7GBfeWg';
const secretKey =
    'sk_test_51NPXRcH0xKBs3Eu5RLkuwAcC26dOykLmyzP1vDtEVRxzgNOGLsWYKtCZp2jAuvnCVawzVHRMiuRChfNsxm31ozeV00gRP3uaxR';
// 172.20.10.3
