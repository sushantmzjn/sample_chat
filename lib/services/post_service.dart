import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/constant/firebase_instances.dart';
import 'package:image_picker/image_picker.dart';

class PostService {

  static CollectionReference postDb = FirebaseInstances.fireStore.collection('posts');

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
}
