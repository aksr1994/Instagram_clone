import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utilities/global_variables.dart';

import '../Screens/Add_post_screen/add_post_screen.dart';
import '../Screens/Feed/feed_screen.dart';
import '../Screens/Profile Screen/profile_screen.dart';
import '../Screens/Search/search_screen.dart';
import '../utilities/colors.dart';

class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  int _page = 0;
  late PageController _pageController;
  String username = "";

  List<Widget> homeScreenItems=[
    const FeedScreen(),
    const SearchScreen(),
    const AddPostScreen(),
    const Center(child: Text('notification')),
    ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    getUsername();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
    setState(() {
      _page = page;
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void getUsername() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    print('User: ${snap.data()}');

    if (mounted) {
      setState(() {
        username = (snap.data() as Map<String, dynamic>)['username'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset(
          'assets/ig_logo.png',
          color: primaryColor,
          height: 50,
        ),
        actions: [
          IconButton(
              onPressed: ()=>navigationTapped(0),
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: ()=>navigationTapped(1),
              icon: Icon(
                CupertinoIcons.search,
                color: _page == 1 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: ()=>navigationTapped(2),
              icon: Icon(
                Icons.add_a_photo,
                color: _page == 2 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: ()=>navigationTapped(3),
              icon: Icon(
                Icons.favorite,
                color: _page == 3 ? primaryColor : secondaryColor,
              )),
          IconButton(
              onPressed: ()=>navigationTapped(4),
              icon: Icon(
                Icons.person,
                color: _page == 4 ? primaryColor : secondaryColor,
              ))
        ],
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: homeScreenItems,
      )
    );
  }
}
