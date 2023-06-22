import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Widgets/app_post_card.dart';
import 'package:insta_clone/utilities/colors.dart';


class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        centerTitle: false,
        title: Image.asset(
          'assets/ig_logo.png',
          color: primaryColor,
          height: 50,),
        actions: [
          IconButton(
              onPressed: (){},
              icon: const Icon(CupertinoIcons.heart)
          ),
          IconButton(
              onPressed: (){},
              icon: const Icon(Icons.messenger_outline)
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot<Map<String,dynamic>>>snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
              itemBuilder: (context,index) =>AppPostCard(
                snap:snapshot.data!.docs[index].data()
              )
          );
        },
      )
    );
  }
}
