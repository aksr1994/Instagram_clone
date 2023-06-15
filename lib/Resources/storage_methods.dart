import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


class StorageMethods{
  final FirebaseStorage _storage=FirebaseStorage.instance;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  //Add image to firebase storage
  Future<String> uploadImageToStorage(
      String childname,
      Uint8List file,
      bool isPost
      )async{
    
    //setup upload folder in firebase (childname/uid)
    Reference ref=_storage.ref().child(childname).child(_auth.currentUser!.uid);
    print('Ref: $ref');
    
    //upload file
    UploadTask uploadTask=ref.putData(file);
    TaskSnapshot taskSnapshot=await uploadTask;
    String downloadURL=await taskSnapshot.ref.getDownloadURL();

    print('Upload photo: $downloadURL');

    return downloadURL;
  }


}