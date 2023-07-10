import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Screens/Add_post_screen/add_post_screen.dart';
import 'package:insta_clone/Screens/Feed/feed_screen.dart';
import 'package:insta_clone/Screens/Profile%20Screen/profile_screen.dart';
import 'package:insta_clone/Screens/Search/search_screen.dart';


const webScreenSize=600;
 List<Widget> homeScreenItems=[
  const FeedScreen(),
  const SearchScreen(),
  const AddPostScreen(),
  const Center(child: Text('notification')),
  ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
];