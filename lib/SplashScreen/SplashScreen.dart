import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/Constants/Background.dart';
import 'package:pms/LoginPage/LoginPage.dart';
import 'package:pms/Staff/StaffHomePage.dart';
import 'package:pms/Student/StudentHomePage.dart';
import 'package:pms/Wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future getUid() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userUid = sharedPreferences.getString('uid');
    userProfession = sharedPreferences.getString('profession');
  }

  void initState() {
    getUid().whenComplete(() {
      print(userUid);
      print(userProfession);
    });
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        PageTransition(
          child: userUid == null
              ? LoginPage()
              : userProfession == 'student'
                  ? StudentHomePage()
                  : userProfession == 'staff'
                      ? StaffHomePage()
                      : LoginPage(),
          type: PageTransitionType.leftToRightWithFade,
        ),
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Background(),
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: Lottie.asset(
                    'assets/animation/splash.json',
                    repeat: false,
                  ),
                ),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'P',
                      style: TextStyle(
                        letterSpacing: 2.0,
                        fontSize: 56.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'M',
                          style: TextStyle(
                            letterSpacing: 2.0,
                            fontSize: 56.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.amberAccent,
                          ),
                        ),
                        TextSpan(
                          text: 'S',
                          style: TextStyle(
                            letterSpacing: 2.0,
                            fontSize: 56.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
