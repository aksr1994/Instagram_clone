import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String uid;
  final String username;
  final String postURL;
  final String postId;
  final DateTime datePublished;
  final String profImage;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.postURL,
    required this.profImage,
    required this.username,
    required this.postId,
    required this.likes,
    required this.datePublished,
  });

  Map<String, dynamic> toJson()=>{
    'username':username,
    'uid':uid,
    'description':description,
    'postURL':postURL,
    'postId':postId,
    'profImage':profImage,
    'likes':likes,
    'datePublished':datePublished

  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot=snap.data() as Map<String,dynamic>;
    return Post(
        postId: snapshot['postId'],
        profImage: snapshot['profImage'],
        uid: snapshot['uid'],
        postURL: snapshot['postURL'],
        username: snapshot['username'],
        likes: snapshot['likes'],
        description: snapshot['description'],
        datePublished: snapshot['daePublished']
    );
  }





}