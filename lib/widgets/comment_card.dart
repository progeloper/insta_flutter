import 'package:flutter/material.dart';
import 'package:insta_flutter/models/user.dart';
import 'package:insta_flutter/providers/user_provider.dart';
import 'package:insta_flutter/resources/firestore_methods.dart';
import 'package:insta_flutter/utils/colors.dart';
import 'package:insta_flutter/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentCard extends StatefulWidget {
  final Map<String, dynamic> snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${widget.snap['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                LikeAnimation(
                  isAnimating: isLikeAnimating,
                  child: IconButton(
                    onPressed: () {
                      setState(() async {
                        await FirestoreMethods().likeComment(
                            widget.snap['postId'],
                            user!.uid,
                            widget.snap['commentId'],
                            widget.snap['likes']);
                      });
                    },
                    icon: (widget.snap['likes'] as List).contains(user!.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 16,
                          )
                        : const Icon(
                            Icons.favorite_outline,
                            size: 16,
                          ),
                  ),
                ),
                Text(
                  (widget.snap['likes'] as List).length.toString(),
                  style: const TextStyle(color: secondaryColor, fontSize: 12),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
