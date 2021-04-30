import 'package:flutter/material.dart';

class UnityTitle extends StatelessWidget {
  const UnityTitle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Unity',
      style: Theme.of(context).textTheme.headline1.copyWith(shadows: [
        Shadow(
          offset: Offset(3.0, 3.0),
          blurRadius: 10.0,
          color: Colors.black,
        ),
      ]),
    );
  }
}
