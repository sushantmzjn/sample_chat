import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String myHintText;
  bool obsureText;
  Widget? prefixIcon;
  String? Function(String?)? validator;

  MyTextField(
      {Key? key,
      required this.controller,
      required this.myHintText,
      required this.obsureText,
      this.prefixIcon,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: TextFormField(
        validator: validator,
        obscureText: obsureText,
        controller: controller,
        decoration: InputDecoration(
            prefixIcon: prefixIcon,
            prefixIconConstraints:
                BoxConstraints(minWidth: 30.w, minHeight: 30.h),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 2.0),
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            border: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red)),
            hintText: myHintText),
        maxLines: 1,
      ),
    );
  }
}
