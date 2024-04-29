// ignore_for_file: prefer_final_fields

import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../../../constant.dart';

class AcceptedMapToRestaurantScreen extends StatefulWidget {
  var orderDetails;
  var allOrder;
  AcceptedMapToRestaurantScreen(this.orderDetails, this.allOrder);

  @override
  State<AcceptedMapToRestaurantScreen> createState() =>
      _AcceptedMapToRestaurantScreenState();
}

class _AcceptedMapToRestaurantScreenState
    extends State<AcceptedMapToRestaurantScreen> {
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: kBG,
            ),
            child: Column(
              children: [
                Container(
                  height: 200.h,
                  width: 390.w,
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(35.r),
                      bottomLeft: Radius.circular(35.r),
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 1.0, color: Colors.grey.shade400),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 30.w, right: 30.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                'assets/icons/back_icon.png',
                                width: 10.w,
                                height: 20.h,
                              ),
                            ),
                            // SizedBox(
                            //   width: 27.w,
                            // ),
                            // Image.asset(
                            //   'assets/images/alex_icon.png',
                            //   width: 52.w,
                            //   height: 52.h,
                            // ),
                            SizedBox(
                              width: 85.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Ride Details',
                                  style: GoogleFonts.manrope(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.w700,
                                    color: kSecondaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 80,
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: TabBar(
                                  unselectedLabelColor: kSupportiveGrey,
                                  tabs: [
                                    Tab(
                                      height: 80.0,
                                      child: Text(
                                        'Maps',
                                        style: GoogleFonts.manrope(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                          color: !isDark
                                              ? kSecondaryColor
                                              : kSupportiveGrey,
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   width: 10.w,
                                    // ),
                                    Tab(
                                      height: 80.0,
                                      child: Text(
                                        'Details',
                                        style: GoogleFonts.manrope(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.w800,
                                          color: !isDark
                                              ? kSecondaryColor
                                              : kSupportiveGrey,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 20.h,
                // ),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      MapScreen(widget.orderDetails, widget.allOrder),
                      DetailsOrder(widget.orderDetails, widget.allOrder),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  var orderDetails;
  var allOrder;
  MapScreen(this.orderDetails, this.allOrder);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  void addPolylines() {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    // Example polyline coordinates (replace with your own)
    List<PointLatLng> result = polylinePoints.decodePolyline(encodedPolyline);

    result.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });

    setState(() {
      _polylines.add(Polyline(
        polylineId: PolylineId("polyline_1"),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 3,
      ));
    });
  }

  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  // Set<Polyline> _polylines = {};
  String encodedPolyline = ""; // Store your encoded polyline here

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void fetchEncodedPolyline(LatLng origin1, LatLng destination1) async {
    const apiKey = 'AIzaSyDk_9rqq12MYd_IEw4EQUTFngJuavZ4GKk';
    final origin =
        'origin=${origin1.latitude},${origin1.longitude}'; // Replace with your origin coordinates
    final destination =
        'destination=${destination1.latitude},${destination1.longitude}'; // Replace with your destination coordinates

    final apiUrl =
        'https://maps.googleapis.com/maps/api/directions/json?$origin&$destination&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      print('decoded api');
      print(decoded);
      final routes = decoded['routes'][0];
      // print('routes');
      // print(routes);
      setState(() {
        encodedPolyline = routes['overview_polyline']['points'];
        addPolylines();
      });
    } else {
      print('Error fetching polyline');
    }
  }

  LatLng? currentLocation;

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
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    }
    // fetchEncodedPolyline(
    //     currentLocation!,
    //     LatLng(widget.orderDetails['item']['restaurant']['latitude'],
    //         widget.orderDetails['item']['restaurant']['longitude']));
    // Call fetchEncodedPolyline only when currentLocation and destination coordinates are available
    if (currentLocation != null && widget.orderDetails != null) {
      LatLng destination = LatLng(
        widget.orderDetails['item']['restaurant']['latitude'],
        widget.orderDetails['item']['restaurant']['longitude'],
      );
      fetchEncodedPolyline(currentLocation!, destination);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    if (currentLocation != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: GestureDetector(
        child: Container(
          height: 69.h,
          width: 69.w,
          margin: const EdgeInsets.only(bottom: 120.0, right: 255),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(100.r),
          ),
          child: Image.asset(
            'assets/icons/messageIcon.png',
            // width: 25.w,
            // height: 25.h,
            scale: 2.0,
          ),
        ),
      ),
      body: Stack(
        children: [
          // GoogleMap(
          //   zoomControlsEnabled: false,
          //   scrollGesturesEnabled: false,
          //   mapType: MapType.normal,
          //   initialCameraPosition: _kGooglePlex,
          //   onMapCreated: (GoogleMapController controller) {
          //     _controller.complete(controller);
          //   },
          // ),
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: currentLocation ??
                  LatLng(0, 0), // Use currentLocation if available
              zoom: 12.0,
            ),
            scrollGesturesEnabled: true,
            polylines: _polylines,
          ),
          // Positioned(
          //   top: 5,
          //   left: 100,
          //   child: Image.asset(
          //     'assets/images/polyLine.png',
          //     scale: 3.5,
          //   ),
          // ),
          Positioned(
            top: 370,
            left: 30,
            child: Column(
              children: [
                GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => const MapToRestaurantScreen()));
                    },
                    child: Container(
                      height: 50.h,
                      width: 327.w,
                      decoration: BoxDecoration(
                        color: kPrimaryGreen,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Picked Order',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w700,
                              fontSize: 17.sp,
                              color: kWhite,
                            ),
                          )
                        ],
                      ),
                    )),
                const SizedBox(
                  height: 10.0,
                ),
                GestureDetector(
                    onTap: () {
                      cancelRide(context);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (_) => const MapToRestaurantScreen()));
                    },
                    child: Container(
                      height: 50.h,
                      width: 327.w,
                      decoration: BoxDecoration(
                        color: kSupportiveGrey,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Cancel Ride',
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w700,
                              fontSize: 17.sp,
                              color: kWhite,
                            ),
                          )
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> cancelRide(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: kBG,
          title: Column(
            children: [
              Text(
                'Cancel Ride',
                style: GoogleFonts.manrope(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w800,
                  color: kSecondaryColor,
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              const Divider(
                height: 1,
                indent: 5,
                endIndent: 5,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  elevation: 2,
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.only(right: 10.w, left: 10.w),
                    // margin: EdgeInsets.only(right: 7.w),
                    width: MediaQuery.of(context).size.width * 0.89,
                    height: 109.h,
                    decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(12.r)),
                    child: TextField(
                      style: kFieldStyle,
                      decoration: InputDecoration(
                        fillColor: kWhite,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        // enabledBorder: OutlineInputBorder,
                        hintText:
                            'Tell us why do you want to cancel the ride (Required)',
                        hintStyle: kFieldStyle,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7.h,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            GestureDetector(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 46.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: kPrimaryGreen,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Cancel Now',
                        style: GoogleFonts.manrope(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: kWhite,
                        ),
                      )
                    ],
                  ),
                ),

                // Within the `FirstRoute` widget
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const OrderStatusScreen()),
                  // );
                }),
          ],
        );
      },
    );
  }
}

