import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/services/post_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_screenutil/flutter_screenutil.dart';


class UserDetailPage extends ConsumerWidget {
  final types.User user;
  UserDetailPage(this.user);


  @override
  Widget build(BuildContext context, ref) {
    final postData = ref.watch(postStream);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(user.imageUrl!),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.firstName!),
                        Text(user.metadata!['email']),
                      ],
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(onPressed: (){}, child: Text('Chat'))
                ],
              ),
            ),
            Expanded(
                child: postData.when(
                    data: (data){
                      final currentUserPost = data.where((element) => element.userId== user.id).toList();
                      return currentUserPost.isEmpty ? const Center(child: Text('No Post')) :ListView.builder(
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
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: CachedNetworkImage(
                                      height: 200.h,
                                      width: double.infinity,
                                      fit: BoxFit.fill,
                                      placeholder: (context,url)=> const Center(child: Text('loading...')),
                                      imageUrl: data[index].imageUrl
                                  ),
                                ),
                                Text(data[index].detail),
                                Divider(color: Colors.green, thickness: 1.0,)

                              ],
                            ),
                          );

                          }
                      );
                    },
                    error: (error, stack)=> Center(child: Text('$error')),
                    loading: ()=> Center(child: Text('loading...')))
            )
          ],
        ),
      ),
    );
  }
}
