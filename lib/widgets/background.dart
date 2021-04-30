import 'package:flutter/material.dart';

class Background extends StatefulWidget {
  const Background({
    Key key,
  }) : super(key: key);

  @override
  _BackgroundState createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _gradientAnimation;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000),
    );
    _gradientAnimation =
        Tween<double>(begin: 1.5, end: 0.15).animate(_controller)
          ..addListener(() {
            setState(() {});
          });
    _controller.repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Container(
        height: deviceSize.height,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            // tileMode: TileMode.mirror,
            radius: _gradientAnimation.value,
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).backgroundColor,
            ],
          ),
        ));
  }
}
