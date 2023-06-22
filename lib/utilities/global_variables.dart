import 'package:flutter/material.dart';
import 'package:insta_clone/Screens/Add_post_screen/add_post_screen.dart';
import 'package:insta_clone/Screens/Feed/feed_screen.dart';


const webScreenSize=600;
const homseScreenItems=[
  FeedScreen(),
  Center(child: Text('search')),
  AddPostScreen(),
  Center(child: Text('notification')),
  Center(child: Text('profile')),
];