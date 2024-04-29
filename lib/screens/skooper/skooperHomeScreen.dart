// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, prefer_typing_uninitialized_variables, unrelated_type_equality_checks, prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:image/image.dart' as Im;
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/skooper/termsAndConditionsSkooper.dart';

import '../../../constant.dart';
import '../../toast.dart';
import '../user/login.dart';
import '../user/profileScreen.dart';
import '../user/widgets/navBar.dart';
import '../user/widgets/userDrawer.dart';
import 'accptedOrderSkooper/accpetedSkooperOrdersRequests.dart';
import 'listForOrdersSkooper.dart';

class SkooperHomeScreen extends StatefulWidget {
  const SkooperHomeScreen({Key? key}) : super(key: key);

  @override
  State<SkooperHomeScreen> createState() => _SkooperHomeScreenState();
}

class _SkooperHomeScreenState extends State<SkooperHomeScreen> {
  Future<void> updateLocation(double latitude, double longitude) async {
    final location = Location();

    try {
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;
      LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          // Handle service not enabled error
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          // Handle permission denied error
          return;
        }
      }

      _locationData = await location.getLocation();

      final patchUrl = '$port/add-location';
      SharedPreferences sp = await SharedPreferences.getInstance();
      var token = sp.getString('token').toString();
      final headers = {'Authorization': 'Bearer $token'};
      print(
          '=============latitude ${_locationData.latitude.toString()} ====longitude ${_locationData.longitude.toString()}');

      final body = {
        'latitude': _locationData.latitude.toString(),
        'longitude': _locationData.longitude.toString(),
      };

      final response =
          await http.patch(Uri.parse(patchUrl), headers: headers, body: body);

      if (response.statusCode == 204) {
        print('Location updated successfully');
      } else {
        // Handle error
        print('Error updating location: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      print('Error: $e');
    }
  }

  bool isSkooper = true;
  bool showAcceptedRides = false;
  var user;
  Future<dynamic> getProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    var id = sp.getString('id').toString();
    final url = Uri.parse('$port/customer/');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      user = userData;
      imgg = stringToUint8List(user['customer']['picture']);
      print('user');
      print(user);
      // Return the user object
      return user;
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  var imgg;

  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  ThemeMode _themeMode = ThemeMode.system;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  switchRoleFunction() async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var token = sp.getString('token').toString();

