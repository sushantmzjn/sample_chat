import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final controller;
  final String myHintText;
  bool obsureText;

  MyTextField({
    Key? key,
    required this.controller,
    required this.myHintText,
    required this.obsureText
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
      child: TextFormField(
        obscureText : obsureText,
        controller: controller,
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.green)),
            hintText: myHintText),
        maxLines: 1,
      ),
    );
  }
}
