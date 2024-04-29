

// ignore_for_file: prefer_const_constructors, avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:skoop/constant.dart';
import 'package:skoop/screens/user/login.dart';
import 'package:skoop/screens/user/termsAndConditionsUser.dart';
import 'package:skoop/screens/user/widgets/CTAButton.dart';
import 'package:skoop/screens/user/widgets/textFieldWidget.dart';
import 'package:skoop/toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  bool passwordObscured = true;
  bool passwordObscured2 = true;
  AnimationController? _controller;
  Animation<double>? _animation;
  bool isCostumer = true;
  bool _isTapped2 = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller!);
  }

  @override
  void dispose() {
    _controller!.dispose();
    emailC.dispose();
    passC.dispose();
    studentIdC.dispose();
    passC2.dispose();
    fullNameC.dispose();
    super.dispose();
  }

  void _onTap1() {
    setState(() {
      isCostumer = true;
      _isTapped2 = false;
    });
    _controller!.reset();
    _controller!.forward();
  }

  void _onTap2() {
    setState(() {
      isCostumer = false;
      _isTapped2 = true;
    });
    _controller!.reset();
    _controller!.forward();
  }

  // bool isCostumer = true;
  bool checkedValue = false;
  File? _imageFile;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController passC2 = TextEditingController();
  TextEditingController studentIdC = TextEditingController();
  TextEditingController fullNameC = TextEditingController();

  // multipartProdecudre(imagePath) async {

  //   //for multipartrequest
  //   var request = http.MultipartRequest('POST', Uri.parse('${apiCall}image/upload-image'));

  //   //for token
  //   // request.headers.addAll({"Authorization": "Bearer token"});

  //   //for image and videos and files

  //   request.files.add(await http.MultipartFile.fromPath("images", "${imagePath}"));

  //   //for completeing the request
  //   var response =await request.send();

  //   //for getting and decoding the response into json format
  //   var responsed = await http.Response.fromStream(response);
  //   final responseData = json.decode(responsed.body);

  //    if (response.statusCode==200) {
  //       print("SUCCESS");
  //       print(responseData);
  //     }
  //    else {
  //     print("ERROR");
  //   }
  // }

  signUpHere(
      {var email, var fullName, var studentId, var pass, var imagePath}) async {
    print("image" + imagePath);
    var url = Uri.parse('${apiCall}image/upload-image');

    var body = {};

    var req = http.MultipartRequest('POST', url);
// req.headers.addAll(headersList);`
    req.files.add(await http.MultipartFile.fromPath('images', '${imagePath}'));
// req.fields.addAll(body);

    // print("FILES" + req.files.toString());

    var res = await req.send();

    var responsed = await http.Response.fromStream(res);
    final responseData = json.decode(responsed.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      final apiUrl =
          "https://ocr-extract-text.p.rapidapi.com/ocr?url=${responseData['data'][0]}";

      // print("API URLLLLL" + apiUrl + "API URLLLLL");

      final url = Uri.parse('$apiUrl');

      final response = await http.get(
        url,
        headers: {
          'X-RapidAPI-Host': 'ocr-extract-text.p.rapidapi.com',
          'X-RapidAPI-Key':
              '336bd2bbc4mshf469042c9d0c35bp199a5djsnaa5cf783c29e',
        },
      );
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);

        final start = "CIIT/";
        final end = "/ISB";
        print("Decoded Data" + decodedData.toString());

        final startIndex = decodedData['text'].indexOf(start);
        final endIndex =
            decodedData['text'].indexOf(end, startIndex + start.length);

          print("Decoded Dataaa " + decodedData['text']
                .substring(startIndex + start.length, endIndex).toString());

          print("student Id " + studentId);

        if (decodedData['text']
                .substring(startIndex + start.length, endIndex) ==
            studentId) {
              print("Hereeeeeeeeeeeee FInalllll");
          try {
            http.Response response = await http.post(
              Uri.parse('$port/register'),
              body: {
                'student_id': studentId,
                'full_name': fullName,
                'email': email,
                'password': pass,
              },
            );
            if (response.statusCode == 201) {
              print('acc created successfully');
              showToastShort('Account created successfully', kPrimaryGreen);
              var token = jsonDecode(response.body.toString());
              print('token');
              print(token);
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => LoginScreen()));
            } else {
              print('response.statusCode');
              print(response.statusCode);
              //showToastShort(response.statusCode.toString(), Colors.red);
              var token = jsonDecode(response.body.toString());
              print('token');
              print(token["message"]);
              showToastShort(token["message"], Colors.red);
              print('error');
            }
          } catch (e) {
            print(e.toString());
          }
        } else {
          showToastShort("Student ID Incorrect", Colors.red);
        }
      } else {
        showToastShort("Student ID Incorrect", Colors.red);
      }
    } else {
      print(res.reasonPhrase);
    }
  }

  // signUpHere({var email, var fullName, var studentId, var pass}) async {
  //   String imageUrl = "";
  //   if (_imageFile != null) {
  //     FirebaseStorage storage = FirebaseStorage.instance;
  //     var date = DateTime.now().toString();

  //     String fileName = _imageFile!.path.split('/').last;

  //     Reference ref = storage
  //         .ref('profile_images')
  //         .child(DateTime.now().millisecondsSinceEpoch.toString());

  //     await ref.putFile(File(_imageFile!.path));
  //     imageUrl = await ref.getDownloadURL();

  //     final apiUrl =
  //         "https://ocr-extract-text.p.rapidapi.com/ocr?url=$imageUrl";

  //     print("API URLLLLL" + apiUrl + "API URLLLLL");

  //     final url = Uri.parse('$apiUrl');

  //     final response = await http.get(
  //       url,
  //       headers: {
  //         'X-RapidAPI-Host': 'ocr-extract-text.p.rapidapi.com',
  //         'X-RapidAPI-Key':
  //             '336bd2bbc4mshf469042c9d0c35bp199a5djsnaa5cf783c29e',
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       // API call was successful, handle the response here
  //       final decodedData = json.decode(response.body);

  //       final start = "CIIT/";
  //       final end = "/ISB";
  //       print("Decoded Data" + decodedData.toString());

  //       final startIndex = decodedData['text'].indexOf(start);
  //       final endIndex =
  //           decodedData['text'].indexOf(end, startIndex + start.length);

  //       if (decodedData['text']
  //               .substring(startIndex + start.length, endIndex) ==
  //           studentId) {
  //         try {
  //           http.Response response = await http.post(
  //             Uri.parse('$port/register'),
  //             body: {
  //               'student_id': studentId,
  //               'full_name': fullName,
  //               'email': email,
  //               'password': pass,
  //             },
  //           );
  //           if (response.statusCode == 201) {
  //             print('acc created successfully');
  //             showToastShort('Account created successfully', kPrimaryGreen);
  //             var token = jsonDecode(response.body.toString());
  //             print('token');
  //             print(token);
  //             Navigator.pushReplacement(
  //                 context, MaterialPageRoute(builder: (_) => LoginScreen()));
  //           } else {
  //             print('response.statusCode');
  //             print(response.statusCode);
  //             //showToastShort(response.statusCode.toString(), Colors.red);
  //             var token = jsonDecode(response.body.toString());
  //             print('token');
  //             print(token["message"]);
  //             showToastShort(token["message"], Colors.red);
  //             print('error');
  //           }
  //         } catch (e) {
  //           print(e.toString());
  //         }
  //       } else {
  //         showToastShort("Student ID Incorrect", Colors.red);
  //       }
  //     } else {
  //       // API call failed, handle the error here
  //       print('Error: ${response.statusCode}');
  //       print('Error body: ${response.body}');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kBG,
        body: Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .15,
                    ),
                    Text(
                      'Welcome!',
                      style: kTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    Text(
                      'Please provide following\n'
                      'details for your new account',
                      textAlign: TextAlign.center,
                      style: kSubTitleStyle,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .04,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: getTextField(
                        hintText: 'Full Name',
                        controller: fullNameC,
                        obsecureText: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: getTextField(
                        hintText: 'Student ID',
                        controller: studentIdC,
                        obsecureText: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: getTextField(
                        hintText: 'Email',
                        controller: emailC,
                        obsecureText: false,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: Container(
                        height: 50.0,
                        width: 327.0,
                        child: TextFormField(
                          obscureText: passwordObscured,
                          controller: passC,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordObscured = !passwordObscured;
                                });
                              },
                              icon: Icon(
                                passwordObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xffcecece),
                              ),
                            ),
                            fillColor: kWhite,
                            filled: true,
                            hintText: 'Password',
                            hintStyle: kFieldStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, bottom: 20),
                      child: Container(
                        height: 50.0,
                        width: 327.0,
                        child: TextFormField(
                          obscureText: passwordObscured2,
                          controller: passC2,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordObscured2 = !passwordObscured2;
                                });
                              },
                              icon: Icon(
                                passwordObscured2
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xffcecece),
                              ),
                            ),
                            fillColor: kWhite,
                            filled: true,
                            hintText: 'Confirm Password',
                            hintStyle: kFieldStyle,
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 50.0,
                      width: 300.0,
                      decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(16)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _onTap1,
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOut,
                              height: 50.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                  color: isCostumer ? kSecondaryColor : kWhite,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                child: Text(
                                  'Customer',
                                  style: GoogleFonts.manrope(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: isCostumer
                                          ? kWhite
                                          : kSupportiveGrey),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: _onTap2,
                            child: AnimatedContainer(
                              duration: Duration(seconds: 1),
                              curve: Curves.easeInOut,
                              height: 50.0,
                              width: 150.0,
                              decoration: BoxDecoration(
                                  color: _isTapped2 ? kSecondaryColor : kWhite,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Center(
                                child: Text(
                                  'Skooper',
                                  style: GoogleFonts.manrope(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w500,
                                      color: _isTapped2
                                          ? kWhite
                                          : kSupportiveGrey),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Upload Student Id"),
                          GestureDetector(
                            onTap: getImage,
                            child: Container(
                              width: 50,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.red,
                              ),
                              child: Center(child: Text("Upload")),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 1.0),
                            child: Checkbox(
                              value: checkedValue,
                              onChanged: (value) {
                                setState(() {
                                  checkedValue = value!;
                                });
                              },
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                'I have read and agree to ',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: kSupportiveGrey,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              TermsAndConditionsScreenUser()));
                                },
                                child: Text(' terms & conditions',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                      color: kPrimaryGreen,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    getCtaButton(
                        onPress: () {
                          // uploadImage();
                          signUpHere(
                              email: emailC.text.toString(),
                              studentId: studentIdC.text.toString(),
                              fullName: fullNameC.text.toString(),
                              pass: passC.text.toString(),
                              imagePath: _imageFile!.path
                              );
                        },
                        color: kPrimaryGreen,
                        text: 'Signup'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account ? ',
                          style: GoogleFonts.dmSans(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff868889),
                          ),
                        ),
                        GestureDetector(
                          child: Text(
                            'Login',
                            style: GoogleFonts.dmSans(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: kPrimaryGreen,
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => LoginScreen()));
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      setState(() {
        _imageFile = File(result.files.single.path.toString());
      });
      
    }
  }
}

