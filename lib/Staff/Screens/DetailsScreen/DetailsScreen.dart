import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/Constants/ConstantColors.dart';
import 'package:pms/Staff/Screens/DetailsScreen/ListScreen.dart';
import 'package:pms/Staff/StaffHomePage.dart';

class DetailsScreen extends StatefulWidget {
  final String userDep;

  DetailsScreen({this.userDep});

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushReplacement(
            context,
            PageTransition(
                child: StaffHomePage(),
                type: PageTransitionType.leftToRightWithFade));
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Student Details'),
        ),
        backgroundColor: constantColors.whiteColor,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
              child: Container(
                height: 60.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black45,
                          blurRadius: 4.0,
                          spreadRadius: 1),
                    ],
                    border: Border.all(color: constantColors.amber, width: 3.0),
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white),
                child: Center(
                    child: Text(
                  'Department Of ${widget.userDep.toUpperCase()}',
                  style: TextStyle(fontSize: 20.0, color: Colors.brown),
                )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                // height: MediaQuery.of(context).size.height,
                child: GridView.count(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 15.0,
                  mainAxisSpacing: 15.0,
                  padding: EdgeInsets.all(20.0),
                  children: [
                    yearButton('I', widget.userDep, 'st'),
                    yearButton('II', widget.userDep, 'nd'),
                    yearButton('III', widget.userDep, 'rd'),
                    yearButton('IV', widget.userDep, 'th')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget yearButton(String title, String userDep, String subScript) {
    return MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            side: BorderSide(color: Colors.amber, width: 3.0)),
        color: constantColors.whiteColor,
        splashColor: constantColors.backgroundAmber,
        elevation: 8.0,
        child: EasyRichText(
          "$title $subScript Year",
          defaultStyle: TextStyle(fontSize: 30.0, color: Colors.brown),
          patternList: [
            EasyRichTextPattern(
              targetString: subScript,
              superScript: true,
              matchWordBoundaries: false,
              style: TextStyle(color: Colors.brown, fontSize: 25.0),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            PageTransition(
              child: ListScreen(
                year: title,
                dep: widget.userDep,
              ),
              type: PageTransitionType.leftToRight,
            ),
          );
        });
  }
}
