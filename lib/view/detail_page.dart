import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/provider/post_provider.dart';
import 'package:flutter_firebase/view/widgets/button.dart';
import 'package:flutter_firebase/view/widgets/text_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/post.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;


class DetailPage extends ConsumerWidget {
  final Post post;
  final types.User user;

  DetailPage(this.post, this.user);
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context, ref) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
                alignment: Alignment.center,
                height: 200.h,
                margin: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.green)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    errorWidget: (err, stack, _) => const Text('no image'),
                    width: double.infinity,
                    fit: BoxFit.fill,
                    imageUrl: post.imageUrl,
                    placeholder: (context, url) => const Center(child: Text('loading...'),
                    ),
                  ),
                )),

            Expanded(
              child: SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(post.title),
                        SizedBox(height: 10.h,),
                        Text(post.detail, maxLines: 4,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            MyTextField(
                            controller : commentController,
                              validator: (val){
                                if(val!.isEmpty){
                                  return 'required';
                                }
                                return null;
                              },
                                myHintText: 'comments...',
                                obsureText: false),
                            ElevatedButton(onPressed: (){
                              ref.read(postProvider.notifier).addComment(
                                  [...post.comments,
                                  Comment(
                                      username: user.firstName!,
                                      imageUrl: user.imageUrl!,
                                      comment: commentController.text.trim()
                                  )
                                  ],
                                  post.postId);
                            }, child: Text('post'))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
