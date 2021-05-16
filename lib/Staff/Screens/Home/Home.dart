import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pms/Constants/ConstantColors.dart';
import 'package:pms/HelpersClass/Helpers.dart';
import 'package:pms/Loading.dart';
import 'package:pms/Staff/Helpers/StaffHomePageHelpers.dart';
import 'package:provider/provider.dart';

class StaffHome extends StatefulWidget {
  final String userDep;
  final String authUserUid;

  StaffHome({this.userDep, this.authUserUid});

  @override
  _StaffHomeState createState() => _StaffHomeState();
}

class _StaffHomeState extends State<StaffHome> {
  ConstantColors constantColors = ConstantColors();
  OverlayEntry _popupDialog;
  ImageChunkEvent loadingProgress;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: constantColors.whiteColor,
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
        endDrawer: Provider.of<StaffHomePageHelpers>(context, listen: false)
            .homePageDrawer(context, widget.userDep, widget.authUserUid),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('staff')
              .doc(widget.userDep)
              .collection('staffdetails')
              .doc(widget.authUserUid)
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
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(25.0),
                  // ),
                  color: constantColors.whiteColor,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 20.0, 8.0, 8.0),
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
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: new Border.all(
                                color: Colors.indigoAccent.shade400,
                                width: 3.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 75.0,
                              backgroundColor: Colors.transparent,
                              child: GestureDetector(
                                onLongPress: () {
                                  _popupDialog = _createPopupDialog(
                                    snapshots.data.data()['userimage'],
                                  );
                                  Overlay.of(context).insert(_popupDialog);
                                },
                                // remove the OverlayEntry from Overlay, so it would be hidden
                                onLongPressEnd: (details) =>
                                    _popupDialog?.remove(),
                                child: Image.network(
                                  snapshots.data.data()['userimage'],
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null)
                                      return CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 75,
                                        backgroundImage: NetworkImage(
                                          snapshots.data.data()['userimage'],
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
                        Provider.of<Helpers>(context, listen: false)
                            .headingWidget(context, 'Profile'),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context, 'Name', snapshots.data.data()['name']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Staff Id',
                            snapshots.data.data()['staffno']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Designation',
                            snapshots.data.data()['designation']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Qualification',
                            snapshots.data.data()['qualification']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Experience',
                            snapshots.data.data()['experience']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'Specialization',
                            snapshots.data.data()['specialization']),
                        Provider.of<Helpers>(context, listen: false).textWidget(
                            context,
                            'E-Mail',
                            snapshots.data.data()['useremail']),
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
