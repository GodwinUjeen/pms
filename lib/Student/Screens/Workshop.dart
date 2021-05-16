import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pms/HelpersClass/Helpers.dart';
import 'package:provider/provider.dart';

import '../../Loading.dart';

class WorkshopDetails extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;

  WorkshopDetails({this.userDep, this.userUid, this.userYear});

  @override
  _WorkshopDetailsState createState() => _WorkshopDetailsState();
}

class _WorkshopDetailsState extends State<WorkshopDetails> {
  OverlayEntry _popupDialog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workshop Details'),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.userDep)
              .collection(widget.userYear)
              .doc(widget.userUid)
              .collection('workshops')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Loading(),
              );
            } else {
              // FirebaseFirestore.instance
              //     .collection('student')
              //     .doc('it')
              //     .collection('IV')
              //     .doc('r70YGjL9csdqTgMlwsigIkL7mzm2')
              //     .collection('workshops')
              //     .doc('workshop')
              //     .set(snapshot.data.docs.first.data());
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.38,
                      decoration: new BoxDecoration(
                          boxShadow: [
                            new BoxShadow(
                                color: Colors.black54,
                                blurRadius: 8.0,
                                spreadRadius: 2),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Provider.of<Helpers>(context, listen: false)
                              .headingWidget(
                                  context, 'Workshops'.toUpperCase()),
                          SizedBox(
                            height: 10.0,
                          ),
                          Provider.of<Helpers>(context, listen: false)
                              .textWidget(
                                  context,
                                  'No. of Workshops attended',
                                  snapshot.data.docs.first
                                      .data()['attended']
                                      .toString()),
                          Provider.of<Helpers>(context, listen: false)
                              .textWidget(
                                  context,
                                  'No. of Workshops organized',
                                  snapshot.data.docs.first
                                      .data()['organized']
                                      .toString()),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.47,
                      width: MediaQuery.of(context).size.width,
                      decoration: new BoxDecoration(
                        boxShadow: [
                          new BoxShadow(
                              color: Colors.black54,
                              blurRadius: 8.0,
                              spreadRadius: 2),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                // borderRadius: BorderRadius.circular(5.0),
                              ),
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                              child: Provider.of<Helpers>(context).headingWidget(context, 'Certificates Earned'),
                            ),
                          ),

                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                            width: MediaQuery.of(context).size.width,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('student')
                                    .doc(widget.userDep)
                                    .collection(widget.userYear)
                                    .doc(widget.userUid)
                                    .collection('workshops')
                                    .doc('workshop')
                                    .collection('certimages')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                      child: Loading(),
                                    );
                                  } else {
                                    return ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: snapshot.data.docs.map(
                                          (DocumentSnapshot documentSnapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: Loading(),
                                          );
                                        } else {
                                          return Row(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.35,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.65,
                                                  child: GestureDetector(
// keep the OverlayEntry instance, and insert it into Overlay
                                                    onLongPress: () {
                                                      _popupDialog =
                                                          _createPopupDialog(
                                                              documentSnapshot
                                                                      .data()[
                                                                  'image']);
                                                      Overlay.of(context)
                                                          .insert(_popupDialog);
                                                    },
                                                    // remove the OverlayEntry from Overlay, so it would be hidden
                                                    onLongPressEnd: (details) =>
                                                        _popupDialog?.remove(),
                                                    child: Image.network(
                                                      documentSnapshot
                                                          .data()['image'],
                                                      fit: BoxFit.contain,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
                                                        return Center(
                                                          child:
                                                              CircularProgressIndicator(
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
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 5.0, bottom: 5.0),
                                                child: VerticalDivider(
                                                  thickness: 1.5,
                                                  color: Colors.grey.shade300,
                                                ),
                                              ),
                                            ],
                                          );
                                        }
                                      }).toList(),
                                    );
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
