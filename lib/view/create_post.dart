import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/constant/firebase_instances.dart';
import 'package:flutter_firebase/provider/common_provider.dart';
import 'package:flutter_firebase/provider/post_provider.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreatePage extends ConsumerWidget {
  final titleController = TextEditingController();
  final detailController = TextEditingController();
  final _from = GlobalKey<FormState>();

  final uid = FirebaseInstances.fireChat.firebaseUser!.uid;
  CreatePage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    ref.listen(postProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        Get.back();
        SnackShow.showSuccess(context, 'Post Created');
      }
    });
    final post = ref.watch(postProvider);
    final image = ref.watch(imageProvider);
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
                  child: Text('Create Post', style: TextStyle(fontSize: 26.sp),
                  ),
                ),
                SizedBox(height:15.h),
                //image picker container
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
                      height: 200.h,
                      margin: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.green)
                      ),
                      child: image == null ? Text('Choose an image',style: TextStyle(fontSize: 10.sp),) : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(File(image.path),
                          fit:BoxFit.fill,
                          height: 200.h,
                          width: double.infinity,
                          alignment: Alignment.center,
                        ),
                      ) ,
                    ),
                  ),

                //title text-field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                  child: TextFormField(
                    controller: titleController,
                    maxLength: 100,
                    validator: (val){
                      if(val!.isEmpty){
                        return 'required';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                        hintText: 'Title',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))
                    ),
                  ),
                ),
                //details text-form-field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.multiline,
                    validator: (val){
                      if(val!.isEmpty){
                        return 'required';
                      }
                      return null;
                    },
                    controller: detailController,
                    decoration: const InputDecoration(
                      hintText: 'Details',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 2.0),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)),
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red))
                    ),
                  ),
                ),
                SizedBox(height: 20.h),

                //post button
                MyButton(
                  isLoading: post.isLoad ? true : null,
                  onPressed:post.isLoad ? null : () {
                    _from.currentState!.save();
                    FocusScope.of(context).unfocus();
                    if (_from.currentState!.validate()) {
                        //post create provider
                        if(image == null){
                          SnackShow.showFailure(context, 'Image is required');
                        }else{
                          ref.watch(postProvider.notifier).postAdd(
                              title: titleController.text.trim(),
                              detail: detailController.text.trim(),
                              userId: uid,
                              image: image);
                        }
                      }else {
                      ref.watch(autoValidateMode.notifier).toggle();
                    }
                  },
                  text: 'Post',
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
