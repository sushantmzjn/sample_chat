import 'package:flutter/material.dart';
import 'package:flutter_firebase/view/signup.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Login',
              style: TextStyle(fontSize: 26.sp),
            ),
            MyTextField(
                controller: null, myHintText: 'username', obsureText: false),
            MyTextField(
              controller: null,
              myHintText: 'password',
              obsureText: true,
            ),
            MyButton(
              onPressed: () {},
              text: 'Log In',
              btnColor: Colors.green,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
              child: Row(
                children: const [
                  Expanded(child: Divider(thickness: 1, color: Colors.green)),
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('OR')),
                  Expanded(child: Divider(thickness: 1, color: Colors.green)),
                ],
              ),
            ),
            MyButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
              text: 'Sign Up',
              btnColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
