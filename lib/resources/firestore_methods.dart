import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_flutter/models/post.dart';
import 'package:insta_flutter/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, String uid, Uint8List file,
      String username, String profilePhotoUrl) async {
    String res = 'Some error occurred';
    try {
      String postUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();

      Post post = Post(
          description: description,
          username: username,
          uid: uid,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: postUrl,
          profImage: profilePhotoUrl,
          likes: []);

      await _firestore.collection('posts').doc(postId).set(post.returnMap());
      res = 'success';
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayRemove([uid])
          },
        );
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(
    String postId,
    String text,
    String uid,
    String name,
    String profilePic,
  ) async {
    String res = 'An error has occurred';
    try {
      if(text.isNotEmpty){
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set(
          {
            'postId': postId,
            'commentId': commentId,
            'profilePic': profilePic,
            'text': text,
            'name': name,
            'uid': uid,
            'datePublished': DateTime.now(),
            'likes': [],
          },
        );
        res = 'success';
      } else{
        res = 'No text was selected';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likeComment(String postId, String uid, String commentId, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update(
          {
            'likes': FieldValue.arrayRemove([uid])
          },
        );
      } else {
        await _firestore.collection('posts').doc(postId).collection('comments').doc(commentId).update(
          {
            'likes': FieldValue.arrayUnion([uid])
          },
        );
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePost(String postId, String uid) async{
    try{
      DocumentSnapshot snap =
          await _firestore.collection('posts').doc(postId).get();
      String postCreator = (snap.data() as Map<String, dynamic>)['uid'];
      if (postCreator == uid) {
        _firestore.collection('posts').doc(postId).delete();
      }
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> followUser(
      String uid,
      String followId
      ) async{
    try{
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];
      if(following.contains(followId)){
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId]),
        });
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid]),
        });
      }
      else{
        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId]),
        });
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid]),
        });
      }
    }catch(e){
      print(e.toString());
    }
  }

}
