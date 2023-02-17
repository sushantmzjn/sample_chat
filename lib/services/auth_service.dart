import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_firebase/constant/firebase_instances.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class AuthService{

Future<Either<String, bool>> userSignUp({
  required String email,
  required String password,
  required String username,
  required XFile image })async{
  try{
    // final imageName = DateTime.now().toString();
    final token = await FirebaseInstances.fireMessage.getToken();
    final ref = FirebaseInstances.fireStorage.ref().child('userImage/${image.name}');
    await ref.putFile(File(image.path));
    final url = await ref.getDownloadURL();

    final credential = await FirebaseInstances.firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    await FirebaseInstances.fireChat.createUserInFirestore(
      types.User(
      firstName: username,
      id: credential.user!.uid,
      imageUrl: url,
      lastName: '',
        metadata:{
          'email': email,
          'token' : token
        }
      ),
    );

    return Right(true);
  }
  on FirebaseException catch(err){
    return Left('${err.message}');
  }


}

}