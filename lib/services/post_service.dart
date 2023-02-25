import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/constant/firebase_instances.dart';
import 'package:flutter_firebase/model/post.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final postStream = StreamProvider((ref) => PostService.getPost());

class PostService {

  static CollectionReference postDb = FirebaseInstances.fireStore.collection('posts');

  //get all posts
  static Stream<List<Post>> getPost(){
    return postDb.snapshots().map((event) => getPostData(event));
  }

  static List<Post> getPostData(QuerySnapshot snapshot){
    return snapshot.docs.map((e){
      final json = e.data() as Map<String, dynamic>;
      return Post(
          postId: e.id,
          imageId: json['imageId'],
          userId: json['userId'],
          title: json['title'],
          detail: json['detail'],
          imageUrl: json['imageUrl'],
          like: Like.fromJson(json['like']),
          comments: (json['comments']as List).map((e) =>Comment.fromJson(e)).toList()
      );
    }
    ).toList();
  }

  //add post
  static Future<Either<String, bool>> postAdd({
    required String title,
    required String detail,
    required String userId,
    required XFile image}) async {
    try {
      final ref = FirebaseInstances.fireStorage.ref().child('postImage/${image.name}');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      await postDb.add({
        'userId': userId,
        'title': title,
        'detail': detail,
        'imageUrl': url,
        'imageId': image.name,
        'like': {
          'likes': 0,
          'usernames': []
        },
        'comments': []}
      );

      return Right(true);
    }on FirebaseAuthException catch(err){
      return Left('${err.message}');
    }
  }

  //delete post
  static Future<Either<String, bool>> postRemove(String postId,String imageId) async{
    try{
      await postDb.doc(postId).delete();
      final ref = FirebaseInstances.fireStorage.ref().child('postImage/$imageId');
      await ref.delete();

      return Right(true);
    }on FirebaseAuthException catch(err){
      return  Left('${err.message}');
    }
  }

  //update post
  static Future<Either<String, bool>> postUpdate({
    required  String title,
    required String detail,
    required String postId,
    String? imageId,
    XFile? image
  }) async{
    try{
      if(image == null){
        await postDb.doc(postId).update({
          'title': title,
          'detail': detail
        });
      }else{
        final ref = FirebaseInstances.fireStorage.ref().child('postImage/$imageId');
        await ref.delete();
        final ref1 = FirebaseInstances.fireStorage.ref().child('postImage/${image.name}');
        await ref1.putFile(File(image.path));
        final url = await ref1.getDownloadURL();
        await postDb.doc(postId).update({
          'title': title,
          'detail': detail,
          'imageId': image.name,
          'imageUrl': url
        });
      }
      return Right(true);

    } on FirebaseAuthException catch(err){
      return  Left('${err.message}');
    }

  }
}
