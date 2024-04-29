import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skoop/constant.dart';

import 'chatScreen.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  var myId;
  getDarkMode() {
    kBG = isDark ? kDarkBG : kBG;
    // isDark == false ? kBG = Color(0xffF9F9F9) : kBG = kDarkBG;
  }

  Future<List<dynamic>> getConversations() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('token').toString();
    myId = sp.getString('id').toString();
    print('myId');
    print(myId);
    final url = Uri.parse('$portChat/getconversations');
    // final body = {'$key': value};
    final headers = {'Authorization': 'Bearer $token'};
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('data');
      print(data);
      // return data['finalRequests'];
      return data;
    } else {
      // print('response.statusCode.toString()');
      // print(response.statusCode.toString());
      throw Exception('Failed to load conversations');
    }
  }

  @override
  void initState() {
    getDarkMode();
    super.initState();
    final conversations = getConversations();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      key: _key,
      child: Scaffold(
        backgroundColor: isDark ? kDarkBG : kBG,
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
                // Navigator.pop(context);
              }),
          title: Text(
            'Conversations',
            style: kAppbarStyle.copyWith(
                color: !isDark ? kSecondaryColor : kSupportiveGrey),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Center(
                  child: Container(
                    height: 45,
                    width: 327,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.r)),
                    child: TextFormField(
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
              ),
              SizedBox(
                height: 39.h,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: FutureBuilder<List<dynamic>>(
                  future: getConversations(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final conversations = snapshot.data;
                      int length = conversations!.length > 1 ? 1 : 0;
                      return ListView.builder(
                        itemCount: length,
                        itemBuilder: (context, index) {
                          final conversation = conversations![index];
                          final member = conversation['members'][1];
                          final myData;
                          final otherMember = conversation['members'][0];
                          var otherId;
                          print('member 1');
                          print(member['_id']);
                          print('member 2');
                          print(otherMember['_id']);
                          if (member['_id'] == myId) {
                            otherId = otherMember['_id'];
                            myData = conversation['members'][0];
                            print('otherId');
                            print(otherId);
                            print('myId');
                            print(myId);
                          } else {
                            otherId = member['_id'];
                            myData = conversation['members'][1];
                            print('otherId');
                            print(otherId);
                            print('myId');
                            print(myId);
                          }
                          print('member');
                          print(member);

                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => ChatScreen(
                                              conversation['_id'],
                                              otherId,
                                              myId)));
                                },
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: 318.w,
                                      height: 60.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 51.h,
                                            width: 51.h,
                                            decoration: BoxDecoration(
                                                image: const DecorationImage(
                                                    image: AssetImage(
                                                        'assets/images/peson1.png'),
                                                    fit: BoxFit.fill),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        20.r)),
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                myData['full_name'] ?? 'User',
                                                style: GoogleFonts.manrope(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16.sp,
                                                    color: !isDark
                                                        ? kSecondaryColor
                                                        : kSupportiveGrey),
                                              ),
                                              SizedBox(
                                                width: 140.w,
                                              ),
                                              Text(
                                                '2m ago',
                                                style: GoogleFonts.manrope(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 10.sp,
                                                  color: kSupportiveGrey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: 5.h,
                                      left: 30.0,
                                      child: Container(
                                        height: 17.h,
                                        width: 17.w,
                                        decoration: BoxDecoration(
                                          color: kPrimaryGreen,
                                          borderRadius:
                                              BorderRadius.circular(17.r),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 49.h,
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     // Navigator.push(
              //     //     context, MaterialPageRoute(builder: (_) => ChatScreen()));
              //   },
              //   child: Stack(
              //     children: [
              //       SizedBox(
              //         width: 318.w,
              //         height: 60.h,
              //         child: Row(
              //           children: [
              //             Container(
              //               height: 51.h,
              //               width: 51.h,
              //               decoration: BoxDecoration(
              //                   image: const DecorationImage(
              //                       image:
              //                           AssetImage('assets/images/peson1.png'),
              //                       fit: BoxFit.fill),
              //                   borderRadius: BorderRadius.circular(20.r)),
              //             ),
              //             SizedBox(
              //               width: 20.w,
              //             ),
              //             Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Row(
              //                   children: [
              //                     Text(
              //                       'Alex Andrew',
              //                       style: GoogleFonts.manrope(
              //                           fontWeight: FontWeight.w600,
              //                           fontSize: 16.sp,
              //                           color: !isDark
              //                               ? kSecondaryColor
              //                               : kSupportiveGrey),
              //                     ),
              //                     SizedBox(
              //                       width: 100.w,
              //                     ),
              //                     Text(
              //                       '2m ago',
              //                       style: GoogleFonts.manrope(
              //                         fontWeight: FontWeight.w400,
              //                         fontSize: 10.sp,
              //                         color: kSupportiveGrey,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //                 SizedBox(
              //                   height: 4.h,
              //                 ),
              //                 Row(
              //                   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Text(
              //                       'Hey what is up klnsd sdkn dslv',
              //                       style: GoogleFonts.manrope(
              //                           fontWeight: FontWeight.w500,
              //                           fontSize: 11.sp,
              //                           color: kSupportiveGrey),
              //                     ),
              //                     SizedBox(
              //                       width: 50.w,
              //                     ),
              //                     const Icon(
              //                       Icons.check_outlined,
              //                       color: kPrimaryGreen,
              //                     )
              //                   ],
              //                 ),
              //               ],
              //             ),
              //           ],
              //         ),
              //       ),
              //       Positioned(
              //         top: 5.h,
              //         left: 30.0,
              //         child: Container(
              //           height: 17.h,
              //           width: 17.w,
              //           decoration: BoxDecoration(
              //             color: kPrimaryGreen,
              //             borderRadius: BorderRadius.circular(17.r),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // SizedBox(
              //   height: 49.h,
              // ),
              // Stack(
              //   children: [
              //     SizedBox(
              //       width: 318.w,
              //       height: 60.h,
              //       child: Row(
              //         children: [
              //           Container(
              //             height: 51.h,
              //             width: 51.h,
              //             decoration: BoxDecoration(
              //                 image: const DecorationImage(
              //                     image:
              //                         AssetImage('assets/images/person2.png'),
              //                     fit: BoxFit.fill),
              //                 borderRadius: BorderRadius.circular(20.r)),
              //           ),
              //           SizedBox(
              //             width: 20.w,
              //           ),
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             children: [
              //               Row(
              //                 children: [
              //                   Text(
              //                     'Adams Bills 1',
              //                     style: GoogleFonts.manrope(
              //                         fontWeight: FontWeight.w600,
              //                         fontSize: 16.sp,
              //                         color: !isDark
              //                             ? kSecondaryColor
              //                             : kSupportiveGrey),
              //                   ),
              //                   SizedBox(
              //                     width: 100.w,
              //                   ),
              //                   Text(
              //                     '2m ago',
              //                     style: GoogleFonts.manrope(
              //                       fontWeight: FontWeight.w400,
              //                       fontSize: 10.sp,
              //                       color: kSupportiveGrey,
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //               SizedBox(
              //                 height: 4.h,
              //               ),
              //               Row(
              //                 children: [
              //                   Text(
              //                     'let’s meetup at centre point corner',
              //                     style: GoogleFonts.manrope(
              //                         fontWeight: FontWeight.w500,
              //                         fontSize: 11.sp,
              //                         color: kSupportiveGrey),
              //                   ),
              //                   SizedBox(
              //                     width: 30.w,
              //                   ),
              //                   CircleAvatar(
              //                     radius: 16.r,
              //                     backgroundColor:
              //                         kPrimaryGreen.withOpacity(0.12),
              //                     child: Text(
              //                       '1',
              //                       style: GoogleFonts.montserrat(
              //                           fontWeight: FontWeight.w600,
              //                           fontSize: 10.sp,
              //                           color: kPrimaryGreen),
              //                     ),
              //                   ),
              //                 ],
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ),
              //     // Positioned(
              //     //   top: 5.h,
              //     //   left: 30.0,
              //     //   child: Container(
              //     //     height: 17.h,
              //     //     width: 17.w,
              //     //     decoration: BoxDecoration(
              //     //       color: const Color(0xff54D969),
              //     //       borderRadius: BorderRadius.circular(17.r),
              //     //     ),
              //     //   ),
              //     // ),
              //   ],
              // ),
              SizedBox(
                height: 49.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