class DetailsOrder extends StatefulWidget {
  var orderDetails;
  var allOrder;
  DetailsOrder(this.orderDetails, this.allOrder);

  @override
  State<DetailsOrder> createState() => _DetailsOrderState();
}

class _DetailsOrderState extends State<DetailsOrder> {
  double _toRadians(double degree) {
    return degree * pi / 180;
  }

  calculateDistance(double lat2, double lon2) async {
    // double d1 = 2.0;
    // setState(() {
    LatLng loc1 = await updateLocation();
    double lat1 = loc1.latitude;
    double lon1 = loc1.longitude;
    const double earthRadius = 6371; // in kilometers

    final latDistance = _toRadians(lat2 - lat1);
    final lonDistance = _toRadians(lon2 - lon1);
    final a = pow(sin(latDistance / 2), 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            pow(sin(lonDistance / 2), 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = earthRadius * c;
    // d1 = distance;
    print('distance km');
    print(distance);
    // });
    // setState(() {
    distancee = distance;
    print('distancee');
    print(distancee);
    // });

    return distance;
  }

  double? distancee;
  updateLocation() async {
    final location = Location();

    try {
      LocationData _locationData;

      _locationData = await location.getLocation();

      return LatLng(_locationData.latitude!.toDouble(),
          _locationData.longitude!.toDouble());
    } catch (e) {
      // Handle exception
      print('Error: $e');
    }
  }

  Future<dynamic>? distanceA;

  Future<void> calculateDistanceAndSetState() async {
    double distance = await calculateDistance(
      widget.orderDetails['item']['restaurant']['latitude'],
      widget.orderDetails['item']['restaurant']['longitude'],
    );
    setState(() {
      distancee = distance;
    });
  }

  String formatDistance(double distance) {
    return distance.toStringAsFixed(2);
  }

  @override
  void initState() {
    super.initState();
    calculateDistanceAndSetState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: isDark ? kDarkBg : kBG,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              DetailsComponents('Restaurant Name',
                  widget.orderDetails['item']['restaurant']['restaurant_name']),
              DetailsComponents('Destination Name',
                  widget.allOrder[0]['address']['location_name'].toString()),
              // DetailsComponents('Destination', 'Boys hostel block 2'),
              DetailsComponents('Delivery Time', '30 minutes'),
              DetailsComponents('Order Details',
                  '${widget.orderDetails['item']['name']} (x${widget.orderDetails['quantity'].toString()})'),
              // DetailsComponents('Total Distance', distancee.toString()),
              FutureBuilder<dynamic>(
                future: distanceA,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(); // or any loading widget
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return DetailsComponents(
                        'Total Distance', '${formatDistance(distancee!)} KM');
                  }
                },
              ),
              DetailsComponents('Total Amount',
                  '\$ ${widget.allOrder[0]['total'].toString()}.00'),
              DetailsComponents(
                  'Tip', '\$ ${widget.allOrder[0]['tip'].toString()}.00'),
              GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (_) => const MapToRestaurantScreen()));
                  },
                  child: Container(
                    height: 50.h,
                    width: 327.w,
                    decoration: BoxDecoration(
                      color: kPrimaryGreen,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Picked Order',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            fontSize: 17.sp,
                            color: kWhite,
                          ),
                        )
                      ],
                    ),
                  )),
              const SizedBox(
                height: 50.0,
              ),
              // DetailsComponents('', ''),
            ],
          ),
        ),
      ),
    );
  }

  Widget DetailsComponents(var heading, var subHead) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            heading,
            style: kFieldStyleSupp,
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            subHead,
            style: kFieldStyleSec,
          ),
          const Divider(
            height: 1.0,
          ),
        ],
      ),
    );
  }
}
