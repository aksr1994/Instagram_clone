

import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/Models/post.dart';
import 'package:insta_clone/Resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

  //Upload Post
Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage
    ) async {
  String result='Some Error Occurred';
  try{
    String photoUrl=await StorageMethods().uploadImageToStorage('posts', file, true);

    //Generate a unique Id for each post
    String postId=const Uuid().v1();


    Post post=Post(
        description: description,
        uid: uid,
        postURL: photoUrl,
        profImage: profImage,
        username: username,
        postId: postId,
        likes: [],
        datePublished: DateTime.now());

    _firestore.collection('posts').doc(postId).set(post.toJson());
    result='success';
  }
  catch(e){
    result=e.toString();
    print('Post Error:${e.toString()}');
  }
  return result;
}



}

