import 'package:flutter/material.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 26.sp),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(12.0),
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(100.0)),
                  child: Text('Select an image'),
                ),
                MyTextField(
                    controller: null,
                    myHintText: 'Username',
                    obsureText: false),
                MyTextField(
                    controller: null, myHintText: 'Email', obsureText: false),
                MyTextField(
                    controller: null, myHintText: 'Password', obsureText: true),
                MyButton(
                  onPressed: () {},
                  text: 'Sign Up',
                  btnColor: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
