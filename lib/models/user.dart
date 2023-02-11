import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String uid;
  final String bio;
  final List followers;
  final List following;
  final String profilePhotoUrl;

  User(
      {required this.username,
      required this.email,
      required this.uid,
      required this.bio,
      required this.followers,
      required this.following,
      required this.profilePhotoUrl});

  Map<String, dynamic> returnMap() {
    return {
      'username': username,
      'email': email,
      'uid': uid,
      'bio': bio,
      'followers': [],
      'following': [],
      'profile-photo': profilePhotoUrl,
    };
  }

  static User fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;

    return User(
      username: snap['username'],
      email: snap['email'],
      uid: snap['uid'],
      bio: snap['bio'],
      followers: snap['followers'],
      following: snap['following'],
      profilePhotoUrl: snap['profile-photo'],
    );
  }
}
