import 'package:flutter/material.dart';

class Helpers with ChangeNotifier {
  Widget textWidget(BuildContext context, String heading, String value) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 6.0, 6.0, 18.0),
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

  Widget headingWidget(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Container(
        height: 47.0,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade200,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade500),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}
