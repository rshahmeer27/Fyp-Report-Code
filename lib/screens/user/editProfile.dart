// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constant.dart';
import '../../toast.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
      // final image = img.decodeJpg(user['customer']['picture']);
      imgg = stringToUint8List(user['customer']['picture']);
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
            'Edit Profile',
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
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
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
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),

                          ///name
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 32.w, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Name',
                                      style: kFieldStyleSupp,
                                    ),
                                    // SizedBox(
                                    //   width: 3,
                                    // ),
                                    IconButton(
                                        onPressed: () {
                                          EditName(context);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: kSecondaryColor,
                                        ))
                                  ],
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
                                horizontal: 32.w, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Email',
                                      style: kFieldStyleSupp,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          EditEmail(context);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: kSecondaryColor,
                                        ))
                                  ],
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
                                horizontal: 32.w, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: kFieldStyleSupp,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          EditNumber(context);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: kSecondaryColor,
                                        ))
                                  ],
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
                                horizontal: 32.w, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Student ID',
                                      style: kFieldStyleSupp,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          EditStuId(context);
                                        },
                                        icon: Icon(
                                          Icons.edit,
                                          size: 15,
                                          color: kSecondaryColor,
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                Text(
                                  user['customer']['student_id'] ??
                                      '20395235093',
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
                                horizontal: 32.w, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Role',
                                      style: kFieldStyleSupp,
                                    ),
                                    // IconButton(
                                    //     onPressed: () {
                                    //       SwitchRole(context);
                                    //     },
                                    //     icon: Icon(
                                    //       Icons.edit,
                                    //       size: 15,
                                    //       color: kSecondaryColor,
                                    //     ))
                                  ],
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
                  ),
                  Positioned(
                    top: 30,
                    left: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Container(
                            height: 150,
                            width: 150,
                            child: GestureDetector(
                              onTap: () {
                                takeImage(context);
                              },
                              child: _image == null
                                  ? Center(
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Positioned(
                                            left: 5,
                                            top: 5,
                                            child: SizedBox(
                                              height: 115,
                                              width: 115,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                fit: StackFit.expand,
                                                children: [
                                                  user['customer']['picture'] ==
                                                          ''
                                                      ? CircleAvatar(
                                                          radius: 50.0,
                                                          backgroundColor:
                                                              Colors.grey[300],
                                                          backgroundImage:
                                                              const AssetImage(
                                                                  'assets/images/profile.png'),
                                                        )
                                                      : CircleAvatar(
                                                          radius: 50.0,
                                                          backgroundColor:
                                                              Colors.grey[300],
                                                          backgroundImage:
                                                              MemoryImage(imgg),
                                                        ),
                                                  Positioned(
                                                    right: -10,
                                                    bottom: 0,
                                                    child: SizedBox(
                                                      height: 46,
                                                      width: 46,
                                                      child: GestureDetector(
                                                        onTap: () {},
                                                        child: Center(
                                                            child: Container(
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50),
                                                              color:
                                                                  kSecondaryColor),
                                                          child: const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    5.0),
                                                            child: Icon(
                                                              Icons
                                                                  .camera_alt_outlined,
                                                              color: kWhite,
                                                            ),
                                                          ),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Image.asset(
                                            //     'assets/images/profile_pic.png'),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        InkWell(
                                          onTap: () => takeImage(context),
                                          child: Container(
                                            height: 184.h,
                                            width: 110.w,
                                            margin: const EdgeInsets.only(
                                                bottom: 20, left: 4.0),
                                            child: Center(
                                              child: AspectRatio(
                                                aspectRatio: 1 / 1,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        alignment:
                                                            Alignment.center,
                                                        image: FileImage(
                                                            _image!,
                                                            scale: 6.0),
                                                        fit: BoxFit.cover),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            55.0),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        _image == null
                                            ? const SizedBox()
                                            : Positioned(
                                                right: 30,
                                                bottom: 20,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                      kSecondaryColor,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      updateProfileImage(
                                                          _image!);
                                                    },
                                                    icon: isLoadingImage
                                                        ? const CircularProgressIndicator(
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .check_outlined,
                                                            color: Colors.white,
                                                          ),
                                                  ),
                                                ),
                                              ),
                                      ],
                                    ),
                            ),
                          ),
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

  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController studentid = TextEditingController();

  EditName(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Edit Name',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: TextFormField(
              controller: username,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff000000),
                // height: 22.h
              ),
              decoration: InputDecoration(
                // prefixIcon: Container(
                //   margin: const EdgeInsets.all(4),
                //   child: Icon(
                //     Icons.sensor_occupied,
                //     color: Colors.white,
                //   ),
                //   decoration: BoxDecoration(
                //       color: const Color(0xffE99A25),
                //       borderRadius: BorderRadius.circular(8.r)),
                // ),
                labelText: 'Name',
                labelStyle: GoogleFonts.nunitoSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff000000),
                  // height: 22.h
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  editHere(
                      key: 'full_name', value: username.text, context: context);
                  showToastShort('Saved Changes', Colors.red);
                  // });
                },
              )
            ],
          );
        });
  }

  EditEmail(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Edit Email',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: TextFormField(
              controller: email,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff000000),
                // height: 22.h
              ),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.nunitoSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff000000),
                  // height: 22.h
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  editHere(key: 'email', value: email.text, context: context);
                  showToastShort('Saved Changes', Colors.red);

                  // });
                },
              )
            ],
          );
        });
  }

  EditNumber(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Edit Number',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: TextFormField(
              controller: number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff000000),
                // height: 22.h
              ),
              decoration: InputDecoration(
                // prefixIcon: Container(
                //   margin: const EdgeInsets.all(4),
                //   child: Icon(
                //     Icons.sensor_occupied,
                //     color: Colors.white,
                //   ),
                //   decoration: BoxDecoration(
                //       color: const Color(0xffE99A25),
                //       borderRadius: BorderRadius.circular(8.r)),
                // ),
                labelText: 'Phone Number',
                labelStyle: GoogleFonts.nunitoSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff000000),
                  // height: 22.h
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  editHere(
                      key: 'phone_number',
                      value: number.text,
                      context: context);
                  showToastShort('Saved Changes', Colors.red);
                  Navigator.of(context).pop();
                  // });
                },
              )
            ],
          );
        });
  }

  EditStuId(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Edit Student ID',
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xff000000),
                // height: 22.h
              ),
            ),
            content: TextFormField(
              controller: studentid,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: GoogleFonts.nunitoSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff000000),
                // height: 22.h
              ),
              decoration: InputDecoration(
                labelText: 'Student ID',
                labelStyle: GoogleFonts.nunitoSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff000000),
                  // height: 22.h
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Update'),
                onPressed: () {
                  editHere(
                      key: 'student_id',
                      value: studentid.text,
                      context: context);
                  showToastShort('Saved Changes', Colors.red);
                  Navigator.of(context).pop();
                  // });
                },
              )
            ],
          );
        });
  }

  editHere({var key, var value, required BuildContext context}) async {
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var token = sp.getString('token').toString();

      final url = Uri.parse('$port/edit-customer/');
      final body = {'$key': value};
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.patch(url, body: body, headers: headers);
      if (response.statusCode == 204) {
        print('Info Updated successfully');
        showToastShort('Info Updated successfully', kPrimaryGreen);
        Navigator.of(context).pop();
        // Navigator.pushReplacement(context,
        //     MaterialPageRoute(builder: (_) => const bottomNavigationBar()));
      } else {
        print('response.statusCode');
        print(response.statusCode);
        showToastShort(response.statusCode.toString(), Colors.red);
        var token = jsonDecode(response.body.toString());
        print('token');
        print(token);
        print('error');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  ///update image
  File? imageFile;
  final picker = ImagePicker();
  bool isLoadingImage = false;
  bool obscureText = true;
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  File? file;
  bool uploading = false;
  String? imageUrl;
  File? _image;

  Future<void> updateProfileImage(File imageFile) async {
    // final bytes = await imageFile.readAsBytes();
    // final base64Image = base64Encode(bytes);
    try {
      SharedPreferences sp = await SharedPreferences.getInstance();
      var token = sp.getString('token').toString();

      // Read the image file
      final bytes = await imageFile.readAsBytes();

      // Decode the image using the image package
      final image = img.decodeImage(bytes);

      // Resize the image to a desired width and height
      final resizedImage = img.copyResize(image!, width: 500, height: 500);

      // Encode the resized image to bytes
      final resizedBytes = img.encodeJpg(resizedImage);

      // Base64 encode the resized image bytes
      final base64Image = base64Encode(resizedBytes);

      // Prepare the request body
      // final body = {'image': base64Image};

      final url = Uri.parse('$port/edit-customer/');
      final body = {'picture': base64Image};
      final headers = {'Authorization': 'Bearer $token'};

      final response = await http.patch(url, body: body, headers: headers);

      if (response.statusCode == 204) {
        print('Profile image updated successfully');
        showToastShort('Profile image updated successfully', kPrimaryGreen);
      } else {
        showToastShort(
            'Failed to update profile image. Error: ${response.body}',
            Colors.red);
        print('Failed to update profile image. Error: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while updating profile image: $e');
      showToastShort(
          'Error occurred while updating profile image: $e', Colors.red);
    }
  }

  pickUImageFromGallery() async {
    Navigator.pop(context);
    // ignore: deprecated_member_use
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile!.path);
    });
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Upload Image", //item Image
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black,
                // height: 42.h
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: pickUImageFromGallery,
                child: Text(
                  "Gallery", //Select From Gallery
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    // height: 42.h
                  ),
                ),
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: GoogleFonts.poppins(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    // height: 42.h
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
