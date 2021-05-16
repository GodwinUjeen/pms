import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pms/HelpersClass/Helpers.dart';
import 'package:pms/Loading.dart';
import 'package:provider/provider.dart';

class Seminars extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;

  Seminars({this.userDep, this.userUid, this.userYear});

  @override
  _SeminarsState createState() => _SeminarsState();
}

class _SeminarsState extends State<Seminars> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Seminar Details'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.userDep)
              .collection(widget.userYear)
              .doc(widget.userUid)
              .collection('seminars')
              .doc('semi')
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
              //     .collection('seminars')
              //     .doc('semi')
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
// border: Border.all(width: 1.5, color: Colors.indigo),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Provider.of<Helpers>(context, listen: false)
                          .headingWidget(
                        context,
                        'Seminars'.toUpperCase(),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Provider.of<Helpers>(context, listen: false).textWidget(
                          context,
                          'No. of Seminars\'s Attended',
                          snapshot.data.data()['attended'].toString()),
                      Provider.of<Helpers>(context, listen: false).textWidget(
                          context,
                          'No. of Seminar\'s Organized',
                          snapshot.data.data()['organized'].toString()),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}
