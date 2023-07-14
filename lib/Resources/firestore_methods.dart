import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_clone/Models/post.dart';
import 'package:insta_clone/Resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Upload Post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String result = 'Some Error Occurred';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      //Generate a unique Id for each post
      String postId = const Uuid().v1();

      Post post = Post(
          description: description,
          uid: uid,
          postURL: photoUrl,
          profImage: profImage,
          username: username,
          postId: postId,
          likes: [],
          datePublished: DateTime.now());

      _firestore.collection('posts').doc(postId).set(post.toJson());
      result = 'success';
    } catch (e) {
      result = e.toString();
      print('Post Error:${e.toString()}');
    }
    return result;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        //Dislike Post (remove current uid from likes field)
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        //Like post (add uid to likes array)
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print('Like Error: ${e.toString()}');
    }
  }

  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePicture) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePicture,
          'name': name,
          'uuid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': []
        });
      } else {
        print('Comment text is empty');
      }
    } catch (e) {
      print('Comment Post Error: $e');
    }
  }

  //Like Comment
  Future<void> likeComment(
      {required String postId,
      required String commentId,
      required String uid,
      required List likes}) async {
    try {
      //Unlike Comment
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid])
        });
      }
      //Like Comment
      else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
    } catch (e) {
      print('Comment Like Error: $e');
    }
  }

//Delete Post
  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print('Delete Post Error: $e');
    }
  }

  //Follow User
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snapshot =
          await _firestore.collection('users').doc(uid).get();
      List following = (snapshot.data() as dynamic)['following'];

      if (following.contains(followId)) {
        //print('Unfollowing');
        //Remove user from followers list
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        //Remove profile from following list
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        //print('Following');
        //Add user to followers list
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        //Add profile to following list
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print('Follow User Error: $e');
    }
  }
}
