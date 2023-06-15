
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Resources/storage_methods.dart';
import 'package:insta_clone/Models/user_model.dart' as model;

class AuthenticationMethods{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _fireStore=FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async{
    User currentUser= _auth.currentUser!;
    DocumentSnapshot snap=
    await _fireStore.collection('users').doc(currentUser!.uid).get();
    return model.User.fromSnap(snap);
  }


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
        print('User:');
        print(_userCredential.user?.uid);
        String photoURL=await StorageMethods().uploadImageToStorage('profilePics', file, false);

        model.User user=model.User(
          username: username,
          uid: _userCredential.user!.uid,
          email: email,
          bio: bio,
          photoURL: photoURL,
          followers: [],
          following: []
        );


        //Add User to database(Creates a collection 'users' and document with the uid in that collection)

        // _fireStore.collection('users').doc(_userCredential.user!.uid).set({
        //   'username':username,
        //   'uid':_userCredential.user!.uid,
        //   'email':email,
        //   'bio':bio,
        //   'followers':[],
        //   'following':[],
        //   'photoURL':photoURL
        //
        // });

        //Replaced the above lines using the user model
        _fireStore.collection('users').doc(_userCredential.user!.uid).set(
          user.toJson()
        );

        result='success';
      }
    } on FirebaseAuthException catch(error){
      if(error.code=='invalid-email'){
        result='Badly formatted e-mail';
      }else if(error.code=='weak-password'){
        result='Weak Password, Password least 6 characters';
      }
    }
    catch(e){
      result=e.toString();
    }

    return result;

  }


  Future<String> loginUser({
    required String email,
    required String password
  })async{
    String result='Some Error occurred!';
    try{
      if(email.isNotEmpty||password.isNotEmpty){
       await _auth.signInWithEmailAndPassword(email: email, password: password);

       result='success';
      }
      else{
        result='Please enter all the fields';
      }
      print('Result: $result');

    } on FirebaseAuthException catch(error){
      if(error.code=='user-not-found'){
        result='User not found';
      }else if(error.code=='wrong-password'){
        result='Wrong Password';
      }
    }
    catch(e){
      print(e.toString());
      result=e.toString();
    }
    return result;
  }




}