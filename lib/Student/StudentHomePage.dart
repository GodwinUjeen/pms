import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/Constants/ConstantColors.dart';
import 'package:pms/Loading.dart';
import 'package:pms/Student/Screens/Attendance.dart';
import 'package:pms/Student/Screens/FacultyDetails.dart';
import 'package:pms/Student/Screens/Helpers/HomePageHelpers.dart';
import 'package:pms/Student/Screens/InternalMarks.dart';
import 'package:pms/Student/Screens/OnlineCertifications.dart';
import 'package:pms/Student/Screens/PaperPresentations.dart';
import 'package:pms/Student/Screens/Profile.dart';
import 'package:pms/Student/Screens/Project.dart';
import 'package:pms/Student/Screens/SemesterMarks.dart';
import 'package:pms/Student/Screens/Seminar.dart';
import 'package:pms/Student/Screens/Workshop.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

String userdep;
String useryear;

class StudentHomePage extends StatefulWidget {
  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  ConstantColors constantColors = ConstantColors();
  FirebaseAuth _auth = FirebaseAuth.instance;
  String authUserUid;
  bool _loading = false;

  Future getUid() async {
    _loading = true;
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userdep = sharedPreferences.getString('dep');
    useryear = sharedPreferences.getString('year');
  }

  // load(String dep, String year) async {
  //   await Provider.of<FirebaseOperations>(context, listen: false)
  //       .loadUserData(context, dep, year);
  // }

  @override
  void initState() {
    getUid().whenComplete(() {
      // print(userdep);
      // print(useryear);
      // load(userdep, useryear);
    }).whenComplete(() {
      setState(() {
        _loading = false;
      });
    });
    // load();
    authUserUid = _auth.currentUser.uid;
    print('authUid :$authUserUid');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            endDrawer: Provider.of<HomePageHelpers>(context, listen: false)
                .homePageDrawer(context, userdep, useryear, authUserUid),
            backgroundColor: constantColors.backgroundAmber,
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  'PMS',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            body: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('student')
                  .doc(userdep)
                  .collection(useryear)
                  .doc(authUserUid)
                  .snapshots(),
              builder: (context, snapshots) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Loading(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
                            child: Container(
                              // color: Colors.lightBlueAccent,
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50.0,
                              child: Text(
                                'Welcome! to PMS',
                                style: TextStyle(
                                    fontSize: 30.0,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal),
                              ),
                            ),
                          ),
                          // SizedBox(
                          //   height: 10.0,
                          // ),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
                            child: Container(
                              alignment: Alignment.center,
                              // color: Colors.blueGrey,
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: GridView.count(
                                crossAxisCount: 3,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 2,
                                padding: EdgeInsets.all(4.0),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                children: <Widget>[
                                  //1 Your Profile
                                  iconsLandingPage("assets/icons/profile.png",
                                      () {
                                    // print('Student Profile');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: ProfileDetails(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                              title: 'Your Profile',
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  }, "Your\nProfile"),
                                  //2 Internal Marks
                                  iconsLandingPage("assets/icons/internal.png",
                                      () {
                                    // print('Internal Mark\'s');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: InternalMarks(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  }, "Internal\nMarks"),
                                  //3 Semester Marks
                                  iconsLandingPage("assets/icons/semester.png",
                                      () {
                                    // print('Semester');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: SemesterMarks(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  }, "Exam Results"),
                                  //4 Attendance Details
                                  iconsLandingPage(
                                      "assets/icons/attendance.png", () {
                                    // print('Attendance');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: AttendanceDetails(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  }, "Attendance"),
                                  //5 Online Certifications
                                  iconsLandingPage("assets/icons/oc.png", () {
                                    // print('Online Certification');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: OnlineCertifications(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  }, "Online\nCertification"),
                                  //6 Paper presentations
                                  iconsLandingPage("assets/icons/paper.png",
                                      () {
                                    // print('Paper Presentation');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: PaperPresentation(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  }, "Paper\nPresentation"),
                                  //7 Project Details
                                  iconsLandingPage("assets/icons/project.png",
                                      () {
                                    // print('Projects');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: ProjectDetails(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  }, "Projects"),
                                  //8 Seminar Details
                                  iconsLandingPage("assets/icons/seminar.png",
                                      () {
                                    // print('Seminars');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: Seminars(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                            ),
                                            type: PageTransitionType
                                                .leftToRight));
                                  }, "Seminars"),
                                  //9 Workshop Details
                                  iconsLandingPage("assets/icons/workshop.png",
                                      () {
                                    // print('Workshop');
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: WorkshopDetails(
                                              userDep: userdep,
                                              userUid: authUserUid,
                                              userYear: useryear,
                                            ),
                                            type: PageTransitionType
                                                .leftToRightWithFade));
                                  }, "Workshops"),

                                  //10 Faculty Details
                                  iconsLandingPage("assets/icons/staff.png",
                                      () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            child: FacultyDetails(
                                              userDep: userdep,
                                            ),
                                            type: PageTransitionType
                                                .leftToRightWithFade));
                                  }, "Faculty\nDetails"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          );
  }

  Widget iconsLandingPage(String image, Function function, String tile) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        // color: constantColors.redColor,
        height: 100.0,
        // color: Colors.redAccent.shade100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
              icon: Image.asset(
                image,
              ),
              iconSize: 50.0,
              onPressed: function,
            ),
            Text(
              tile,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0),
            )
          ],
        ),
      ),
    );
  }
}
