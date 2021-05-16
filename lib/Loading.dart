import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pms/Constants/ConstantColors.dart';

class Loading extends StatelessWidget {
  final ConstantColors constantColors = ConstantColors();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 250.0,
        width: 250.0,
        color: constantColors.transparent,
        child: Center(child: Lottie.asset('assets/animation/loading.json')),
      ),
    );
  }
}
