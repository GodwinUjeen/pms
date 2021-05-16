import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pms/LoginPage/LoginPage.dart';
import 'package:pms/Staff/StaffHomePage.dart';
import 'package:pms/Student/StudentHomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userUid;
String userProfession;

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Future getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userUid = sharedPreferences.getString('uid');
    userProfession = sharedPreferences.getString('profession');
  }

  String userId;
  String prof;

  @override
  void initState() {
    getUid().whenComplete(() {
      print(userUid);
      print(userProfession);
      userUid == null
          ? LoginPage()
          : userProfession == 'student'
          ? StudentHomePage()
          : userProfession == 'staff'
          ? StaffHomePage()
          : LoginPage();
      userId = userUid;
      prof = userProfession;
      print(userId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<LogUser>(context);
    // print(user);

    // if (user == null) {
    //   return LoginPage();
    // } else {
    //   return StudentHomePage();
    // }

    // final user = context.watch<User>();

    if (userId == null) {
      print(userUid);
      return WillPopScope(
        onWillPop: () {
          exitApp();
          return null;
        },
        child: LoginPage(),
      );
    } else {
      print(userUid);
      print('entered');
      // if (prof == 'student') {
      //   print(prof);
      //   return WillPopScope(
      //       onWillPop: () {
      //         exitApp();
      //         return null;
      //       },
      //       child: StudentHomePage(
      //         userUid: userUid,
      //       ));
      // } else if (prof == 'staff') {
      //   print(prof);
      //   return WillPopScope(
      //       onWillPop: () {
      //         exitApp();
      //         return null;
      //       },
      //       child: StaffHomePage(
      //         userUid: userUid,
      //       ));
      // } else {
      //   return LoginPage();
      // }
    }
  }

  void exitApp() {
    SystemNavigator.pop();
  }
}
