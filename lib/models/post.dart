import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String username;
  final String uid;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post({
    required this.description,
    required this.username,
    required this.uid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
  });

  Map<String, dynamic> returnMap() {
    return {
      'username': username,
      'description': description,
      'uid': uid,
      'postId': postId,
      'postUrl': postUrl,
      'datePublished': datePublished,
      'profImage': profImage,
      'likes': likes,
    };
  }

  static Post fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return Post(
        username: snap['username'],
        description: snap['description'],
        uid: snap['uid'],
        postId: snap['postId'],
        postUrl: snap['postUrl'],
        datePublished: snap['datePublished'],
        profImage: snap['profImage'],
        likes: snap['likes']);
  }
}
