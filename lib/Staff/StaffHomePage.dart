import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/Constants/ConstantColors.dart';
import 'package:pms/Loading.dart';
import 'package:pms/LoginPage/LoginPage.dart';
import 'package:pms/Services/Authentication.dart';
import 'package:pms/Staff/Helpers/StaffHomePageHelpers.dart';
import 'package:pms/Staff/Screens/DetailsScreen/DetailsScreen.dart';
import 'package:pms/Staff/Screens/Home/Home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userDep;
String authUserUid;

class StaffHomePage extends StatefulWidget {
  // final userUid;
  //
  // StaffHomePage({this.userUid});

  @override
  _StaffHomePageState createState() => _StaffHomePageState();
}

class _StaffHomePageState extends State<StaffHomePage> {
  // ConstantColors constantColors = ConstantColors();

  bool _loading = false;

  final PageController homePageController = PageController();
  int pageIndex = 0;

  Future getUid() async {
    _loading = true;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userDep = sharedPreferences.getString('dep');
    authUserUid = sharedPreferences.getString('uid');
  }

  @override
  void initState() {
    getUid().whenComplete(() {
      print(userDep);
      print(authUserUid);
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
          body: PageView(
            controller: homePageController,
            children: [
              StaffHome(
                userDep: userDep,
                authUserUid: authUserUid,
              ),
              DetailsScreen(
                userDep: userDep,
              ),
            ],
            physics: NeverScrollableScrollPhysics(),
            onPageChanged: (page) {
              setState(() {
                pageIndex = page;
              });
            },
          ),
          bottomNavigationBar: Provider.of<StaffHomePageHelpers>(context)
              .bottomNavBar(pageIndex, homePageController),
        );
  }
}
