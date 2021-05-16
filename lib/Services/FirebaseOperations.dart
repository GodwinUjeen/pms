import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseOperations with ChangeNotifier {
  // FirebaseAuth _auth = FirebaseAuth.instance;
  String initUserEmail;
  String initUserRollNo;
  String initUserProfession;
  String userDep;
  String userYear;

  String get getUserDep => userDep;

  String get getUserYear => userYear;

  String get getInitUserEmail => initUserEmail;

  String get getInitUserRollNo => initUserRollNo;

  String get getInitUserProfession => initUserProfession;

  Future initUserData(BuildContext context, String username) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .get()
        .then((doc) {
      initUserProfession = doc.data()['profession'];
      userDep = doc.data()['dep'];
      userYear = doc.data()['year'] ?? '';
      // print(userDep);
      // print(userYear);
      // print(initUserProfession);

      sharedPreferences.setString('profession', initUserProfession);
      sharedPreferences.setString('year', userYear);
      sharedPreferences.setString('dep', userDep);

      notifyListeners();
    });
  }

// Future loadUserData(BuildContext context, String dep, String year) async {
//   print('loadUserData : ${_auth.currentUser.uid}');
//   FirebaseFirestore.instance
//       .collection('student')
//       .doc(dep)
//       .collection(year)
//       .doc(_auth.currentUser.uid)
//       .get()
//       .then((doc) {
//     print('Fetching User Data!!!');
//     initUserRollNo = doc.data()['rollno'];
//     initUserEmail = doc.data()['useremail'];
//     print(doc.data()['name']);
//     print(doc.data()['year']);
//     print(doc.data()['dep']);
//     print(doc.data()['profession']);
//     print(initUserRollNo);
//     print(initUserEmail);
//
//     notifyListeners();
//   });
// }
}
