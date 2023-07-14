import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/Resources/firestore_methods.dart';
import 'package:insta_clone/Widgets/app_like_animation.dart';
import 'package:intl/intl.dart';

class AppCommentCard extends StatefulWidget {
  final snap;
  final String postId;

  const AppCommentCard({super.key, required this.snap, required this.postId});

  @override
  State<AppCommentCard> createState() => _AppCommentCardState();
}

class _AppCommentCardState extends State<AppCommentCard> {
  @override
  Widget build(BuildContext context) {
    print(widget.postId);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: '${widget.snap['name']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const TextSpan(
                          text: ' ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: '${widget.snap['text']}',
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
          ),
          AppLikeAnimation(
            isAnimated: widget.snap['likes']
                .contains(FirebaseAuth.instance.currentUser!.uid),
            smallLike: true,
            child: IconButton(
              onPressed: () async {
                print('Comment likebutton pressed');
                await FireStoreMethods().likeComment(
                    postId: widget.postId,
                    commentId: widget.snap['commentId'],
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    likes: widget.snap['likes']);
              },
              icon: widget.snap['likes']
                      .contains(FirebaseAuth.instance.currentUser!.uid)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    )
                  : const Icon(
                      Icons.favorite_border_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
            ),
          )
        ],
      ),
    );
  }
}
