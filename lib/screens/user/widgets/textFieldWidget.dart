import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant.dart';

getTextField({var hintText, required TextEditingController controller, IconButton? icon, required bool obsecureText}) {
  return SizedBox(
    height: 50.0,
    width: 327.0,
    child: TextFormField(
      obscureText: obsecureText,
      controller: controller,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      decoration: InputDecoration(
        suffixIcon: icon,
        fillColor: kWhite,
        filled: true,
        hintText: hintText,
        hintStyle: kFieldStyle,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    ),
  );
}
