import 'dart:ffi';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class AuthenticationMethods{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;

  //SignUp User
  Future<String> signUpUser({
    required String username,
    required String email,
    required String password,
    required String bio,
    required Uint8List file
  })async{

    String result='Some Error Occured!';

    try{
      if(email.isNotEmpty ||username.isNotEmpty|| password.isNotEmpty||bio.isNotEmpty||file!=null){
        //Register User
        UserCredential _userCredential= await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
        );
        print(_userCredential.user?.uid);

        //Add User to database(Creates a collection 'users' and document with the uid in that collection)
        _fireStore.collection('users').doc(_userCredential.user!.uid).set({
          'username':username,
          'uid':_userCredential.user!.uid,
          'email':email,
          'bio':bio,
          'followers':[],
          'following':[],


        });
        result='Success';
      }
    }catch(e){
      result=e.toString();
    }

    return result;

  }




}