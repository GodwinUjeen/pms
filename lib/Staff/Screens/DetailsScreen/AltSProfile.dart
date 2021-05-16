import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/HelpersClass/Helpers.dart';
import 'package:pms/Loading.dart';
import 'package:pms/Staff/Screens/DetailsScreen/AcademicDetails.dart';
import 'package:provider/provider.dart';

class AltSProfile extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;
  final String title;
  final String userName;
  final String rollNo;
  final String image;

  AltSProfile(
      {this.userDep,
      this.userUid,
      this.userYear,
      this.title,
      this.userName,
      this.rollNo,
      this.image});

  @override
  _AltSProfileState createState() => _AltSProfileState();
}

class _AltSProfileState extends State<AltSProfile> {
  OverlayEntry _popupDialog;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    // print("Current User : ${_auth.currentUser.uid}");
    // print(widget.userName);
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  // print('Academic details');
                  Navigator.push(
                    context,
                    PageTransition(
                      child: AcademicDetails(
                        userDep: widget.userDep,
                        userUid: widget.userUid,
                        userYear: widget.userYear,
                        userName: widget.userName,
                        rollNo: widget.rollNo,
                        image: widget.image,
                      ),
                      type: PageTransitionType.leftToRight,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                ),
                icon: Icon(
                  Icons.auto_stories,
                  color: Colors.white,
                ),
                label: Text(
                  'Academic\nDetails',
                  style: TextStyle(fontSize: 10.0, color: Colors.white),
                ),
              ),
            )
          ],
          title: Text(
            widget.title,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.brown.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.userDep)
              .collection(widget.userYear)
              .doc(widget.userUid)
              .collection('profile')
              .doc('studentprofile')
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: Loading(),
              );
            } else {
              // print(snapshots.data.data()['name']);
              return Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.9,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.indigo, width: 1.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
//*********************************   Header  *******************************************
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, left: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: Container(
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: new Border.all(
                                      color: Colors.amber,
                                      width: 3.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundColor: Colors.transparent,
                                    child: GestureDetector(
                                      onLongPress: () {
                                        _popupDialog = _createPopupDialog(
                                          snapshots.data.data()['image'],
                                        );
                                        Overlay.of(context)
                                            .insert(_popupDialog);
                                      },
                                      // remove the OverlayEntry from Overlay, so it would be hidden
                                      onLongPressEnd: (details) =>
                                          _popupDialog?.remove(),
                                      child: Image.network(
                                        snapshots.data.data()['image'],
                                        loadingBuilder: (BuildContext context,
                                            Widget child,
                                            ImageChunkEvent loadingProgress) {
                                          if (loadingProgress == null)
                                            return CircleAvatar(
                                              backgroundColor:
                                                  Colors.transparent,
                                              radius: 75,
                                              backgroundImage: NetworkImage(
                                                snapshots.data.data()['image'],
                                              ),
                                            );
                                          return Center(
                                            child: CircularProgressIndicator(
                                              // valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 170.0,
                                width: 1.0,
                                color: Colors.grey,
                              ),
                              Container(
                                // color: Colors.blue.shade100,
                                height: 220.0,
                                width: MediaQuery.of(context).size.width * 0.55,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    //Name
                                    textFieldRows('Name   : ',
                                        snapshots.data.data()['name']),
                                    //Reg.NO
                                    textFieldRows(
                                        'Reg.No : ',
                                        snapshots.data
                                            .data()['regno']
                                            .toString()),
                                    //Roll. No
                                    textFieldRows('Roll.No : ',
                                        snapshots.data.data()['rollno']),
                                    //Degree & Branch
                                    textFieldRows('Degree & Branch : ',
                                        snapshots.data.data()['branch']),
                                    textFieldRows('E-Mail : ',
                                        snapshots.data.data()['email']),
                                    //Gender
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
//*******************************   Body  ***********************************
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'PERSONAL'),
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'Basic Information '),

                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context, 'Name', snapshots.data.data()['name']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Nationality',
                            snapshots.data.data()['nationality']),

                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context, 'State', snapshots.data.data()['state']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context, 'Gender', snapshots.data.data()['gender']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Age',
                            snapshots.data.data()['age'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context, 'D.O.B', snapshots.data.data()['dob']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Religion',
                            snapshots.data.data()['religion']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Community',
                            snapshots.data.data()['community']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context, 'Caste', snapshots.data.data()['caste']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Place Of Birth',
                            snapshots.data.data()['placeofbirth']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Mother Tongue',
                            snapshots.data.data()['mothertongue']),
//Family INFO
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'Family Information'),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Father Name',
                            snapshots.data.data()['fathername']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Father Contact No',
                            snapshots.data.data()['fcontactno'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Mother Name',
                            snapshots.data.data()['mothername']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Mother Contact No',
                            snapshots.data.data()['mcontactno'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Father Occupation',
                            snapshots.data.data()['foccupation']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Mother Occupation',
                            snapshots.data.data()['moccupation']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Father Company Name',
                            snapshots.data.data()['fcompanyname']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Annual Family Income',
                            snapshots.data.data()['annualincome'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Father Educational Qualification',
                            snapshots.data.data()['feduqualification']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Mother Educational Qualification',
                            snapshots.data.data()['meduqualification']),
//Contact Info
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'Contact Information'),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Student Phone No',
                            snapshots.data.data()['phnno'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'E-mail Address',
                            snapshots.data.data()['email']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Temporary Address Line 1',
                            snapshots.data.data()['tempaddressline1']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Temporary Address Line 2',
                            snapshots.data.data()['tempaddressline2']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context, 'City', snapshots.data.data()['tempcity']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Pin Code',
                            snapshots.data.data()['temppincode'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'State',
                            snapshots.data.data()['tempstate']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Country',
                            snapshots.data.data()['tempcountry']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Comm Address Line 1',
                            snapshots.data.data()['commaline1']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Comm Address Line 2',
                            snapshots.data.data()['commaline2']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Comm City',
                            snapshots.data.data()['commcity']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Comm Pin Code',
                            snapshots.data.data()['commpincode'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Comm State',
                            snapshots.data.data()['commstate']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Comm Country',
                            snapshots.data.data()['commcountry']),
//Educational Details
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'Educational Details'),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'School Studied',
                            snapshots.data.data()['school']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Marks Scored in 10th',
                            snapshots.data.data()['10thmark'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'MArks Scored in +2',
                            snapshots.data.data()['12thmark'].toString()),
//Language Details
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'Languages Known'),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Languages Known',
                            snapshots.data.data()['langknown']),
//Identity Info
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'Identity Information'),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Student Aadhaar Number',
                            snapshots.data.data()['saadhaarnum']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Blood Group',
                            snapshots.data.data()['bloodgroup']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Weight',
                            snapshots.data.data()['weight'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Height',
                            snapshots.data.data()['height'].toString()),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Identity Mark 1',
                            snapshots.data.data()['idmark1']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Identity Mark 2',
                            snapshots.data.data()['idmark2']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Resident Status',
                            snapshots.data.data()['residentstatus']),

                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Student Pan Number',
                            snapshots.data.data()['pannum']),
//Other Details
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'Other Details'),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Day Scholar/Hosteler',
                            snapshots.data.data()['dsorhs']),
                        snapshots.data.data()['dsorhs'] == 'day scholar'
                            ? Column(
                                children: [
                                  Provider.of<Helpers>(context, listen: false)
                                      .headingWidget(context, 'Day Scholar'),
                                  Provider.of<Helpers>(context, listen: false)
                                      .textWidget(
                                          context,
                                          'Mode of Transport',
                                          snapshots.data
                                              .data()['modeoftransport']),
                                  snapshots.data.data()['modeoftransport'] ==
                                          'college bus'
                                      ? Provider.of<Helpers>(context,
                                              listen: false)
                                          .textWidget(
                                              context,
                                              'College Bus No',
                                              snapshots.data
                                                  .data()['busno']
                                                  .toString())
                                      : snapshots.data
                                                  .data()['modeoftransport'] ==
                                              'own vehicle'
                                          ? Column(
                                              children: [
                                                Provider.of<Helpers>(context,
                                                        listen: false)
                                                    .textWidget(
                                                        context,
                                                        'Name of Vehicle',
                                                        snapshots.data.data()[
                                                            'vehiclename']),
                                                Provider.of<Helpers>(context,
                                                        listen: false)
                                                    .textWidget(
                                                        context,
                                                        'Registration No',
                                                        snapshots.data.data()[
                                                            'vehicleregno']),
                                                Provider.of<Helpers>(context,
                                                        listen: false)
                                                    .textWidget(
                                                        context,
                                                        'Driving License No',
                                                        snapshots.data.data()[
                                                            'licenseno']),
                                              ],
                                            )
                                          : snapshots.data.data()[
                                                      'modeoftransport'] ==
                                                  'private bus'
                                              ? Container(
                                                  width: 0.0,
                                                  height: 0.0,
                                                )
                                              : Container(
                                                  width: 0.0,
                                                  height: 0.0,
                                                ),
                                ],
                              )
                            : snapshots.data.data()['dsorhs'] == 'hosteler'
                                ? Column(
                                    children: [
                                      Provider.of<Helpers>(context,
                                              listen: false)
                                          .headingWidget(context, 'Hosteler'),
                                      Provider.of<Helpers>(context,
                                              listen: false)
                                          .textWidget(
                                              context,
                                              'Room No',
                                              snapshots.data
                                                  .data()['roomno']
                                                  .toString()),
                                      Provider.of<Helpers>(context,
                                              listen: false)
                                          .textWidget(
                                              context,
                                              'Address of Local Guardian Line 1',
                                              snapshots.data
                                                  .data()['laddline1']),
                                      Provider.of<Helpers>(context,
                                              listen: false)
                                          .textWidget(
                                              context,
                                              'Address Line 2',
                                              snapshots.data
                                                  .data()['laddline2']),
                                      Provider.of<Helpers>(context,
                                              listen: false)
                                          .textWidget(context, 'City',
                                              snapshots.data.data()['lcity']),
                                      Provider.of<Helpers>(context,
                                              listen: false)
                                          .textWidget(
                                              context,
                                              'Pin Code',
                                              snapshots.data
                                                  .data()['lpincode']
                                                  .toString()),
                                    ],
                                  )
                                : Container(
                                    width: 0.0,
                                    height: 0.0,
                                  ),

                        SizedBox(
                          height: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  OverlayEntry _createPopupDialog(String url) {
    return OverlayEntry(
      builder: (context) => AnimatedDialog(
        child: _createPopupContent(url),
      ),
    );
  }

  Widget _createPopupContent(String url) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.0),
          child: Image.network(url, fit: BoxFit.fitWidth),
        ),
      );
}

Widget textFieldRows(String heading, String value) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          heading,
          maxLines: 2,
          style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        Flexible(
          child: Text(
            value.toUpperCase(),
            maxLines: 2,
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
        )
      ],
    ),
  );
}

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> opacityAnimation;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));

    controller.addListener(() => setState(() {}));
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: FadeTransition(
          opacity: scaleAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
