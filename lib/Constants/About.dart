import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'About',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(
              width: 8.0,
            ),
            Icon(
              Icons.info_outline_rounded,
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 15.0,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'This is a Mobile Application For Viewing Profile.',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600,color: Colors.indigo.shade500,),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Copyright ',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
                Icon(
                  Icons.copyright,
                  size: 14.0,
                ),
                Text(
                  ' PMS',
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
