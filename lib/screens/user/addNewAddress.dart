import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';
import 'package:skoop/toast.dart';

class AddNewAddress extends StatefulWidget {
  const AddNewAddress({Key? key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  LatLng? tappedLocation;
  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionStatus;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    final currentLocationData = await location.getLocation();
    setState(() {
      currentLocation = LatLng(
        currentLocationData.latitude!,
        currentLocationData.longitude!,
      );
    });
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (currentLocation != null) {
      mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    }
  }

  void _onMapTap(LatLng location) {
    setState(() {
      tappedLocation = location;
      print(tappedLocation!.latitude);
      print(tappedLocation!.longitude);
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('tapped_location'),
          position: location,
        ),
      );
    });
  }

  TextEditingController kLocationController = TextEditingController();
  postAddress(var location) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    final token = sp.getString('token').toString();
    final id = sp.getString('id').toString();

    final url = Uri.parse('$port/add-deliveryaddress');
    final headers = {'Authorization': 'Bearer $token'};
    final body = {
      'customer': id,
      'location_name': location,
      'longitude': tappedLocation!.longitude.toString(),
      'latitude': tappedLocation!.latitude.toString(),
      'custom_name': '',
    };
    final response = await http.post(url, body: body, headers: headers);
    if (response.statusCode == 201) {
      // Parse the response body to extract the user data
      final featureData = json.decode(response.body);
      // return featureData['addresses'];
      showToastShort('Address Created Successfully', kPrimaryGreen);
      print(featureData);
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch restaurants');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
          'New Address',
          style: kAppbarStyle.copyWith(color: !isDark ? kSecondaryColor : kSupportiveGrey),
        ),
      ),
      body: Container(
        // margin: EdgeInsets.only(left: 32.w),
        decoration: BoxDecoration(
          color: kBG,
        ),
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: _onMapCreated,
              onTap: _onMapTap,
              markers: markers,
              initialCameraPosition: const CameraPosition(
                target:
                    // currentLocation ??
                    LatLng(0.0, 0.0),
                zoom: 12.0,
              ),
            ),
            Positioned(
              top: 10.0,
              left: 35.0,
              child: Container(
                width: 327.w,
                height: 45.h,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(26.r)),
                child: TextFormField(
                  // onTap: () {
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (_) => const SearchScreenHome()));
                  // },
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
                    labelText: 'Search',
                    labelStyle: kFieldStyle,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(26.r),
                    ),
                  ),
                ),
              ),
            ),
            // Positioned(
            //   top: 100,
            //   left: 50.0,
            //   child: Image.asset(
            //     'assets/images/marker.png',
            //     width: 40,
            //   ),
            // )
          ],
        ),
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
          // shape: BoxShape.circle
        ),
        child: Container(
          height: 252.h,
          width: 390.w,
          decoration: BoxDecoration(
            color: isDark ? kDarkBg : kBG,
            borderRadius: BorderRadius.only(topRight: Radius.circular(30.r), topLeft: Radius.circular(30.r)),
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
                  Image.asset(
                    'assets/icons/location_icon.png',
                    width: 18.w,
                    height: 20.h,
                  ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Text(
                    'Sports Area',
                    style: GoogleFonts.manrope(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: !isDark ? kSecondaryColor : kSupportiveGrey,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Card(
                elevation: 3,
                child: Container(
                  width: 326.w,
                  height: 50.h,
                  child: getTextField(
                    hintText: 'Custom Location Name(Optional)',
                    controller: kLocationController,
                    obsecureText: false,
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
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
                        // Image.asset(
                        //   'assets/icons/cart_icon.png',
                        //   width: 25.w,
                        //   height: 26.h,
                        // ),
                        // SizedBox(
                        //   width: 14.w,
                        // ),
                        Text(
                          'Save Address',
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
                    postAddress(kLocationController.text);
                    Navigator.pop(context, true);
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
}
