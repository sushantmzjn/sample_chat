import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/provider/common_provider.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignUp extends ConsumerWidget {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _from = GlobalKey<FormState>();

  SignUp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final isLogin = ref.watch(loginProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _from,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    isLogin ? 'Login' : 'Sign Up',
                    style: TextStyle(fontSize: 26.sp),
                  ),
                ),
                SizedBox(height: isLogin ? 80.h : 15.h),
                //image picker container
                if (!isLogin)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(12.0),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(100.0)),
                    child: Text('Select an image'),
                  ),

                //username text-field
                if (!isLogin)
                  MyTextField(
                      controller: usernameController,
                      myHintText: 'Username',
                      obsureText: false,
                      prefixIcon: Icon(CupertinoIcons.person, size: 14.sp)),
                //email text-field
                MyTextField(
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'required';
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)) {
                        return 'Please provide a valid email';
                      }

                      return null;
                    },
                    controller: emailController,
                    myHintText: 'Email',
                    obsureText: false,
                    prefixIcon: Icon(CupertinoIcons.mail, size: 14.sp)),
                //password text-field
                MyTextField(
                    controller: passwordController,
                    myHintText: 'Password',
                    obsureText: true,
                    prefixIcon: Icon(CupertinoIcons.lock, size: 14.sp)),
                SizedBox(height: 20.h),

                //login signup button
                MyButton(
                  onPressed: () {
                    _from.currentState!.save();
                    if (_from.currentState!.validate()) {
                      if (isLogin) {
                        //login provider
                      } else {
                        //signup provider
                      }
                    } else {}
                  },
                  text: isLogin ? 'Login' : 'Sign Up',
                  btnColor: Colors.green,
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                          child: Divider(thickness: 1, color: Colors.green)),
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(isLogin
                              ? 'Not Registered ?'
                              : 'Already Registered ?')),
                      Expanded(
                          child: Divider(thickness: 1, color: Colors.green)),
                    ],
                  ),
                ),

                MyButton(
                  onPressed: () {
                    _from.currentState!.reset();
                    ref.read(loginProvider.notifier).toggle();
                  },
                  text: isLogin ? 'Go To Sign up' : 'Go To Login',
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
