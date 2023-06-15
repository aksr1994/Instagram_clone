import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Resources/auth_methods.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/Models/user_model.dart' as model;

class UserProvider extends ChangeNotifier{

  model.User? _user;
  final AuthenticationMethods _authMethods=AuthenticationMethods();

  model.User? get getUser=> _user;

  Future<void> refreshUser() async{
    model.User user= await _authMethods.getUserDetails();
    _user=user;
    notifyListeners();
  }
}