      final url = Uri.parse('$port/change-role/');
      // final body = {'$key': value};
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.patch(url, headers: headers);
      if (response.statusCode == 204) {
        showToastShort('Role Switched successfully', kPrimaryGreen);
        // Navigator.of(context).pop();
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const bottomNavigationBar()));
      } else {
        showToastShort(response.statusCode.toString(), Colors.red);
        var token = jsonDecode(response.body.toString());
      }
    } catch (e) {}
  }

  Future<List<dynamic>> fetchRideRequests() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$portSkooper/getrequests');
    print('=================token $token');
    // final body = {'$key': value};
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // print('data');
      // print(data);
      // return data['finalRequests'];
      return data['finalRequests'];
    } else {
      // print('response.statusCode.toString()');
      // print(response.statusCode.toString());
      throw Exception('Failed to load ride requests');
    }
  }

  Future<List<dynamic>> fetchAcceptedRideRequests() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$portSkooper/currentacceptedrequests');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return data['acceptedRequests'];
    } else {
      throw Exception('Failed to load ride requests');
    }
  }

  void handleRideRequests() async {
    final rideRequests = await fetchRideRequests();
    final acceptedRideRequests = await fetchAcceptedRideRequests();
    if (acceptedRideRequests.isEmpty) {
      if (rideRequests.isNotEmpty) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    ListForOrdersSkooper(rideRequests, rideRequests.length)));
      } else {
        showToastShort('No Orders Request Found', kPrimaryGreen);
      }
    } else {
      showAcceptedRides = true;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  AcceptedSkooperRequestScreen(acceptedRideRequests, true)));
    }
  }

  Color kBG1 = const Color(0xffF9F9F9);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    kBG = isDark ? kDarkBG : kBG;
    updateLocation(0.0, 0.0);

    handleRideRequests();
    // isDark ? kDarkBG:
  }

  bool isChecked = true;
  bool isSelected = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController searchC = TextEditingController();
  var dropdownValue = 'Monthly';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: isDark ? kDarkBG : kBG,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: isDark ? kDarkBG : kBG,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () {
            _key.currentState!.openDrawer();
          },
          child: SizedBox(
            height: 30.0,
            child: Image.asset(
              !isDark ? 'assets/icons/menu.png' : 'assets/icons/menuD.png',
              // fit: BoxFit.cover,
              scale: 2.0,
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: isDark ? kDarkBg : kBG,
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30.0,
                ),
                FutureBuilder(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      // User data is available, display it in your UI
                      // final user = snapshot.data!;
                      // print('snapshot.data');
                      // print(snapshot.data);
                      user['customer']['role'] == 'customer'
                          ? isSkooper = false
                          : isSkooper = true;
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 50.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: start,
                                  children: [
                                    user['customer']['picture'] == ''
                                        ? Image.asset(
                                            'assets/images/profile.png',
                                            scale: 2.0,
                                          )
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(50.0),
                                            child: Image.memory(
                                              imgg,
                                              scale: 6.0,
                                            ),
                                          ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['customer']['full_name'] ??
                                              'Null',
                                          style: GoogleFonts.manrope(
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w700,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kSupportiveGrey),
                                        ),
                                        const SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(
                                          '\$${user['customer']['balance']}',
                                          style: GoogleFonts.manrope(
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w700,
                                              color: kSupportiveGrey),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              ListTile(
                                title: Text("Skooper Mode",
                                    style: GoogleFonts.manrope(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w700,
                                        color: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey)),
                                trailing: SizedBox(
                                  width: 30.0,
                                  child: Switch(
                                    // activeTrackColor: Colors.pink,
                                    inactiveThumbColor: Colors.black,
                                    activeColor: kPrimaryGreen,
                                    // thumbColor: kSupportiveGrey,
                                    value: isSkooper,
                                    onChanged: (bool value) async {
                                      // setState(() {
                                      isSkooper = value;
                                      SharedPreferences sp =
                                          await SharedPreferences.getInstance();
                                      sp
                                          .setBool('isSkooper', value)
                                          .whenComplete(() {
                                        if (!value) {
                                          switchRoleFunction();
                                        }
                                      });
                                      // });
                                    },
                                  ),
                                ),
                              ),
                              const Divider(
                                height: 0.0,
                              ),
                              ListTile(
                                // minVerticalPadding: 5,
                                // contentPadding: EdgeInsets.all(10),
                                minLeadingWidth: 7.0,
                                leading: Image.asset(
                                  'assets/icons/goOnlineIcon.png',
                                  scale: 2.0,
                                ),
                                title: Text('Go Online',
                                    style: GoogleFonts.manrope(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w700,
                                      color: !isDark
                                          ? kSecondaryColor
                                          : kSupportiveGrey,
                                    )),
                                trailing: SizedBox(
                                  width: 30.0,
                                  child: Switch(
                                    // activeTrackColor: Colors.pink,
                                    inactiveThumbColor: Colors.black,
                                    activeColor: kPrimaryGreen,
                                    // thumbColor: kSupportiveGrey,
                                    value: isChecked,
                                    onChanged: (bool value) {
                                      // setState(() {
                                      isChecked = value;
                                      // });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: ListView(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  children: <Widget>[
                                    DrawerBar(
                                        isSelected: false,
                                        text: 'Profile',
                                        img: 'assets/icons/user.png',
                                        tileColor: kBG,
                                        textColor: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (_) => SkooperRequestScreen()));
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      const ProfileScreen()));
                                        }),
                                    // Visibility(
                                    //   visible: showAcceptedRides,
                                    //   child: DrawerBar(
                                    //       isSelected: false,
                                    //       text: 'Rides',
                                    //       img: 'assets/icons/user.png',
                                    //       tileColor: kBG,
                                    //       textColor: !isDark
                                    //           ? kSecondaryColor
                                    //           : kSupportiveGrey,
                                    //       onTap: () {
                                    //         handleRideRequests();
                                    //         //Navigator.push(context, MaterialPageRoute(builder: (_) => AcceptedSkooperRequestScreen(acceptedRideRequests, true)));
                                    //       }),
                                    // ),
                                    DrawerBar(
                                        isSelected: false,
                                        text: 'Wallet',
                                        img: 'assets/icons/wallet.png',
                                        tileColor: kBG,
                                        textColor: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                        onTap: () {}),
                                    DrawerBar(
                                        isSelected: false,
                                        text: 'Help and Feedback',
                                        img: 'assets/icons/help.png',
                                        tileColor: kBG,
                                        textColor: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                        onTap: () {}),
                                    DrawerBar(
                                        isSelected: false,
                                        text: 'Terms & Conditions',
                                        img: 'assets/icons/help.png',
                                        tileColor: kBG,
                                        textColor: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      TermsAndConditionsScreenSkooper()));
                                        }),
                                    DrawerBar(
                                        isSelected: false,
                                        text: 'Settings',
                                        img: 'assets/icons/settings.png',
                                        tileColor: kBG,
                                        textColor: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     MaterialPageRoute(
                                          //         builder: (_) => SettingScreen()));
                                        }),
                                    DrawerBar(
                                        isSelected: false,
                                        text: 'Sign Out',
                                        img: 'assets/icons/logout.png',
                                        tileColor: kBG,
                                        textColor: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey,
                                        onTap: () async {
                                          SharedPreferences sp =
                                              await SharedPreferences
                                                  .getInstance();
                                          sp.setBool('isSkooper', false);
                                          sp.remove('token').whenComplete(() {
                                            Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (_) =>
                                                        const LoginScreen()));
                                          });
                                        }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      // An error occurred while fetching user data
                      return Text('Error: ${snapshot.error}');
                    }

                    // Data is still loading
                    return const Center(
                        child: CircularProgressIndicator(
                      color: kWhite,
                    ));
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Find your ',
                      style: GoogleFonts.dmSans(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w400,
                        color: kSecondaryColor,
                      ),
                    ),
                    GestureDetector(
                      child: Text(
                        'Ride',
                        style: GoogleFonts.dmSans(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w800,
                          color: kPrimaryGreen,
                        ),
                      ),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (_) => LoginScreen()));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 32.h,
              ),

              ///Overview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Text(
                          'Overview',
                          style: GoogleFonts.manrope(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            color: !isDark ? kSecondaryColor : kSupportiveGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // DropdownButton<String>(
                  //   value: dropdownValue,
                  //   icon: const Icon(Icons.arrow_drop_down_outlined),
                  //   iconSize: 20,
                  //   elevation: 16,
                  //   style: GoogleFonts.manrope(
                  //       color: !isDark ? kSecondaryColor : kSupportiveGrey,
                  //       fontWeight: FontWeight.w400,
                  //       fontSize: 12.sp),
                  //   underline: Container(
                  //     height: 2,
                  //     color: Colors.transparent,
                  //   ),
                  //   onChanged: (String? newValue) {
                  //     setState(() {
                  //       dropdownValue = newValue!;
                  //     });
                  //   },
                  //   items: <String>[
                  //     'Monthly',
                  //     // 'Dark',
                  //     'Daily',
                  //     'Weekly',
                  //     '3 Month',
                  //     '6 Month',
                  //     '1 Year'
                  //   ].map<DropdownMenuItem<String>>((String value) {
                  //     return DropdownMenuItem<String>(
                  //       value: value,
                  //       child: Text(value),
                  //     );
                  //   }).toList(),
                  // ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),

              ///overview body
              FutureBuilder(
                future: getProfile(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Card(
                              elevation: 1,
                              color: !isDark ? kWhite : kcardColor,
                              child: Container(
                                width: 154.w,
                                height: 155.h,
                                decoration: BoxDecoration(
                                    color: !isDark ? kWhite : kcardColor,
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 15.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Earnings',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kSupportiveGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        '\$ ${user['customer']['balance'] ?? '0'}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                          color: !isDark
                                              ? kSecondaryColor
                                              : kSupportiveGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 19.h,
                                      ),
                                      Text(
                                        'Increase than\nlast month',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: kSupportiveGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Card(
                              elevation: 1,
                              color: !isDark ? kWhite : kcardColor,
                              child: Container(
                                width: 154.w,
                                height: 128.h,
                                decoration: BoxDecoration(
                                    color: !isDark ? kWhite : kcardColor,
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 15.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Tips',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kSupportiveGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        '\$ ${user['customer']['tips']}',
                                        style: GoogleFonts.manrope(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                          color: !isDark
                                              ? kSecondaryColor
                                              : kSupportiveGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      Text(
                                        '${user['customer']['reviews']} Reviews',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: kSupportiveGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 20.r,
                        ),
                        Column(
                          children: [
                            Card(
                              elevation: 1,
                              color: !isDark ? kWhite : kcardColor,
                              child: Container(
                                width: 154.w,
                                height: 128.h,
                                decoration: BoxDecoration(
                                    color: !isDark ? kWhite : kcardColor,
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 15.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Cancel Rides',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kSupportiveGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        user['customer']['cancelled_rides']
                                            .toString(),
                                        style: GoogleFonts.manrope(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                          color: !isDark
                                              ? kSecondaryColor
                                              : kSupportiveGrey,
                                        ),
                                      ),
                                      // Row(
                                      //   children: const [
                                      //     Icon(
                                      //       Icons.star,
                                      //       size: 10,
                                      //       color: kPrimaryGreen,
                                      //     ),
                                      //     Icon(
                                      //       Icons.star,
                                      //       size: 10,
                                      //       color: kPrimaryGreen,
                                      //     ),
                                      //     Icon(
                                      //       Icons.star,
                                      //       size: 10,
                                      //       color: kPrimaryGreen,
                                      //     ),
                                      //     Icon(
                                      //       Icons.star,
                                      //       size: 10,
                                      //       color: kPrimaryGreen,
                                      //     ),
                                      //     Icon(
                                      //       Icons.star,
                                      //       size: 10,
                                      //       color: kSupportiveGrey,
                                      //     ),
                                      //   ],
                                      // ),
                                      SizedBox(
                                        height: 8.h,
                                      ),
                                      Text(
                                        'Decrease than\nlast month',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: kSupportiveGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Card(
                              elevation: 1,
                              color: !isDark ? kWhite : kcardColor,
                              child: Container(
                                width: 154.w,
                                height: 155.h,
                                decoration: BoxDecoration(
                                    color: !isDark ? kWhite : kcardColor,
                                    borderRadius: BorderRadius.circular(10.r)),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10.w, vertical: 15.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Rides',
                                            style: GoogleFonts.manrope(
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                              color: !isDark
                                                  ? kSecondaryColor
                                                  : kSupportiveGrey,
                                            ),
                                          ),
                                          // Container(
                                          //   height: 25.h,
                                          //   width: 50.w,
                                          //   decoration: BoxDecoration(
                                          //       color: kPrimaryGreen
                                          //           .withOpacity(0.8),
                                          //       borderRadius:
                                          //           BorderRadius.circular(
                                          //               10.r)),
                                          //   child: Center(
                                          //     child: Text(
                                          //       '+05%',
                                          //       style: GoogleFonts.manrope(
                                          //         fontSize: 12.sp,
                                          //         fontWeight: FontWeight.w600,
                                          //         color: kWhite,
                                          //       ),
                                          //     ),
                                          //   ),
                                          // )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Text(
                                        user['customer']['rides'].toString(),
                                        style: GoogleFonts.manrope(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                          color: !isDark
                                              ? kSecondaryColor
                                              : kSupportiveGrey,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 19.h,
                                      ),
                                      Text(
                                        'Increase than\nlast month',
                                        style: GoogleFonts.manrope(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: kSupportiveGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    // An error occurred while fetching user data
                    return Text('Error: ${snapshot.error}');
                  }

                  // Data is still loading
                  return const Center(
                      child: CircularProgressIndicator(
                    color: kWhite,
                  ));
                },
              ),

              const SizedBox(
                height: 30.0,
              ),

              ///past rides
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Past Rides',
                      style: GoogleFonts.manrope(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: !isDark ? kSecondaryColor : kSupportiveGrey,
                      ),
                    ),
                    // Text(
                    //   'See all',
                    //   style: GoogleFonts.manrope(
                    //     fontSize: 14.sp,
                    //     fontWeight: FontWeight.w500,
                    //     color: kSupportiveGrey2,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),

              ///past rides body
              Container(
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
                                return Card(
                                  elevation: 1,
                                  color: !isDark ? kWhite : kcardColor,
                                  child: Container(
                                    height: 100.h,
                                    width: 329.w,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    decoration: BoxDecoration(
                                        color: !isDark ? kWhite : kcardColor,
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 10.0,
                                        ),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.memory(
                                            image,
                                            width: 63.w,
                                            // height: 52.h,
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
                                                  order['createdAt']
                                                      .toString()
                                                      .substring(0, 10),
                                                  style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w600,
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
                                          '\$ ${order['total'].toString()}.00',
                                          style: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 15.sp,
                                            color: !isDark
                                                ? kSecondaryColor
                                                : kSupportiveGrey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
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
              const SizedBox(
                height: 100.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getPastOrders() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    final url = Uri.parse('$portSkooper/pastrides');
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<Map<String, dynamic>> activeOrders =
          List<Map<String, dynamic>>.from(responseData['pastRides']);
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
}
