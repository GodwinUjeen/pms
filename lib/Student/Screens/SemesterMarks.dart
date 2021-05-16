import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pms/HelpersClass/Helpers.dart';
import 'package:pms/Loading.dart';
import 'package:provider/provider.dart';

class SemesterMarks extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;

  SemesterMarks({this.userDep, this.userUid, this.userYear});

  @override
  _SemesterMarksState createState() => _SemesterMarksState();
}

class _SemesterMarksState extends State<SemesterMarks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Semester Marks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.userDep)
              .collection(widget.userYear)
              .doc(widget.userUid)
              .collection('semmarks')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Loading(),
              );
            } else {
              return ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: snapshot.data.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    // print(documentSnapshot.id);

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
                      //     .collection('semmarks')
                      //     .doc(documentSnapshot.id).set(documentSnapshot.data());

                      LinkedHashMap<String, dynamic> data =
                          documentSnapshot.data()['sem'];
                      List<String> keys = data.keys.toList();
                      List<dynamic> value = data.values.toList();

                      return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(25.0, 15.0, 25.0, 10.0),
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.5,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              // border: Border.all(color: Colors.amber, width: 3.0),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30.0, 30.0, 30.0, 8.0),
                                    child: Container(
                                      height: 60.0,
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      decoration: BoxDecoration(

                                          border: Border.all(
                                              color: Colors.indigo, width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white),
                                      child: Center(
                                        child: Text(
                                          documentSnapshot.id.toUpperCase(),
                                          style: TextStyle(color:Colors.indigo.shade500,fontSize: 18.0,fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  // height:
                                  //     MediaQuery.of(context).size.height * 0.35,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30.0, 15.0, 30.0, 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Colors.indigo,
                                              width: 1.5),
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: Colors.white),
                                      child: Center(
                                        child: GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 3,
                                                  childAspectRatio: 1),
                                          padding: EdgeInsets.all(3.0),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: data.keys.length,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return ListTile(
                                              title: Text(
                                                keys[index]
                                                    .toString()
                                                    .toUpperCase(),
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                              ),
                                              subtitle: Text(
                                                value[index].toString(),
                                                style:
                                                    TextStyle(fontSize: 12.0),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      30.0, 15.0, 30.0, 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      textWidget(
                                          context,
                                          "GPA",
                                          documentSnapshot
                                              .data()['gpa']
                                              .toString()),
                                      textWidget(
                                          context,
                                          "CGPA",
                                          documentSnapshot
                                              .data()['cgpa']
                                              .toString()),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }).toList());
            }
          }),
    );
  }
}

Widget textWidget(BuildContext context, String heading, String value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(18.0, 6.0, 6.0, 18.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: Text(
            heading,
            maxLines: 2,
            style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
                color: Colors.indigo.shade400),
            textAlign: TextAlign.left,
          ),
        ),
        Text(
          value.toUpperCase(),
          maxLines: 5,
          softWrap: true,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Divider(
            thickness: 1.0,
            color: Colors.grey.shade300,
          ),
        ),
      ],
    ),
  );
}
