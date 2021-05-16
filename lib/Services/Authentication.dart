import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pms/models/Model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  String userUid;

  String get getUserUid => userUid;

  dynamic errorMessage;

  dynamic get getErrorMessage => errorMessage;

  //Create user obj based on FireBase User
  FUser _userFromFireBaseUser(User user) {
    return user != null ? FUser(uid: user.uid) : null;
  }

//  Auth change User Stream

  Stream<FUser> get user {
    return firebaseAuth.authStateChanges().map(_userFromFireBaseUser);
  }

  Future logIntoAccount(
      String email, String password, BuildContext context) async {
    try {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      errorMessage = '';
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user;
      userUid = user.uid;
      _userFromFireBaseUser(user);
      print('logIntoAccount: $userUid');

      sharedPreferences.setString('uid', userUid);

      notifyListeners();
    } catch (e) {
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'User Not Found';
          // print(errorMessage);
          break;
        case 'wrong-password':
          errorMessage = 'Oops, wrong password!';
          // print(errorMessage);
          break;
      }
    }
  }

  Future logOut() {
    return firebaseAuth.signOut();
  }
}
