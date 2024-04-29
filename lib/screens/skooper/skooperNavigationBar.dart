// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:skoop/constant.dart';
import 'package:skoop/screens/skooper/skooperHomeScreen.dart';

import '../user/conversationScreen.dart';

class SkooperBottomNavigationBar extends StatefulWidget {
  const SkooperBottomNavigationBar({Key, key}) : super(key: key);

  // final RouteLogin=true;
  @override
  SkooperBottomNavigationBarState createState() =>
      SkooperBottomNavigationBarState();
}

class SkooperBottomNavigationBarState
    extends State<SkooperBottomNavigationBar> {
  @override
  var smallHeading = 15.0;
  var largeHeading = 20.0;
  static var selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    SkooperHomeScreen(),
    ConversationScreen(),
  ];

  void initState() {
    // TODO: implement initState
    // changeLoginStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: kBG,
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: Container(
      //   height: 70.h,
      //   width: 70.w,
      //   child: Image.asset('assets/images/home.png'),
      //   decoration: BoxDecoration(
      //       color: Color(0xffE99A25), borderRadius: BorderRadius.circular(20)),
      // ),
      bottomNavigationBar: Container(
        height: 105,

        // color: Colors.black,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: const [
            BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomNavigationBar(
            backgroundColor: kPrimaryGreen,
            type: BottomNavigationBarType.fixed,
            landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
            showUnselectedLabels: false,
            showSelectedLabels: false,
            unselectedItemColor: Color(0xff40C165).withOpacity(0.4),
            selectedItemColor: Color(0xff40C165),
            onTap: _onTap,
            currentIndex: selectedIndex,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                label: '',
                icon: selectedIndex == 0
                    ? Image.asset(
                        'assets/navbar/homeS.png',
                        width: 40,
                      )
                    : Image.asset(
                        'assets/navbar/homeU.png',
                        width: 28,
                      ),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: selectedIndex == 1
                    ? Image.asset(
                        'assets/navbar/chatS.png',
                        width: 40,
                      )
                    : Image.asset(
                        'assets/navbar/chatU.png',
                        width: 28,
                      ),
                // label: "Basket"
              ),
            ],
          ),
        ),
      ),
      body: _widgetOptions.elementAt(selectedIndex),
    );
  }

  void _onTap(int index) {
    selectedIndex = index;
    setState(() {});
  }
}
