import 'package:flutter/material.dart';
import 'package:unity/constants.dart';

class MyLightCard extends StatelessWidget {
  final Widget child;

  MyLightCard({this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: uDefaultElevation,
      shadowColor: uBackgroundColor1.withAlpha(255),
      color: uBackgroundColor2.withAlpha(125),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(uDefaultBorderRadius),
      ),
      child: child,
    );
  }
}
