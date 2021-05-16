import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pms/HelpersClass/Helpers.dart';
import 'package:pms/Loading.dart';
import 'package:provider/provider.dart';

class FacultyDetails extends StatefulWidget {
  final String userDep;

  FacultyDetails({this.userDep});

  @override
  _FacultyDetailsState createState() => _FacultyDetailsState();
}

class _FacultyDetailsState extends State<FacultyDetails> {
  OverlayEntry _popupDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Faculty Details"),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('staff')
            .doc(widget.userDep)
            .collection('staffdetails')
            .snapshots(),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return Center(
              child: Loading(),
            );
          } else {
            return ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children:
                  snapshots.data.docs.map((DocumentSnapshot documentSnapshot) {
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Loading(),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          // border: Border.all(color: Colors.amber, width: 3.5),
                          boxShadow: [
                            new BoxShadow(
                                color: Colors.black54,
                                blurRadius: 8.0,
                                spreadRadius: 2),
                          ],
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.0,
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
                                  radius: 65.0,
                                  backgroundColor: Colors.transparent,
                                  child: GestureDetector(
                                    onLongPress: () {
                                      _popupDialog = _createPopupDialog(
                                        documentSnapshot.data()['userimage'],
                                      );
                                      Overlay.of(context).insert(_popupDialog);
                                    },
                                    // remove the OverlayEntry from Overlay, so it would be hidden
                                    onLongPressEnd: (details) =>
                                        _popupDialog?.remove(),
                                    child: Image.network(
                                      documentSnapshot.data()['userimage'],
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent loadingProgress) {
                                        if (loadingProgress == null)
                                          return CircleAvatar(
                                            backgroundColor: Colors.transparent,
                                            radius: 75,
                                            backgroundImage: NetworkImage(
                                              documentSnapshot
                                                  .data()['userimage'],
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
                            Provider.of<Helpers>(context, listen: false)
                                .textWidget(context, 'Name',
                                    documentSnapshot.data()['name']),
                            Provider.of<Helpers>(context, listen: false)
                                .textWidget(context, 'Staff Id',
                                    documentSnapshot.data()['staffno']),
                            Provider.of<Helpers>(context, listen: false)
                                .textWidget(context, 'Designation',
                                    documentSnapshot.data()['designation']),
                            Provider.of<Helpers>(context, listen: false)
                                .textWidget(context, 'Qualification',
                                    documentSnapshot.data()['qualification']),
                            Provider.of<Helpers>(context, listen: false)
                                .textWidget(context, 'Experience',
                                    documentSnapshot.data()['experience']),
                            Provider.of<Helpers>(context, listen: false)
                                .textWidget(context, 'Specialization',
                                    documentSnapshot.data()['specialization']),
                            Provider.of<Helpers>(context, listen: false)
                                .textWidget(context, 'E-Mail',
                                    documentSnapshot.data()['useremail']),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }).toList(),
            );
          }
        },
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
