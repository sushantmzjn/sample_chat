import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyButton extends StatelessWidget {
  void Function()? onPressed;
  final String text;
  final btnColor;

  MyButton(
      {Key? key,
      required this.onPressed,
      required this.text,
      required this.btnColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 38.h,
            decoration: BoxDecoration(
                color: btnColor, borderRadius: BorderRadius.circular(4.0)),
            child: Text(
              text,
              style: TextStyle(letterSpacing: 1, fontSize: 14.sp),
            ),
          ),
        ));
  }
}
