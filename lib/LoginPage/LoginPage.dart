import 'package:flutter/material.dart';
import 'package:pms/Constants/Background.dart';
import 'package:pms/Constants/ConstantColors.dart';
import 'package:pms/LoginPage/LoginUi.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: constantColors.whiteColor,
      body: Stack(
        children: [
          Background(),
          LoginUi(),
        ],
      ),
    );
  }
}
