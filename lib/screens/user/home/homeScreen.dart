// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/cartScreen.dart';
import 'package:skoop/screens/user/home/searchScreenHome.dart';

import '../../../constant.dart';
import '../../../toast.dart';
import '../../skooper/skooperNavigationBar.dart';
import '../deliveryAddress.dart';
import '../login.dart';
import '../profileScreen.dart';
import '../restrauntMenu.dart';
import '../settingsScreen.dart';
import '../termsAndConditionsUser.dart';
import '../walletScreen.dart';
import '../widgets/userDrawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ThemeMode _themeMode = ThemeMode.system;
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  Color kBG1 = const Color(0xffF9F9F9);

  @override
  void initState() {
    super.initState();
    updateLocation(0.0, 0.0);
    // _getCurrentLocation();
  }

  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

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
      //print('token');
      //print(token);
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
        //print('Location updated successfully');
      } else {
        // Handle error
        //print('Error updating location: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exception
      //print('Error: $e');
    }
  }

  bool isSkooper = false;
  bool isSelected = false;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  TextEditingController searchC = TextEditingController();
  // var dropdownValue = 'Light';
  var imgg;
  var imgg2;

  var user;
  Future<dynamic> getProfile() async {
    try {
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
        imgg2 = stringToUint8List(user['customer']['picture']);

        // Return the user object
        return user;
      } else {
        print('response.statusCode');
        print(response.statusCode);
        throw Exception('Failed to fetch user data');
      }
    } catch (e) {
      print('error is :${e.toString()}');
    }
  }

  Future<List<dynamic>> fetchFeaturedRestaurants(var route) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$port/$route');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final featureData = json.decode(response.body);
      print('restaurants');
      print(featureData['restaurants']);
      return featureData['restaurants'];
    } else {
      throw Exception('Failed to fetch restaurants');
    }
  }

  switchRoleFunction() async {
    try {
      print('===============hi');
      SharedPreferences sp = await SharedPreferences.getInstance();
      var token = sp.getString('token').toString();

      final url = Uri.parse('$port/change-role/');
      //final body = {'$key': value};
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.patch(url, headers: headers);
      if (response.statusCode == 204) {
        showToastShort('Role Switched successfully', kPrimaryGreen);
        // Navigator.of(context).pop();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => const SkooperBottomNavigationBar()));
      } else {
        showToastShort(response.statusCode.toString(), Colors.red);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      backgroundColor: isDark ? kDarkBG : kBG,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: isDark ? kDarkBG : kBG,
        // centerTitle: true,
        // title: Center(
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       DropdownButton<String>(
        //         value: dropdownValue,
        //         icon: const Icon(Icons.arrow_drop_down_outlined),
        //         iconSize: 24,
        //         elevation: 16,
        //         style: GoogleFonts.manrope(
        //             color: !isDark ? kSecondaryColor : kSupportiveGrey,
        //             fontWeight: FontWeight.w400,
        //             fontSize: 12.sp),
        //         underline: Container(
        //           height: 2,
        //           color: Colors.transparent,
        //         ),
        //         onChanged: (String? newValue) {
        //           setState(() {
        //             dropdownValue = newValue!;
        //           });
        //         },
        //         items: <String>['Light', 'Dark']
        //             .map<DropdownMenuItem<String>>((String value) {
        //           // //print(dropdownValue);
        //           // //print(dropdownValue);
        //           return DropdownMenuItem<String>(
        //             value: value,
        //             child: Text(value),
        //           );
        //         }).toList(),
        //       )
        //     ],
        //   ),
        // ),
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
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const CartScreen()));
            },
            child: Image.asset(
              !isDark ? 'assets/icons/cart.png' : 'assets/icons/cartD.png',
              // fit: BoxFit.cover,
              scale: 2.0,
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (_) => const NotificationScreen()));
          //   },
          //   child: Image.asset(
          //     !isDark
          //         ? 'assets/icons/notification.png'
          //         : 'assets/icons/notificationD.png',
          //     // fit: BoxFit.cover,
          //     scale: 2.0,
          //   ),
          // ),
        ],
      ),
      drawer: Drawer(
          backgroundColor: kBG,
          child: FutureBuilder(
            future: getProfile(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                print('========user role ${user['customer']['role']}');
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
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                                      borderRadius: BorderRadius.circular(50.0),
                                      child: Image.memory(
                                        imgg2,
                                        scale: 6.0,
                                      ),
                                    ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user['customer']['full_name'] ?? 'Null',
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
                              activeColor: Colors.green,
                              // thumbColor: kSupportiveGrey,
                              value: isSkooper,
                              onChanged: (bool value) async {
                                // setState(() {
                                print('================value $value');
                                isSkooper = value;
                                SharedPreferences sp =
                                    await SharedPreferences.getInstance();
                                sp.setBool('isSkooper', value).whenComplete(() {
                                  if (value) {
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const ProfileScreen()));
                                  }),
                              DrawerBar(
                                  isSelected: false,
                                  text: 'Location',
                                  img: 'assets/icons/location.png',
                                  tileColor: kPrimaryGreen.withOpacity(0.15),
                                  textColor: kPrimaryGreen,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => DeliveryAddress()));
                                  }),
                              DrawerBar(
                                  isSelected: false,
                                  text: 'Wallet',
                                  img: 'assets/icons/wallet.png',
                                  tileColor: kBG,
                                  textColor: !isDark
                                      ? kSecondaryColor
                                      : kSupportiveGrey,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const WalletScreen()));
                                  }),
                              Container(
                                height: 55.h,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 5),
                                child: ListTile(
                                  minVerticalPadding: 10,
                                  horizontalTitleGap: 2,
                                  leading: Image.asset(
                                    'assets/icons/darkMode.png',
                                    scale: 1.6,
                                  ),
                                  title: Text(
                                    "Dark Mode",
                                    style: GoogleFonts.manrope(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w700,
                                        color: !isDark
                                            ? kSecondaryColor
                                            : kSupportiveGrey),
                                  ),
                                  trailing: SizedBox(
                                    width: 30.0,
                                    child: Switch(
                                      inactiveThumbColor: Colors.black,
                                      activeColor: kPrimaryGreen,
                                      // thumbColor: kSupportiveGrey,
                                      value: isDark,
                                      onChanged: (bool value) {
                                        setState(() {
                                          isDark = value;
                                        });
                                      },
                                    ),
                                  ),
                                  // trailing: Icon(Icons.arrow_forward),
                                ),
                              ),
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
                                                TermsAndConditionsScreenUser()));
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const SettingScreen()));
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
                                        await SharedPreferences.getInstance();
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
          )),
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
                        'Food',
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
              const SizedBox(
                height: 10.0,
              ),
              Center(
                child: Container(
                  height: 45,
                  width: 327,
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(26.r)),
                  child: TextFormField(
                    readOnly: true,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SearchScreenHome()));
                    },
                    // enabled: false,
                    // obscureText: obsecureText,
                    // controller: searchC,
                    // validator: (value) {
                    //   if (value == null || value.isEmpty) {
                    //     return 'Please enter some text';
                    //   }
                    //   return null;
                    // },
                    decoration: InputDecoration(
                      // suffixIcon: icon,
                      prefixIcon: Image.asset(
                        'assets/icons/search.png',
                        scale: 1.8,
                      ),
                      fillColor: !isDark ? kWhite : const Color(0xff2A2C36),
                      filled: true,
                      hintText: 'Search',
                      hintStyle: kFieldStyle,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(26.r),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),

              ///Featured
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Featured',
                      style: GoogleFonts.dmSans(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: !isDark ? kSecondaryColor : kWhite,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10.0,
              ),

              ///featured body
              SizedBox(
                height: 150,
                child: FutureBuilder<List<dynamic>>(
                  future: fetchFeaturedRestaurants('view-featuredrestaurants/'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final restaurants = snapshot.data;

                      return ListView.builder(
                        itemCount: restaurants!.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final restaurantData = restaurants[index];
                          List<dynamic> opening =
                              restaurantData['opening_hours'];
                          List<dynamic> reviews = restaurantData['reviews'];
                          imgg = stringToUint8List(restaurantData['picture']);
                          // Calculate average rating
                          double totalStars = 0;
                          for (var review in reviews) {
                            totalStars += review['stars'];
                          }
                          double averageRating = totalStars / reviews.length;

                          //print('Average Rating: $averageRating');
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // //print('restaurant _id');
                                  // //print(restaurant['_id']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              RestaurantMenu(restaurantData)));
                                },
                                child: Container(
                                  height: 120,
                                  width:
                                      MediaQuery.of(context).size.width / 1.4,
                                  decoration: BoxDecoration(
                                    color: kPrimaryGreen,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      restaurantData['picture']
                                              .toString()
                                              .isEmpty
                                          ? Image.asset(
                                              'assets/images/f1.png',
                                              scale: 1.9,
                                            )
                                          : Image.memory(
                                              imgg,
                                              width: 120,
                                              height: 100,
                                            ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            restaurantData['restaurant_name'],
                                            style: GoogleFonts.manrope(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w800,
                                                color: kWhite),
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          opening.isEmpty
                                              ? Text(
                                                  'Opens until 11:00 PM',
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kWhite
                                                          .withOpacity(0.5)),
                                                )
                                              : Text(
                                                  'Opens until ${opening[0]['timeEnd']}',
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: kWhite
                                                          .withOpacity(0.5)),
                                                ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            // crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'assets/icons/starW.png',
                                                scale: 1.5,
                                              ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Text.rich(
                                                TextSpan(
                                                  text: averageRating
                                                              .toString() ==
                                                          'NaN'
                                                      ? '0.0'
                                                      : averageRating
                                                          .toString()
                                                          .substring(0, 3),
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color:
                                                          kWhite), // default text style
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                          '(${reviews.length.toString()} Reviews)',
                                                      style:
                                                          GoogleFonts.manrope(
                                                              fontSize: 10.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: kWhite),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              )
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Failed to fetch restaurants'),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),

              ///burger
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Burgers',
                      style: GoogleFonts.manrope(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: !isDark ? kSecondaryColor : kWhite,
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

              ///burger body
              SizedBox(
                height: 200,
                child: FutureBuilder<List<dynamic>>(
                  future:
                      fetchFeaturedRestaurants('view-pizzaburgerrestaurants/'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final restaurants = snapshot.data;

                      return ListView.builder(
                        itemCount: restaurants!.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          List<dynamic> opening = restaurant['opening_hours'];
                          imgg = stringToUint8List(restaurant['picture']);
                          List<dynamic> reviews = restaurant['reviews'];
                          // Calculate average rating
                          double totalStars = 0;
                          for (var review in reviews) {
                            totalStars += review['stars'];
                          }
                          double averageRating = totalStars / reviews.length;
                          print('restaurant view burger');
                          print(restaurant);
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              RestaurantMenu(restaurant)));
                                },
                                child: Card(
                                  elevation: 1.0,
                                  color: !isDark ? kWhite : kcardColor,
                                  child: Container(
                                    height: 190,
                                    width: 140,
                                    decoration: BoxDecoration(
                                      color: !isDark ? kWhite : kcardColor,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        restaurant['picture'].toString().isEmpty
                                            ? Image.asset(
                                                'assets/images/f1.png',
                                                scale: 1.65,
                                              )
                                            : ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                                child: Image.memory(
                                                  imgg,
                                                  width: 160,
                                                  height: 100,
                                                ),
                                              ),
                                        const SizedBox(
                                          height: 7.0,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                restaurant['restaurant_name'],
                                                style: GoogleFonts.manrope(
                                                    fontSize: 16.sp,
                                                    fontWeight: FontWeight.w800,
                                                    color: !isDark
                                                        ? kSecondaryColor
                                                        : kSupportiveGrey),
                                              ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              opening.isEmpty
                                                  ? Text(
                                                      'Opens until 11:00 PM',
                                                      style: GoogleFonts.manrope(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              kSupportiveGrey),
                                                    )
                                                  : Text(
                                                      'Opens until ${opening[0]['timeEnd']}',
                                                      style: GoogleFonts.manrope(
                                                          fontSize: 12.sp,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color:
                                                              kSupportiveGrey),
                                                    ),
                                              const SizedBox(
                                                height: 5.0,
                                              ),
                                              Row(
                                                // mainAxisAlignment: MainAxisAlignment.center,
                                                // crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    'assets/icons/stars.png',
                                                    scale: 1.5,
                                                  ),
                                                  const SizedBox(
                                                    width: 5.0,
                                                  ),
                                                  Text(
                                                    averageRating.toString() ==
                                                            'NaN'
                                                        ? '0.0'
                                                        : averageRating
                                                            .toString()
                                                            .substring(0, 3),
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 14.sp,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: !isDark
                                                            ? kSecondaryColor
                                                            : kSupportiveGrey),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 7.0,
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Failed to fetch restaurants'),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),

              ///pasta
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Pasta',
                      style: GoogleFonts.manrope(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: !isDark ? kSecondaryColor : kWhite,
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

              ///pasta body
              SizedBox(
                height: 200,
                child: FutureBuilder<List<dynamic>>(
                  future:
                      fetchFeaturedRestaurants('view-pizzaburgerrestaurants/'),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final restaurants = snapshot.data;

                      return ListView.builder(
                        itemCount: restaurants!.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final restaurant = restaurants[index];
                          List<dynamic> opening = restaurant['opening_hours'];
                          imgg = stringToUint8List(restaurant['picture']);
                          List<dynamic> reviews = restaurant['reviews'];
                          double totalStars = 0;
                          for (var review in reviews) {
                            totalStars += review['stars'];
                          }
                          double averageRating = totalStars / reviews.length;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Card(
                                elevation: 1.0,
                                color: !isDark ? kWhite : kcardColor,
                                child: Container(
                                  height: 190,
                                  width: 140,
                                  decoration: BoxDecoration(
                                    color: !isDark ? kWhite : kcardColor,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      restaurant['picture'].toString().isEmpty
                                          ? Image.asset(
                                              'assets/images/f1.png',
                                              scale: 1.65,
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              child: Image.memory(
                                                imgg,
                                                width: 160,
                                                height: 100,
                                                // scale: 1.65,
                                              ),
                                            ),
                                      const SizedBox(
                                        height: 7.0,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            restaurant['restaurant_name'] == ''
                                                ? Text(
                                                    'Restaurant',
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: !isDark
                                                            ? kSecondaryColor
                                                            : kSupportiveGrey),
                                                  )
                                                : Text(
                                                    restaurant[
                                                            'restaurant_name'] ??
                                                        'Restaurant',
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w800,
                                                        color: !isDark
                                                            ? kSecondaryColor
                                                            : kSupportiveGrey),
                                                  ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            opening.isEmpty
                                                ? Text(
                                                    'Opens until 11:00 PM',
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kSupportiveGrey),
                                                  )
                                                : Text(
                                                    'Opens until ${opening[0]['timeEnd']}',
                                                    style: GoogleFonts.manrope(
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: kSupportiveGrey),
                                                  ),
                                            const SizedBox(
                                              height: 5.0,
                                            ),
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.center,
                                              // crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Image.asset(
                                                  'assets/icons/stars.png',
                                                  scale: 1.5,
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                Text(
                                                  averageRating.toString() ==
                                                          'NaN'
                                                      ? '0.0'
                                                      : averageRating
                                                          .toString()
                                                          .substring(0, 3),
                                                  style: GoogleFonts.manrope(
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: !isDark
                                                          ? kSecondaryColor
                                                          : kSupportiveGrey),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 7.0,
                              ),
                            ],
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Failed to fetch restaurants'),
                      );
                    }

                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 130.0,
              )
            ],
          ),
        ),
      ),
    );
  }
}
