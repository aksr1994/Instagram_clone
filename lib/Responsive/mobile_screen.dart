import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Models/user_model.dart' as model;
import 'package:insta_clone/Providers/user_provider.dart';
import 'package:insta_clone/utilities/colors.dart';
import 'package:insta_clone/utilities/global_variables.dart';
import 'package:provider/provider.dart';

import '../Screens/Add_post_screen/add_post_screen.dart';
import '../Screens/Feed/feed_screen.dart';
import '../Screens/Profile Screen/profile_screen.dart';
import '../Screens/Search/search_screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page=0;
  late PageController _pageController;
  String username="";

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
    _pageController=PageController();
    getUsername();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  void navigationTapped(int page){
    _pageController.jumpToPage(page);
  }

  void onPageChanged(int page){

    setState(() {
      _page=page;
    });

  }


  void getUsername()async{
    DocumentSnapshot snap=await FirebaseFirestore.instance.collection('users').
    doc(FirebaseAuth.instance.currentUser!.uid).get();
    print('User: ${snap.data()}');

    if(mounted) {
      setState(() {
      username=(snap.data()as Map<String,dynamic>)['username'];
    });
    }
  }
  @override
  Widget build(BuildContext context) {
    final model.User? user=Provider.of<UserProvider>(context).getUser;
    print('User: ${user?.email}');
    print('uid_profile: ${FirebaseAuth.instance.currentUser!.uid}');

    if(user==null) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.lightBlue,
        ),
      );
    }
    else{
      return Scaffold(
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Colors.black,
          items: [
            _navBarItem(0, Icons.home),
            _navBarItem(1, Icons.search),
            _navBarItem(2, Icons.add_circle),
            _navBarItem(3, Icons.favorite),
            _navBarItem(4, Icons.person)
          ],
          onTap: navigationTapped,
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
          children: homeScreenItems,
        )
      );
    }


  }

  BottomNavigationBarItem _navBarItem(int page,IconData icon){
    return BottomNavigationBarItem(
        icon: Icon(icon,
          color: _page==page?primaryColor:secondaryColor,),
        backgroundColor: primaryColor,
        label: '');
  }
}
