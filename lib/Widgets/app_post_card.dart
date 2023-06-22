import 'package:flutter/material.dart';
import 'package:insta_clone/utilities/colors.dart';
import 'package:intl/intl.dart';

class AppPostCard extends StatefulWidget {
  const AppPostCard({super.key, required this.snap});
  final snap;

  @override
  State<AppPostCard> createState() => _AppPostCardState();
}

class _AppPostCardState extends State<AppPostCard> {
  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            height: MediaQuery.of(context).size.height*0.35,
            width: double.infinity,
            child: Image.network(
              widget.snap['postURL'],
              fit: BoxFit.cover,
            ),
          ),

          //Like,Comment Section
          _likeAndCommentsSection(context),

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
                        onTap: (){ print('Delete Post');},
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
  
  Widget _likeAndCommentsSection(BuildContext context){
    return Row(
      children: [
        //Like Button
        IconButton(
            onPressed: (){}, 
            icon: const Icon(Icons.favorite,color: Colors.red,)
        ),

        //Comments Button
        IconButton(
            onPressed: (){},
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
              child: Text('View all 1000 comments',
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
