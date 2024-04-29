// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';

import '../conversationScreen.dart';
import '../favouriteScreen.dart';
import '../home/homeScreen.dart';
import '../orderScreen.dart';

class bottomNavigationBar extends StatefulWidget {
  const bottomNavigationBar({Key, key}) : super(key: key);

  // final RouteLogin=true;
  @override
  bottomNavigationBarState createState() => bottomNavigationBarState();
}

class bottomNavigationBarState extends State<bottomNavigationBar> {
  getProfile() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var token = sp.getString('token').toString();
      final url = Uri.parse('$port/customer/');
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        // Parse the response body to extract the user data
        final userData = json.decode(response.body);
        user = userData;
        print('user email');
        print(userData['customer']['email']);
        // Return the user object
        // return user;
      } else {
        print('response.statusCode');
        print(response.statusCode);
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('error is :${e.toString()}');
    }
  }

  var user;
  var smallHeading = 15.0;
  var largeHeading = 20.0;
  static var selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    // OrderScreen(),

    HomeScreen(),
    ConversationScreen(),
    FavouriteScreen(),
    OrderScreen(),
  ];

  void initState() {
    // TODO: implement initState
    // changeLoginStatus();
    super.initState();
    getProfile();
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
              BottomNavigationBarItem(
                icon: selectedIndex == 2
                    ? Image.asset(
                        'assets/navbar/favouriteS.png',
                        width: 40,
                      )
                    : Image.asset(
                        'assets/navbar/favouriteU.png',
                        width: 28,
                      ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: selectedIndex == 3
                    ? Image.asset(
                        'assets/navbar/orderS.png',
                        width: 40,
                      )
                    : Image.asset(
                        'assets/navbar/orderU.png',
                        width: 25,
                      ),
                label: "",
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
