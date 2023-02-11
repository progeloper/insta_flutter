import 'package:insta_flutter/resources/auth_methods.dart';
import '../models/user.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User? _user; // = User(username: 'username', email: 'email', uid: 'uid', bio: 'bio', followers: [], following: [], profilePhotoUrl: 'profilePhotoUrl');
  final AuthMethods _authMethods = AuthMethods();


  User? get getUser => _user;

  Future<void> refreshUser() async {
    User user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }

}