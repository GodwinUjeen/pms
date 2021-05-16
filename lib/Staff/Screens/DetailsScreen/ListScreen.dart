import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pms/Loading.dart';
import 'package:pms/Staff/Screens/DetailsScreen/AltSProfile.dart';
import 'package:pms/Staff/Screens/DetailsScreen/DetailsScreen.dart';
import 'package:pms/Staff/StaffHomePage.dart';
import 'package:pms/Student/Screens/Profile.dart';

class ListScreen extends StatefulWidget {
  final String year;
  final String dep;

  ListScreen({this.year, this.dep});

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context);
        return null;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Students List'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.dep)
              .collection(widget.year)
              .orderBy('rollno')
              .snapshots(),
          builder: (context, snapshots) {
            if (snapshots.connectionState == ConnectionState.waiting) {
              return Center(
                child: Loading(),
              );
            } else {
              if (snapshots.data.docs.length == 0) {
                return Center(
                  child: Container(
                    child: Text('No data'),
                  ),
                );
              } else {
                return Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 10.0),
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
                            border: Border.all(color: Colors.amber, width: 2.0),
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white),
                        child: Center(
                            child: Text(
                          '${widget.year.toUpperCase()} YEAR ${widget.dep.toUpperCase()}',
                          style: TextStyle(fontSize: 20.0, color: Colors.brown),
                        )),
                      ),
                    ),
                    GridView(
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          childAspectRatio: MediaQuery.of(context).size.width /
                              (MediaQuery.of(context).size.height / 4.5),
                          crossAxisSpacing: 8),
                      padding: EdgeInsets.all(10.0),
                      children: snapshots.data.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: Loading(),
                          );
                        } else {
                          return Container(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  new BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4.0,
                                      spreadRadius: 1),
                                ],
                                border: Border.all(
                                    color: Colors.amberAccent, width: 1.5),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.white),
                            child: Center(
                              child: ListTile(
                                onTap: () {
                                  // print(documentSnapshot.data()['rollno']);
                                  // print(documentSnapshot.id);
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      child: AltSProfile(
                                        userDep: widget.dep,
                                        userUid: documentSnapshot.id,
                                        userYear: widget.year,
                                        rollNo:
                                            documentSnapshot.data()['rollno'],
                                        image: documentSnapshot
                                            .data()['userimage'],
                                        userName:
                                            documentSnapshot.data()['name'],
                                        title:
                                            'Student Profile (${documentSnapshot.data()['rollno']})',
                                      ),
                                      type: PageTransitionType.leftToRight,
                                    ),
                                  );
                                },
                                leading: Container(
                                  child: documentSnapshot.data()['userimage'] !=
                                          null
                                      ? Image.network(
                                          documentSnapshot.data()['userimage'],
                                          scale: 1.0,
                                          height: 50.0,
                                          width: 50.0,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
                                            return CircularProgressIndicator(
                                              // valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes
                                                  : null,
                                            );
                                          },
                                        )
                                      : Icon(
                                          Icons.person,
                                          size: 38.0,
                                        ),
                                ),
                                title: Text(
                                  documentSnapshot
                                      .data()['rollno']
                                      .toString()
                                      .toUpperCase(),
                                  style: TextStyle(fontSize: 13.0),
                                ),
                                subtitle: Text(
                                  documentSnapshot
                                      .data()['name']
                                      .toString()
                                      .toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 11.0),
                                ),
                              ),
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  ],
                );
              }
            }
          },
        ),
      ),
    );
  }
}

// Center(
// child: Text(
// "${widget.year},${widget.dep}",
// style: TextStyle(fontSize: 40.0),
// )),
