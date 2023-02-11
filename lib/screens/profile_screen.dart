import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:insta_flutter/resources/auth_methods.dart';
import 'package:insta_flutter/resources/firestore_methods.dart';
import 'package:insta_flutter/screens/login_screen.dart';
import 'package:insta_flutter/utils/colors.dart';
import 'package:insta_flutter/utils/utils.dart';

import '../utils/global_variables.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int numOfPosts = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  final currentUser = FirebaseAuth.instance.currentUser!;

  getData() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      userData = snap.data()!;
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      numOfPosts = postSnap.docs.length;
      followers = userData['followers'].length;
      following = userData['following'].length;

      isFollowing = (userData['followers'] as List).contains(currentUser.uid);
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return (userData.isEmpty)
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: MediaQuery.of(context).size.width > webScreenSize
                ? null
                : AppBar(
                    backgroundColor: mobileBackgroundColor,
                    automaticallyImplyLeading: false,
                    title: Text(userData['username']),
                    centerTitle: false,
                  ),
            backgroundColor: MediaQuery.of(context).size.width > webScreenSize
                ? webBackgroundColor
                : mobileBackgroundColor,
            body: ListView(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: secondaryColor,
                            backgroundImage:
                                NetworkImage(userData['profile-photo']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(numOfPosts, 'Posts'),
                                buildStatColumn(followers, 'Followers'),
                                buildStatColumn(following, 'Following'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          currentUser.uid == widget.uid
                              ? Expanded(
                                  child: FollowButton(
                                    buttonText: 'Sign out',
                                    borderColor: Colors.grey,
                                    backgroundColor: mobileBackgroundColor,
                                    textColor: primaryColor,
                                    callback: () async {
                                      await AuthMethods().signOut();
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginScreen(),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : isFollowing
                                  ? Expanded(
                                      child: FollowButton(
                                        buttonText: 'Unfollow',
                                        borderColor: Colors.black,
                                        backgroundColor: Colors.white,
                                        textColor: Colors.black,
                                        callback: () async {
                                          await FirestoreMethods().followUser(
                                              currentUser.uid, userData['uid']);
                                          setState(() {
                                            isFollowing = false;
                                            followers--;
                                          });
                                        },
                                      ),
                                    )
                                  : Expanded(
                                      child: FollowButton(
                                        buttonText: 'Follow',
                                        borderColor: blueColor,
                                        backgroundColor: blueColor,
                                        textColor: primaryColor,
                                        callback: () async {
                                          await FirestoreMethods().followUser(
                                              currentUser.uid, userData['uid']);
                                          setState(() {
                                            isFollowing = true;
                                            followers++;
                                          });
                                        },
                                      ),
                                    ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return LinearProgressIndicator();
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 1.5,
                              crossAxisSpacing: 1.0,
                              childAspectRatio: 1.0),
                      itemBuilder: (context, index) {
                        DocumentSnapshot snap =
                            (snapshot.data! as dynamic).docs[index];
                        return Image(
                          image: NetworkImage(snap['postUrl']),
                          fit: BoxFit.cover,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        Container(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 14),
          ),
        ),
      ],
    );
  }
}
