import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:insta_flutter/models/user.dart' as model;
import 'package:firebase_auth/firebase_auth.dart';
import 'storage_methods.dart';

class AuthMethods{
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snapshot = await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(snapshot);
  }

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file,
      }) async{
    String res = "Some error occurred";
    try {
      if(email.isNotEmpty && password.isNotEmpty && username.isNotEmpty && bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        String? profilePicUrl = await StorageMethods().uploadImageToStorage('profile-pic', file, false);

        model.User user = model.User(
          username: username,
          email: email,
          uid: cred.user!.uid,
          bio: bio,
          followers: [],
          following: [],
          profilePhotoUrl: profilePicUrl,
        );

        await _firestore.collection('users').doc(cred.user!.uid).set(user.returnMap());
      res = 'success';
      }
    } catch(e){
      res = e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password
  }) async{
    String res = 'An error ahs occurred';
    try {
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      res = 'success';
    } catch(err){
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async{
    await _auth.signOut();
  }

}