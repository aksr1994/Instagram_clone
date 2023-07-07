import 'package:flutter/material.dart';
import 'package:insta_clone/Screens/Add_post_screen/add_post_screen.dart';
import 'package:insta_clone/Screens/Feed/feed_screen.dart';
import 'package:insta_clone/Screens/Search/search_screen.dart';


const webScreenSize=600;
const homseScreenItems=[
  FeedScreen(),
  SearchScreen(),
  AddPostScreen(),
  Center(child: Text('notification')),
  Center(child: Text('profile')),
];