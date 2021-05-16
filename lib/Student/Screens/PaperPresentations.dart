import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pms/HelpersClass/Helpers.dart';
import 'package:pms/Loading.dart';
import 'package:provider/provider.dart';

class PaperPresentation extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;

  PaperPresentation({this.userDep, this.userUid, this.userYear});

  @override
  _PaperPresentationState createState() => _PaperPresentationState();
}

class _PaperPresentationState extends State<PaperPresentation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paper Presentation'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('student')
            .doc(widget.userDep)
            .collection(widget.userYear)
            .doc(widget.userUid)
            .collection('paperpresentation')
            .doc('pp')
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
            //     .collection('paperpresentation')
            //     .doc('pp')
            //     .set(snapshot.data.data());
            return Padding(
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
                    Provider.of<Helpers>(context, listen: false).headingWidget(
                      context,
                      'Paper Presentation'.toUpperCase(),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Provider.of<Helpers>(context, listen: false).textWidget(
                        context,
                        'No. of Paper\'s Presented',
                        snapshot.data.data()['papers'].toString()),
                    Provider.of<Helpers>(context, listen: false).textWidget(
                        context,
                        'No. of Journal\'s Written',
                        snapshot.data.data()['journals'].toString()),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
