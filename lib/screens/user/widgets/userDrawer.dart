// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// getDrawer(BuildContext context) {
//   bool isChecked = false;
//   bool isSelected = false;
//   return Drawer(
//     backgroundColor: kBG,
//     child: Container(
//       height: MediaQuery.of(context).size.height,
//       padding: const EdgeInsets.symmetric(horizontal: 12.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           // mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(
//               height: 50.0,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 18.0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 // crossAxisAlignment: start,
//                 children: [
//                   Image.asset(
//                     'assets/images/profile.png',
//                     scale: 2.0,
//                   ),
//                   SizedBox(
//                     width: 10.0,
//                   ),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Mikel Gozha',
//                         style: GoogleFonts.manrope(
//                             fontSize: 18.sp,
//                             fontWeight: FontWeight.w700,
//                             color: kSecondaryColor),
//                       ),
//                       SizedBox(
//                         height: 5.0,
//                       ),
//                       Text(
//                         '\$110.4',
//                         style: GoogleFonts.manrope(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w700,
//                             color: kSupportiveGrey),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 10.0,
//             ),
//             ListTile(
//               title: Text("Skooper Mode",
//                   style: GoogleFonts.manrope(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w700,
//                       color: kSecondaryColor)),
//               trailing: SizedBox(
//                 width: 30.0,
//                 child: Switch(
//                   // activeTrackColor: Colors.pink,
//                   inactiveThumbColor: Colors.black,
//                   activeColor: Colors.green,
//                   // thumbColor: kSupportiveGrey,
//                   value: isChecked,
//                   onChanged: (bool value) {
//                     // setState(() {
//                     isChecked = value;
//                     // });
//                   },
//                 ),
//               ),
//             ),
//             Divider(
//               height: 0.0,
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height,
//               child: ListView(
//                 shrinkWrap: true,
//                 physics: BouncingScrollPhysics(),
//                 children: <Widget>[
//                   DrawerBar(
//                       isSelected: false,
//                       text: 'Profile',
//                       img: 'assets/icons/user.png',
//                       tileColor: kBG,
//                       textColor: kSecondaryColor,
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => ProfileScreen()));
//                       }),
//                   DrawerBar(
//                       isSelected: false,
//                       text: 'Location',
//                       img: 'assets/icons/location.png',
//                       tileColor: kPrimaryGreen.withOpacity(0.15),
//                       textColor: kPrimaryGreen,
//                       onTap: () {}),
//                   DrawerBar(
//                       isSelected: false,
//                       text: 'Wallet',
//                       img: 'assets/icons/wallet.png',
//                       tileColor: kBG,
//                       textColor: kSecondaryColor,
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => WalletScreen()));
//                       }),
//                   Container(
//                     height: 55.h,
//                     padding: EdgeInsets.symmetric(horizontal: 2.0),
//                     margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
//                     child: ListTile(
//                       minVerticalPadding: 10,
//                       horizontalTitleGap: 2,
//                       leading: Image.asset(
//                         'assets/icons/darkMode.png',
//                         scale: 1.6,
//                       ),
//                       title: Text(
//                         "Dark Mode",
//                         style: GoogleFonts.manrope(
//                             fontSize: 15.sp,
//                             fontWeight: FontWeight.w700,
//                             color: kSecondaryColor),
//                       ),
//                       trailing: SizedBox(
//                         width: 30.0,
//                         child: Switch(
//                           // activeTrackColor: Colors.pink,
//                           inactiveThumbColor: Colors.black,
//                           activeColor: kPrimaryGreen,
//                           // thumbColor: kSupportiveGrey,
//                           value: isDark,
//                           onChanged: (bool value) {
//                             setState(() {
//                               isDark = value;
//                             });
//                           },
//                         ),
//                       ),
//                       // trailing: Icon(Icons.arrow_forward),
//                     ),
//                   ),
//                   DrawerBar(
//                       isSelected: false,
//                       text: 'Help and Feedback',
//                       img: 'assets/icons/help.png',
//                       tileColor: kBG,
//                       textColor: kSecondaryColor,
//                       onTap: () {}),
//                   DrawerBar(
//                       isSelected: false,
//                       text: 'Settings',
//                       img: 'assets/icons/settings.png',
//                       tileColor: kBG,
//                       textColor: kSecondaryColor,
//                       onTap: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (_) => SettingScreen()));
//                       }),
//                   DrawerBar(
//                       isSelected: false,
//                       text: 'Sign Out',
//                       img: 'assets/icons/logout.png',
//                       tileColor: kBG,
//                       textColor: kSecondaryColor,
//                       onTap: () {}),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }

Widget DrawerBar(
    {required bool isSelected,
    required String text,
    required String img,
    required Color tileColor,
    required Color textColor,
    required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50.h,
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: tileColor, borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(
            img,
            scale: 1.6,
          ),
          SizedBox(
            width: 20.w,
          ),
          Text(text,
              style: GoogleFonts.manrope(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: textColor)),
        ],
      ),
    ),
  );
}
