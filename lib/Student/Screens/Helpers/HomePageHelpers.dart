import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/Constants/About.dart';
import 'package:pms/Constants/ConstantColors.dart';
import 'package:pms/Loading.dart';
import 'package:pms/LoginPage/LoginPage.dart';
import 'package:pms/Student/Screens/Profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePageHelpers with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  ConstantColors constantColors = ConstantColors();

  Widget homePageDrawer(
      BuildContext context, String userDep, String userYear, String userUid) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('student')
                  .doc(userDep)
                  .collection(userYear)
                  .doc(userUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Loading(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Loading(),
                  );
                } else {
                  return DrawerHeader(
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[
                          Colors.amber.shade200,
                          Colors.amberAccent,
                          Colors.amber
                        ],
                      ),
                    ),
                    child: UserAccountsDrawerHeader(
                      currentAccountPicture: CircleAvatar(
                        backgroundColor: constantColors.transparent,
                        backgroundImage:
                            NetworkImage(snapshot.data.data()['userimage']),
                      ),
                      accountName: Text(
                        snapshot.data.data()['name'].toString().toUpperCase(),
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      accountEmail: Text(
                        snapshot.data
                            .data()['useremail']
                            .toString()
                            .toLowerCase(),
                        style: TextStyle(
                          fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }
              }),
          CustomListTile(Icons.person_pin_outlined, 'Profile', () {
            Navigator.push(
                context,
                PageTransition(
                    child: ProfileDetails(
                      userDep: userDep,
                      userUid: userUid,
                      userYear: userYear,
                      title: 'Your Profile',
                    ),
                    type: PageTransitionType.leftToRight));
          }),
          CustomListTile(Icons.settings, 'Settings', () {}),
          CustomListTile(Icons.logout, 'Log Out', () async {
            logOutDialog(context);
          }),
          CustomListTile(Icons.info_outline_rounded, 'About', () {
            Navigator.push(
                context,
                PageTransition(
                    child: AboutScreen(),
                    type: PageTransitionType.leftToRight));
          }),
        ],
      ),
    );
  }

  logOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: constantColors.darkColor.withOpacity(0.8),
            title: Text(
              'Log Out ? ',
              style: TextStyle(
                color: constantColors.whiteColor,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              MaterialButton(
                  child: Text(
                    'No',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: constantColors.whiteColor,
                      decoration: TextDecoration.underline,
                      decorationColor: constantColors.whiteColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              MaterialButton(
                  color: constantColors.redColor,
                  child: Text(
                    'Yes',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      color: constantColors.whiteColor,
                    ),
                  ),
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.clear().whenComplete(() {
                      _auth.signOut();
                    }).whenComplete(() {
                      Navigator.pushReplacement(
                          context,
                          PageTransition(
                              child: LoginPage(),
                              type: PageTransitionType.leftToRight));
                    });
                  }),
            ],
          );
        });
  }
}

// Custom List Tile  for Navigation drawer
class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;

  CustomListTile(this.icon, this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15.0, 0, 8.0, 0),
      child: InkWell(
        splashColor: Colors.amberAccent.shade200,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          height: 55.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    icon,
                    color: Colors.indigo.shade500,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.indigo.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
