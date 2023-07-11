import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Widgets/app_post_card.dart';
import 'package:insta_clone/utilities/colors.dart';
import 'package:insta_clone/utilities/global_variables.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor:
            width > webScreenSize ? webBackgroundColor : mobileBackgroundColor,
        appBar: width > webScreenSize
            ? null
            : AppBar(
                backgroundColor: mobileBackgroundColor,
                centerTitle: false,
                title: Image.asset(
                  'assets/ig_logo.png',
                  color: primaryColor,
                  height: 50,
                ),
                actions: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(CupertinoIcons.heart)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.messenger_outline))
                ],
              ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: width > webScreenSize ? width * 0.3 : 0,
                        vertical: width > webScreenSize ? 15 : 0),
                    child:
                        AppPostCard(snap: snapshot.data!.docs[index].data())));
          },
        ));
  }
}
