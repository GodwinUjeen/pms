import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import '../../Loading.dart';

class InternalMarks extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;

  InternalMarks({this.userDep, this.userUid, this.userYear});

  @override
  _InternalMarksState createState() => _InternalMarksState();
}

class _InternalMarksState extends State<InternalMarks> {
  // LinkedHashMap<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    // print("internal mark");
    // print('Year: ${widget.userYear}');
    // print('Dep: ${widget.userDep}');
    // print('UID: ${widget.userUid}');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Internal Marks'),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('student')
              .doc(widget.userDep)
              .collection(widget.userYear)
              .doc(widget.userUid)
              .collection('internalmarks')
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
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Loading(),
                      );
                    } else {
                      print(documentSnapshot.id);
                      // FirebaseFirestore.instance
                      //     .collection('student')
                      //     .doc('it')
                      //     .collection('IV')
                      //     .doc('r70YGjL9csdqTgMlwsigIkL7mzm2')
                      //     .collection('internalmarks')
                      //     .doc(documentSnapshot.id)
                      //     .set(documentSnapshot.data());
                      LinkedHashMap<String, dynamic> data =
                          documentSnapshot.data();
                      List<String> keys = data.keys.toList();
                      return Padding(
                        padding:
                            const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 10.0),
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.6,
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
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  width: MediaQuery.of(context).size.width,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8.0, 18.0, 8.0, 8.0),
                                          child: Container(
                                            height: 60.0,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.indigo,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(5.0),
                                                color: Colors.white),
                                            child: Center(
                                              child: Text(
                                                documentSnapshot.id
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.indigo.shade500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  // height:
                                  //     MediaQuery.of(context).size.height * 0.185,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      Container(
                                        // color: Colors.amber,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.8,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                1.5,
                                        child: ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: data.entries.length,
                                          itemBuilder: (BuildContext context,
                                              int indexData) {
                                            // print(data.entries.length);
                                            LinkedHashMap<String, dynamic>
                                                internal = documentSnapshot
                                                    .data()[keys[indexData]];
                                            List<dynamic> val =
                                                internal.values.toList();
                                            List<String> k =
                                                internal.keys.toList();
                                            // print(internal);
                                            // print('$val,$k');
                                            // print(documentSnapshot.id);
                                            return SizedBox(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      child: Text(
                                                        keys[indexData]
                                                            .toString()
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.indigo
                                                                .shade500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.3,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.indigo,
                                                              width: 1.2),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      5.0),
                                                          color: Colors.white),
                                                      child: Center(
                                                        child: GridView.builder(
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount:
                                                                      3,
                                                                  childAspectRatio:
                                                                      1.0),
                                                          // physics:
                                                          //     NeverScrollableScrollPhysics(),
                                                          padding:
                                                              EdgeInsets.all(
                                                                  3.0),
                                                          // shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          //     crossAxisCount: 6),
                                                          itemCount: internal
                                                              .keys.length,
                                                          // separatorBuilder:
                                                          //     (context, index) {
                                                          //   return Divider();
                                                          // },
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int index) {
                                                            // print(internal.values);
                                                            return ListTile(
                                                              title: Text(
                                                                k[index]
                                                                    .toString()
                                                                    .toUpperCase(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.0),
                                                              ),
                                                              subtitle: Text(
                                                                val[index]
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.0),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
