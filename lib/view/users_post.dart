import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase/view/update.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../constant/firebase_instances.dart';
import '../provider/post_provider.dart';
import '../services/post_service.dart';
import 'detail_page.dart';


class UserPost extends ConsumerWidget {
 final types.User user;
 UserPost(this.user);
 final userId = FirebaseInstances.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context, ref) {
    final postData = ref.watch(postStream);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Post'),
        centerTitle: true,
      ),
      body: postData.when(
          data: (data){
            final currentUserPost = data.where((element) => element.userId== user.id).toList();
            return currentUserPost.isEmpty ? const Center(child: Text('Empty')) : ListView.builder(
                itemCount: currentUserPost.length,
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
                        if(data[index].userId != userId)
                          GestureDetector(
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
                    Text(data[index].detail)
                  ],
                ),
              );
            });
          },
          error: (error, stack)=> Center(child: Text('$error')),
          loading:()=> const Center(child: CircularProgressIndicator())),
    );
  }
}
