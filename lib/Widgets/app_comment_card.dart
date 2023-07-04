import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppCommentCard extends StatefulWidget {
  final snap;
  const AppCommentCard({super.key,required this.snap});

  @override
  State<AppCommentCard> createState() => _AppCommentCardState();
}

class _AppCommentCardState extends State<AppCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18,horizontal: 16),
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
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.snap['name']}',
                          style: const TextStyle(fontWeight: FontWeight.bold)
                        ),
                        const TextSpan(
                            text: ' ',
                            style: TextStyle(fontWeight: FontWeight.bold)
                        ),
                        TextSpan(
                            text: '${widget.snap['text']}',
                        )
                      ]
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(fontWeight: FontWeight.w400),),
                  )
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.favorite_border_outlined,size: 16,),
          )
        ],
      ),
    );
  }
}
