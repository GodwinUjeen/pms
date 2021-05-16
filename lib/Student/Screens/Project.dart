import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:pms/HelpersClass/Helpers.dart';
import 'package:pms/Loading.dart';
import 'package:provider/provider.dart';

class ProjectDetails extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;

  ProjectDetails({this.userDep, this.userUid, this.userYear});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Project Details'),
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.userDep)
              .collection(widget.userYear)
              .doc(widget.userUid)
              .collection('projects')
              .doc('project')
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
              //     .collection('projects')
              //     .doc('project')
              //     .set(snapshot.data.data());
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.68,
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
                        'Project '.toUpperCase(),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Provider.of<Helpers>(context, listen: false).textWidget(
                          context,
                          'No. of Project\'s Done',
                          snapshot.data.data()['count'].toString()),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Project Description",
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.indigo.shade400),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: 220.0,
                              padding: EdgeInsets.all(8.0),
                              decoration: new BoxDecoration(
                                  border: Border.all(
                                      width: 1.5,
                                      color: Colors.indigo.shade400),
                                  borderRadius: BorderRadius.circular(5.0)),
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: Text(
                                snapshot.data.data()['desc'],
                                textAlign: TextAlign.justify,
                                maxLines: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }
}
