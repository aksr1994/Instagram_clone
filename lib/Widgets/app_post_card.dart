
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Providers/user_provider.dart';
import 'package:insta_clone/Resources/firestore_methods.dart';
import 'package:insta_clone/Screens/Comments/comments_screen.dart';
import 'package:insta_clone/Widgets/app_like_animation.dart';
import 'package:insta_clone/utilities/colors.dart';
import 'package:insta_clone/utilities/utils.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../Models/user_model.dart' as model;

class AppPostCard extends StatefulWidget {
  const AppPostCard({super.key, required this.snap});
  final snap;

  @override
  State<AppPostCard> createState() => _AppPostCardState();
}

class _AppPostCardState extends State<AppPostCard> {
  bool isLikeAnimated=false;
  int commentLength=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getComments();
  }

  void getComments()async{
    try{
      QuerySnapshot snap=await FirebaseFirestore.instance.
      collection('posts').
      doc(widget.snap['postId']).
      collection('comments').
      get();

      commentLength=snap.docs.length;
    }catch(e){
      print('Fetch comments Error: $e');
      showSnackBar(context, 'Fetch comments Error: $e');
    }
    setState(() {

    });

  }


  @override
  Widget build(BuildContext context) {
    final model.User? user=Provider.of<UserProvider>(context).getUser;

    //print('TEst: ${widget.snap['likes']}');
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsetsDirectional.symmetric(
        vertical: 10
      ),
      child: Column(
        children: [
          //Header Section
          _postCardHeader(context),

          //Image Section
          GestureDetector(
            onDoubleTap: () async {
              print('Double tapped');
              await FireStoreMethods().likePost(
                  widget.snap['postId'],
                  user!.uid,
                  widget.snap['likes']
              );
              setState(() {
                isLikeAnimated=true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postURL'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimated?1:0,
                  child: AppLikeAnimation(
                      isAnimated: isLikeAnimated,
                      duration: const Duration(milliseconds: 400),
                      onEnd: (){
                        print('OnEnd');
                         setState(() {
                           isLikeAnimated=false;
                         });
                    },
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.white,
                        size: 150,),
                  ),
                )
              ],
            ),
          ),

          //Like,Comment Section
          _likeAndCommentsSection(context,user!.uid),

          //Description and Comment
          _descriptionAndComments(context)
        ],
      ),
    );
  }


  Widget _postCardHeader(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(
          vertical: 4,
          horizontal: 16
      ).copyWith(right: 0),
      child: Row(
        children: [
          //Profile Picture
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(widget.snap['profImage']),
          ),

          //Username
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.snap['username'],style: const TextStyle(fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ),

          //Button for more actions
          IconButton(
              onPressed: (){
                showDialog(context: context, builder: (context){
                  return Dialog(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shrinkWrap: true,
                      children: [
                        'Delete',
                      ].map((e) => InkWell(
                        onTap: (){
                          print('Delete Post');

                          FireStoreMethods().deletePost(widget.snap['postId']);
                          Navigator.of(context).pop();

                          },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical:12,horizontal: 16 ),
                          child: Text(e),
                        ),
                      )).toList(),
                    ),
                  );
                });
              },
              icon: const Icon(Icons.more_vert)
          )
        ],
      ),
    );
  }
  
  Widget _likeAndCommentsSection(BuildContext context,String uid){
    return Row(
      children: [
        //Like Button
        AppLikeAnimation(
          isAnimated: widget.snap['likes'].contains(uid),
          smallLike: true,
          child: IconButton(
              onPressed: ()async{
                await FireStoreMethods().likePost(
                    widget.snap['postId'],
                    uid,
                    widget.snap['likes']
                );
              },
              icon: widget.snap['likes'].contains(uid)
                  ?const Icon(Icons.favorite,color: Colors.red,)
                  :const Icon(Icons.favorite_border,color: Colors.white,)
          ),

        ),

        //Comments Button
        IconButton(
            onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context)=>CommentsScreen(
                    snap:widget.snap
                  )));
            },
            icon: const Icon(Icons.comment_outlined)
        ),

        //Share Button
        IconButton(
            onPressed: (){},
            icon: const Icon(Icons.send)
        ),

        //Bookmark Button
        Expanded(
          child: Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                onPressed: (){},
                icon: const Icon(Icons.bookmark_border)
            ),
          ),
        )
      ],
    );
  }

  Widget _descriptionAndComments(BuildContext context){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.snap['likes'].length} Likes',
            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w800),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 8),
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  color: primaryColor
                ),
                children: [
                  TextSpan(
                    text: widget.snap['username'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  TextSpan(
                    text: ' ${widget.snap['description']}'
                  )
                ]
              ),
            ),
          ),

          //View all comments
          InkWell(
            onTap: (){print('comments more');},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text('View all $commentLength comments',
                style: const TextStyle(
                    fontSize: 16,
                    color:secondaryColor ),
              ),
            ),
          ),

          //Date
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              DateFormat.yMMMd().format(
                  widget.snap['datePublished'].toDate()),
              style: const TextStyle(
                  fontSize: 16,
                  color:secondaryColor ),
            ),
          )
        ],
      ),
    );
  }
}
