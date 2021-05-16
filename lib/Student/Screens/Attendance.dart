import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pms/Loading.dart';

class AttendanceDetails extends StatefulWidget {
  final String userDep;
  final String userYear;
  final String userUid;

  AttendanceDetails({this.userDep, this.userUid, this.userYear});

  @override
  _AttendanceDetailsState createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('student')
            .doc(widget.userDep)
            .collection(widget.userYear)
            .doc(widget.userUid)
            .collection('attendance')
            .doc('details')
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
            //     .collection('attendance')
            //     .doc('details').set(snapshot.data.data());

            double presentDay = snapshot.data.data()['present'] /
                snapshot.data.data()['workingday'] *
                100;
            double absentDay = snapshot.data.data()['absent'] /
                snapshot.data.data()['workingday'] *
                100;
            return Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.38,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    boxShadow: [
                      new BoxShadow(
                          color: Colors.black54,
                          blurRadius: 8.0,
                          spreadRadius: 2),
                    ],
                    color: Colors.white,
//border: Border.all(width: 1.5, color: Colors.indigo),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: MediaQuery.of(context).size.width * 0.4,
// color: Colors.blueAccent.shade100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
// color: Colors.grey.shade200,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Attendance'.toUpperCase(),
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo.shade500),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ),
                            Details('No.of Days Present', Colors.blue),
                            SizedBox(
                              height: 2.0,
                            ),
                            Details('No.of Days Absent', Colors.red),
                            SizedBox(
                              height: 2.0,
                            ),
                            textFieldRowBody(context, 'No.of Working Days',
                                snapshot.data.data()['workingday'].toString()),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                        child: Container(
                          decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              new BoxShadow(
                                  color: Colors.grey.shade700,
                                  blurRadius: 18.0,
                                  spreadRadius: 2),
                            ],
                          ),
                          width: MediaQuery.of(context).size.width * 0.46,
// color: Colors.redAccent.shade100,
                          child: Stack(
                            children: [
                              Center(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: PieChart(PieChartData(
                                      sections: [
                                        PieChartSectionData(
                                          color: Colors.blue,
                                          value: presentDay,
                                          title:
                                              '${presentDay.toStringAsFixed(1)}%',
                                          radius: 41.0,
                                          titleStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        PieChartSectionData(
                                          color: Colors.red,
                                          value: absentDay,
                                          title:
                                              '${absentDay.toStringAsFixed(1)}%',
                                          radius: 42.0,
                                          titleStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                      borderData: FlBorderData(show: false),
                                      centerSpaceRadius: 42,
                                      centerSpaceColor: Colors.white,
                                      sectionsSpace: 2)),
                                ),
                              ),
                              Center(
                                  child: Text(
                                'Attendance',
                                style: TextStyle(
                                    color: Colors.indigo.shade400,
                                    fontSize: 11.0,
                                    fontWeight: FontWeight.bold),
                              )),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget Details(String title, Color color) {
  return Padding(
    padding: const EdgeInsets.all(7.0),
    child: Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
        ),
        SizedBox(
          width: 20.0,
        ),
        Flexible(
            child: Text(
          title,
          maxLines: 2,
          style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
        )),
      ],
    ),
  );
}

Widget textFieldRowBody(BuildContext context, String heading, String value) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(8.0, 0.0, .0, 8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.7,
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
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            value.toUpperCase(),
            maxLines: 5,
            softWrap: true,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w400),
          ),
        ),
      ],
    ),
  );
}
