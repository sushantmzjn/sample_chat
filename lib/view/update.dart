import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/model/post.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constant/firebase_instances.dart';
import '../provider/common_provider.dart';
import '../provider/post_provider.dart';

class UpdatePage extends ConsumerStatefulWidget {
  final Post postData;
  UpdatePage(this.postData, {super.key});

  @override
  ConsumerState<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {

  TextEditingController titleController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final uid = FirebaseInstances.fireChat.firebaseUser!.uid;

  @override
  void initState() {
    titleController..text = widget.postData.title;
    detailController..text = widget.postData.detail;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ref.listen(postProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        Get.back();
        SnackShow.showSuccess(context, 'success');
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
            key: _form,
            autovalidateMode: mode,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Update Post', style: TextStyle(fontSize: 26.sp),
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
                    child: image == null ? Image.network(widget.postData.imageUrl): ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.file(File(image.path),
                        height: 200.h,
                        width: double.infinity,
                        fit: BoxFit.fill,
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
                    _form.currentState!.save();
                    FocusScope.of(context).unfocus();
                    if (_form.currentState!.validate()) {
                      //post create provider
                      if(image == null){
                        ref.read(postProvider.notifier).postUpdate(
                            title: titleController.text.trim(), detail: detailController.text.trim(), postId: widget.postData.postId);
                      }else{
                        ref.read(postProvider.notifier).postUpdate(
                            title: titleController.text.trim(),
                            detail: detailController.text.trim(),
                            postId: widget.postData.postId,
                            image: image,
                            imageId: widget.postData.imageId
                        );
                      }
                    }else {
                      ref.watch(autoValidateMode.notifier).toggle();
                    }
                  },
                  text: 'Update',
                  btnColor: Colors.green,
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
