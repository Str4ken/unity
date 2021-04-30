import 'package:flutter/material.dart';

class MyCircularProgreesInidcator extends StatelessWidget {
  const MyCircularProgreesInidcator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
          backgroundColor: Theme.of(context).primaryColor),
    );
  }
}
