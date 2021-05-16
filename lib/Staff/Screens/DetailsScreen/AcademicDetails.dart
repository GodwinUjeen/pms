import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/Student/Screens/Attendance.dart';
import 'package:pms/Student/Screens/InternalMarks.dart';
import 'package:pms/Student/Screens/OnlineCertifications.dart';
import 'package:pms/Student/Screens/PaperPresentations.dart';
import 'package:pms/Student/Screens/Project.dart';
import 'package:pms/Student/Screens/SemesterMarks.dart';
import 'package:pms/Student/Screens/Seminar.dart';
import 'package:pms/Student/Screens/Workshop.dart';

class AcademicDetails extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;
  final String userName;
  final String rollNo;
  final String image;

  AcademicDetails(
      {this.userDep,
      this.userYear,
      this.userUid,
      this.userName,
      this.rollNo,
      this.image});

  @override
  _AcademicDetailsState createState() => _AcademicDetailsState();
}

class _AcademicDetailsState extends State<AcademicDetails> {
  @override
  Widget build(BuildContext context) {
    // print('Academic Details');
    // print('Year: ${widget.userYear}');
    // print('Dep: ${widget.userDep}');
    // print('UID: ${widget.userUid}');
    print(widget.userName);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Academic Details"),
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 8.0),
              child: Container(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10.0),
                width: MediaQuery.of(context).size.width * 0.8,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150.0,
                          child: Text(
                            'NAME : ${widget.userName.toUpperCase()}',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          'DEP : B.E.${widget.userDep.toUpperCase()}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                        Text(
                          'ROLL.NO : ${widget.rollNo.toUpperCase()}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Container(
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: Colors.white,
                            width: 3.0,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 60.0,
                          backgroundColor: Colors.transparent,
                          child: GestureDetector(
                            child: Image.network(
                              widget.image,
                              loadingBuilder: (BuildContext context,
                                  Widget child,
                                  ImageChunkEvent loadingProgress) {
                                if (loadingProgress == null)
                                  return CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 40,
                                    backgroundImage: NetworkImage(
                                      widget.image,
                                    ),
                                  );
                                return Center(
                                  child: CircularProgressIndicator(
                                    // valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes
                                        : null,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25.0, left: 25.0),
              child: Divider(
                color: Colors.grey.shade400,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
              child: Container(
                alignment: Alignment.center,
                // color: Colors.blueGrey,
                height: MediaQuery.of(context).size.height * 0.5,
                child: GridView.count(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 2,
                  padding: EdgeInsets.all(4.0),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    //2 Internal Marks
                    iconsLandingPage("assets/icons/internal.png", () {
                      // print('Internal Mark\'s');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: InternalMarks(
                                userDep: widget.userDep,
                                userUid: widget.userUid,
                                userYear: widget.userYear,
                              ),
                              type: PageTransitionType.leftToRight));
                    }, "Internal\nMarks"),
                    //3 Semester Marks
                    iconsLandingPage("assets/icons/semester.png", () {
                      // print('Semester');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: SemesterMarks(
                                userDep: widget.userDep,
                                userUid: widget.userUid,
                                userYear: widget.userYear,
                              ),
                              type: PageTransitionType.leftToRight));
                    }, "Exam Results"),
                    //4 Attendance Details
                    iconsLandingPage("assets/icons/attendance.png", () {
                      // print('Attendance');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: AttendanceDetails(
                                userDep: widget.userDep,
                                userUid: widget.userUid,
                                userYear: widget.userYear,
                              ),
                              type: PageTransitionType.leftToRight));
                    }, "Attendance"),
                    //5 Online Certifications
                    iconsLandingPage("assets/icons/oc.png", () {
                      // print('Online Certification');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: OnlineCertifications(
                                userDep: widget.userDep,
                                userUid: widget.userUid,
                                userYear: widget.userYear,
                              ),
                              type: PageTransitionType.leftToRight));
                    }, "Online\nCertification"),
                    //6 Paper presentations
                    iconsLandingPage("assets/icons/paper.png", () {
                      // print('Paper Presentation');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: PaperPresentation(
                                userDep: widget.userDep,
                                userUid: widget.userUid,
                                userYear: widget.userYear,
                              ),
                              type: PageTransitionType.leftToRight));
                    }, "Paper\nPresentation"),
                    //7 Project Details
                    iconsLandingPage("assets/icons/project.png", () {
                      // print('Projects');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: ProjectDetails(
                                userDep: widget.userDep,
                                userUid: widget.userUid,
                                userYear: widget.userYear,
                              ),
                              type: PageTransitionType.leftToRight));
                    }, "Projects"),
                    //8 Seminar Details
                    iconsLandingPage("assets/icons/seminar.png", () {
                      // print('Seminars');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: Seminars(
                                userDep: widget.userDep,
                                userUid: widget.userUid,
                                userYear: widget.userYear,
                              ),
                              type: PageTransitionType.leftToRight));
                    }, "Seminars"),
                    //9 Workshop Details
                    iconsLandingPage("assets/icons/workshop.png", () {
                      // print('Workshop');
                      Navigator.push(
                          context,
                          PageTransition(
                              child: WorkshopDetails(
                                userDep: widget.userDep,
                                userUid: widget.userUid,
                                userYear: widget.userYear,
                              ),
                              type: PageTransitionType.leftToRightWithFade));
                    }, "Workshops"),
                  ],
                ),
              ),
            ),
          ],
        ),
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
