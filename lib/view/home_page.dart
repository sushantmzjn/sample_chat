import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/constant/firebase_instances.dart';
import 'package:flutter_firebase/provider/post_provider.dart';
import 'package:flutter_firebase/services/post_service.dart';
import 'package:flutter_firebase/view/create_post.dart';
import 'package:flutter_firebase/view/detail_page.dart';
import 'package:flutter_firebase/view/update.dart';
import 'package:flutter_firebase/view/user_detail_page.dart';
import 'package:flutter_firebase/view/users_post.dart';
import 'package:flutter_firebase/view/widgets/snackbar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../provider/auth_provider.dart';
import '../services/auth_service.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class HomePage extends ConsumerWidget {
  HomePage({Key? key}) : super(key: key);

  final userId = FirebaseInstances.firebaseAuth.currentUser!.uid;
  late types.User user;

  @override
  Widget build(BuildContext context, ref) {

    ref.listen(postProvider, (previous, next) {
      if(next.isError){
        SnackShow.showFailure(context, next.errMessage);
      }else if(next.isSuccess){
        Get.back();
        SnackShow.showSuccess(context, 'success');
      }
    });


    final userData = ref.watch(userStream(userId));
    final logout = ref.watch(authProvider);
    final userList = ref.watch(usersStream);
    final postData = ref.watch(postStream);
    final deletePost = ref.watch(postProvider);
    return Scaffold(
      appBar: AppBar(
        title:const Text('Sample Chat'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                Get.defaultDialog(
                    title: 'Alert',
                    content: const Text('Are You Sure ?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Cancel')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ref.read(authProvider.notifier).userLogOut();
                          },
                          child: Text('Confirm'))
                    ]);
              },
              icon: Icon(Icons.login_outlined))
        ],
      ),
      drawer: Drawer(
        child: userData.when(
            data: (data) {
              user = data;
              return SafeArea(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.circular(100.0)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: CachedNetworkImage(
                          width: 110,
                          height: 110,
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, err) => Center(child: Text('$err')),
                          placeholder: (context, url) =>const Center(child: Text('loading...')),
                          imageUrl: data.imageUrl!,
                        ),
                      ),
                    ),
                    Center(
                        child: Text(
                      data.firstName!,
                      style: TextStyle(fontSize: 16.sp, letterSpacing: 1.5),
                    )),
                    Center(
                        child: Text(data.metadata!['email']!,
                            style: TextStyle(
                                fontSize: 12.sp,
                                letterSpacing: 1.5,
                                color: Colors.lightBlue))),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: const [
                          Expanded(child: Divider(color: Colors.green)),
                        ],
                      ),
                    ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          splashColor: Colors.green,
                          onTap: (){
                            Get.to(()=> CreatePage(), transition: Transition.leftToRight );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.post_add),
                              SizedBox(width: 10.w),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('Create Post'),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: InkWell(
                          splashColor: Colors.green,
                          onTap: (){
                            Get.to(()=> UserPost(user), transition: Transition.leftToRight);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.post_add),
                              SizedBox(width: 10.w),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text('My Post'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                  ],
                ),
              );
            },
            error: (error, stack) => Center(child: Text('$error')),
            loading: () => const Center(child: CircularProgressIndicator())),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 60.h,
            child: userList.when(
                data: (data){
                  return data.isEmpty ? const Center(child: Text('Empty')) : ListView.builder(
                    scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
                          child: GestureDetector(
                            onTap: (){
                              Get.to(()=> UserDetailPage(data[index]));
                            },
                            child: CircleAvatar(
                              radius: 28.r,
                              backgroundImage: NetworkImage(data[index].imageUrl!),
                            ),
                          ),
                        );
                  });
                },
                error: (error,stack)=> Center(child: Text('$error'),),
                loading: ()=> const Center(child: Text('loading...'))),
          ),
          Expanded(
              child: postData.when(
                  data: (data){
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(child: Text(data[index].title, style: TextStyle(overflow: TextOverflow.ellipsis),)),
                                    if(data[index].userId == userId)
                                      GestureDetector(
                                        onTap: (){
                                          Get.defaultDialog(
                                            content: const Text('Edit or Delete Post'),
                                            actions:[
                                              TextButton(onPressed: (){
                                                Navigator.of(context).pop();
                                                Get.to(()=> UpdatePage(data[index]));
                                              }, child: Text('edit')),

                                              TextButton(onPressed: (){
                                                Navigator.of(context).pop();
                                                Get.defaultDialog(
                                                  content: const Text('Are you sure ?'),
                                                  actions: [
                                                    TextButton(onPressed: (){
                                                      Navigator.of(context).pop();
                                                      ref.read(postProvider.notifier).deletePost(
                                                          postId: data[index].postId,
                                                          imageId: data[index].imageId);
                                                    }, child: Text('Yes')),
                                                    TextButton(onPressed: (){
                                                      Navigator.of(context).pop();
                                                    }, child: Text('Cancel'))
                                                  ]
                                                );
                                              }, child: Text('delete')),
                                            ]
                                          );
                                        },
                                          child: Icon(Icons.more_vert_outlined)
                                      ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: GestureDetector(
                                    onTap: (){
                                      Get.to(()=> DetailPage(data[index], user));
                                    },
                                    child: CachedNetworkImage(
                                      height: 200.h,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                      placeholder: (context,url)=> const Center(child: Text('loading...')),
                                        imageUrl: data[index].imageUrl
                                    ),
                                  ),
                                ),


                                Row(
                                  children: [
                                    if(data[index].userId != userId) GestureDetector(
                                      onTap: (){
                                        if(data[index].like.usernames.contains(user.firstName)){
                                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              duration: Duration(seconds: 1),
                                              content: Text('You have already like this post')
                                          ));
                                        }else{
                                          ref.read(postProvider.notifier).addLikes(
                                              usernames: [...data[index].like.usernames, user.firstName!] ,
                                              postId: data[index].postId,
                                              like: data[index].like.likes
                                          );
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Icon(
                                            Icons.thumb_up_alt_outlined
                                        ),
                                      ),
                                    ),
                                if(data[index].like.likes != 0) Text('${data[index].like.likes}')
                                  ],
                                ),


                              ],
                            ),
                          );

                    });
                  },
                  error: (error,stack)=> Center(child: Text('$error'),),
                  loading: ()=> const Center(child: CircularProgressIndicator()))

          )
        ],
      ),
    );
  }
}
