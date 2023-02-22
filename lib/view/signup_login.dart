import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/provider/common_provider.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/snackbar.dart';
import 'package:flutter_firebase/view/widgets/text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../provider/auth_provider.dart';

class SignUp extends ConsumerWidget {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _from = GlobalKey<FormState>();

  SignUp({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(authProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        SnackShow.showSuccess(context, next.errMessage);
      }
    });
    final auth = ref.watch(authProvider);
    final image = ref.watch(imageProvider);
    final isLogin = ref.watch(loginProvider);
    final mode = ref.watch(autoValidateMode);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _from,
            autovalidateMode: mode,
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
                SizedBox(height: isLogin ? 70.h : 15.h),
                //image picker container
                if (!isLogin)
                  InkWell(
                    onTap: (){
                      Get.defaultDialog(
                        title: 'Select',
                        content: Text('Choose from'),
                        actions: [
                          TextButton(onPressed: (){
                            Navigator.of(context).pop();
                            ref.read(imageProvider.notifier).imagePick(true);
                          }, child: Text('Camera')),
                          TextButton(onPressed: () {
                            Navigator.of(context).pop();
                            ref.read(imageProvider.notifier).imagePick(false);

                          }, child: Text('Gallery')),
                        ]
                      );

                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: const EdgeInsets.all(12.0),
                      height: 110,
                      width: 110,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(100.0)),
                      child: image == null ? Text('Choose an image',style: TextStyle(fontSize: 10.sp),) : ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Image.file(File(image.path),
                            fit:BoxFit.cover, height: 150.h, width: 150.w,alignment: Alignment.center,

                        ),
                      ) ,
                    ),
                  ),

                //username text-field
                if (!isLogin)
                  MyTextField(
                      controller: usernameController,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'required';
                        } else if (val.length > 10) {
                          return 'length must be <10';
                        }
                        return null;
                      },
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
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'required';
                      } else if (val.length <=5) {
                        return 'password must be at least 6 character ';
                      }
                      return null;
                    },
                    myHintText: isLogin ? 'Password' : 'Password (at least 6 character)',
                    obsureText: true,
                    prefixIcon: Icon(CupertinoIcons.lock, size: 14.sp)),
                SizedBox(height: 20.h),

                //login signup button
                MyButton(
                  isLoading: auth.isLoad ? true : null,
                  onPressed:auth.isLoad ? null : () {
                    _from.currentState!.save();
                    FocusScope.of(context).unfocus();
                    if (_from.currentState!.validate()) {
                      if (isLogin) {
                        //login provider
                          ref.read(authProvider.notifier).userLogIn(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim());
                      } else {
                        //signup provider
                        if(image == null){
                            SnackShow.showFailure(context, 'Image is required');
                        }else{
                          ref.watch(authProvider.notifier).userSignUp(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              username: usernameController.text.trim(),
                              image: image);
                        }

                      }
                    } else {
                      ref.watch(autoValidateMode.notifier).toggle();
                    }
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
                    usernameController.clear();
                    passwordController.clear();
                    emailController.clear();
                    image == null;
                    ref.read(loginProvider.notifier).toggle();
                    ref.watch(autoValidateMode.notifier).autoValidateDisable();
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
