import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/screens/user/editProfile.dart';

import '../../constant.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var imgg;

  Uint8List stringToUint8List(String input) {
    final decoded = base64.decode(input);
    return Uint8List.fromList(decoded);
  }

  Future<dynamic> getProfile() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();

    final url = Uri.parse('$port/customer/');
    final headers = {'Authorization': 'Bearer $token'};

    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      // Parse the response body to extract the user data
      final userData = json.decode(response.body);
      user = userData;
      imgg = stringToUint8List(user['customer']['picture']);
      // final image = img.decodeJpg(user['customer']['picture']);
      print('image');
      print(imgg);
      print('user');
      print(user);
      // Return the user object
      return user;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch user data');
    }
  }

  var user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kPrimaryGreen,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: kPrimaryGreen,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: kWhite,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Profile',
            style: kAppbarStyle.copyWith(color: kWhite),
          ),
        ),
        body: FutureBuilder(
          future: getProfile(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // User data is available, display it in your UI
              // final user = snapshot.data!;
              print('snapshot.data');
              print(snapshot.data);

              return Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 100.0),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: kWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80.0,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 32.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Profile Details',
                                style: GoogleFonts.manrope(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20.sp,
                                ),
                              ),
                              // SizedBox(
                              //   width: 160.w,
                              // ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const EditProfileScreen()));
                                },
                                child: Image.asset(
                                  'assets/icons/edit.png',
                                  scale: 2.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 50.h,
                        ),

                        ///name
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Name',
                                style: kFieldStyleSupp,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                user['customer']['full_name'] ?? 'Null',
                                style: kFieldStyleSec,
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                            ],
                          ),
                        ),

                        ///email
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Email',
                                style: kFieldStyleSupp,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                user['customer']['email'] ?? 'user@email.com',
                                style: kFieldStyleSec,
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                            ],
                          ),
                        ),

                        ///number
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Phone Number',
                                style: kFieldStyleSupp,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                user['customer']['phone_number'] ??
                                    '934u349059',
                                style: kFieldStyleSec,
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                            ],
                          ),
                        ),

                        ///ID
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Student ID',
                                style: kFieldStyleSupp,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                user['customer']['student_id'] ?? '20395235093',
                                style: kFieldStyleSec,
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                            ],
                          ),
                        ),

                        ///Role
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 32.w, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Role',
                                style: kFieldStyleSupp,
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                user['customer']['role'] ?? 'Costumer',
                                style: kFieldStyleSec,
                              ),
                              const Divider(
                                height: 1.0,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 40.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        user['customer']['picture'] == ''
                            ? CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: const AssetImage(
                                    'assets/images/profile.png'),
                              )
                            : CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.grey[300],
                                backgroundImage: MemoryImage(imgg),
                              ),
                      ],
                    ),
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
        ));
  }
}
