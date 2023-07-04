import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Providers/user_provider.dart';
import 'package:insta_clone/Resources/firestore_methods.dart';
import 'package:insta_clone/Widgets/app_comment_card.dart';
import 'package:insta_clone/utilities/colors.dart';
import 'package:provider/provider.dart';

import '../../Models/user_model.dart' as model;

class CommentsScreen extends StatefulWidget {
  final snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentsController=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _commentsController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final model.User? user=Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16,right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user!.photoURL
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0,right: 8),
                  child: TextField(
                    controller: _commentsController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: ()async{
                 await FireStoreMethods().postComment(
                      widget.snap['postId'],
                      _commentsController.text,
                      user.uid,
                      user.username,
                      user.photoURL);
                 setState(() {
                   _commentsController.text="";
                 });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                  child: const Text('Post',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: blueColor
                    ),),
                ),
              )
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.
        collection('posts').
        doc(widget.snap['postId']).
        collection('comments').
        orderBy('datePublished',descending: true).
        snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: (snapshot.data! as dynamic).docs.length,
              itemBuilder: (context,index)=>AppCommentCard(
                snap:(snapshot.data! as dynamic).docs[index]
              )
          );
        },
      ),
    );
  }
}
